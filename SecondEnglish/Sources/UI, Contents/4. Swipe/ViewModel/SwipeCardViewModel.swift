//
//  SwipeCardViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import Foundation
import Combine

class SwipeCardViewModel: ObservableObject {
    var cancellable = Set<AnyCancellable>()
    static let shared = SwipeCardViewModel()
    
    @Published var isFirst: Bool = false
    
    //alert
    @Published var popupMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    // Category TabBar
    @Published var categoryTabIndex: Int = 0
    @Published var moveCategoryTab: Bool = false
    
    // View Data
    @Published var typeList: [SwipeCategoryList] = []
    @Published var fixedSwipeList_0: [SwipeDataList] = [] // 처음 한 번만 저장
    @Published var swipeList: [SwipeDataList] = []
    @Published var countOfSwipeList: Double = 0
    @Published var mainCategoryList: [String] = []
    @Published var subCategoryList: [SubCategoryListModel] = []
    @Published var cardPercentArr: [SwipeDataList] = [] // 카드 퍼센트 계산용
    
    // NotificationCenter를 통해 탭 이동시키는 변수
    @Published var isNotificationCenter: Bool = false
    @Published var noti_selectedMainCategoryName: String = ""
    @Published var noti_selectedSubCategoryIndex: Int = 0
    
    // '알고있음/학습중' 로컬 데이터
    @Published var allMyMainCategoryList: [MyAllSubCategoryCountModel] = []
    @Published var knowCardLocalData: [KnowCardLocalInfo] = []
    
    
    init() {
//        NotificationCenter.default.addObserver(forName: Notification.Name("workCompleted"), object: nil, queue: nil) { _ in
//          // Handler ...
//            fLog("idpil::: Work Completed!")
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustMovedCategoryData(_:)),
                                               name: NSNotification.Name(rawValue: DefineNotification.moveToSwipeTab),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustCardEditDone(_:)),
                                               name: NSNotification.Name(rawValue: DefineNotification.cardEditSuccess),
                                               object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(adjustNewestData(_:)),
//                                               name: NSNotification.Name(rawValue: DefineNotification.minuteFromNewest),
//                                               object: nil)
    }
    
    @objc func adjustMovedCategoryData(_ notification: Notification) {
        if let subCategoryIndexAndName: [String: Any] = notification.userInfo![DefineKey.subCategoryIndexAndName] as? [String: Any] {
            
            self.categoryTabIndex = subCategoryIndexAndName["subCategoryIdx"] as? Int ?? 0
            self.noti_selectedMainCategoryName = subCategoryIndexAndName["mainCategoryName"] as? String ?? ""
            
            self.isNotificationCenter = true
            
            
//            self.categoryTabIndex
//            self.moveCategoryTab = true
//            
//            self.requestSwipeListByCategory(
//                category: subCategoryName,
//                sortType: .Latest,
//                isSuccess: { success in
//                    //
//                }
//            )
            
            
//            ApiControl.listOne(idx: categoryIdx) { oneResult in
//                
//                CommonFunction.offPageLoading()
//                
//                var minuteId = 0
//                var selectedMinute: [MinuteData] = []
//                if let detail = oneResult.dataObj?.minuteDetail {
//                    minuteId = detail.idx
//                    selectedMinute = [detail]
//                }
//                
//                ApiControl.minuteList(page: 1,
//                                      sortingNum: MinuteSortType.Latest.rawValue,
//                                      nextCheck: true,
//                                      searchText: "") { result in
//                    
//                    CommonFunction.offPageLoading()
//                    
//                    self.minuteList = result
//                    
//                    let minuteList = (result.dataObj?.minuteList ?? []).filter { $0.idx != minuteId }
//                    self.minuteList?.dataObj?.minuteList = selectedMinute + minuteList
//                    
//                    self.insertAd()
//                    self.tbView.reloadData()
//                    self.tbView.setContentOffset(.zero, animated: false)
//                    
//                    if let cell = self.tbView.visibleCells.first as? MinuteCell {
//                        cell.play()
//                    }
//                }
//                
//            }
            
            
            
            
            
        }
    }
    
    @objc func adjustCardEditDone(_ notification: Notification) {
        if let editedCard: [String: Any] = notification.userInfo![DefineKey.cardEditDone] as? [String: Any] {
            
            let editedIdx = editedCard["idx"] as? Int ?? -1
            let korean = editedCard["korean"] as? String ?? ""
            let english = editedCard["english"] as? String ?? ""
            
            for (index, item) in swipeList.enumerated() {
                if editedIdx == item.idx {
                    swipeList[index].korean = korean
                    swipeList[index].english = english
                }
            }
        }
    }
    
    //MARK: - 메인 카테고리 조회
    func requestMainCategory(isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeMainCategory()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                
            } receiveValue: { value in
                if value.code == 200 {
                    // 카테고리 헤더 데이터
                    for type in value.data ?? [] {
                        self.mainCategoryList.append(type.type2 ?? "")
                    }
                    
                    // 중복제거
                    self.mainCategoryList = self.mainCategoryList.uniqued()
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 현재 메인 카테고리의 '서브 카테고리 리스트' 가져오기
    func requestSubCategory(isInit: Bool, type2: String, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeSubCategory(type2: type2)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                
            } receiveValue: { value in
                if value.code == 200 {
                    
                    if isInit {
                        self.subCategoryList = []
                        
                        // NotificationCenter로 넘어온 경우에는 adjustMovedCategoryData에서 categoryTabIndex 값을 저장시키기 때문에 여기서 초기화 하면 안 됨
                        if !self.isNotificationCenter {
                            self.categoryTabIndex = 0
                        }
                        
                    }
                    
                    self.typeList = value.data ?? []
                    
                    
                    
                    // 카테고리 헤더 데이터
                    for type in value.data ?? [] {
                        self.subCategoryList.append(
                            SubCategoryListModel(
                                type3: type.type3 ?? "",
                                type3_sort_num: type.type3_sort_num ?? 0
                            )
                        )
                    }
                    
                    // 중복제거
                    self.subCategoryList = self.subCategoryList.uniqued()
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    
    //MARK: - 현재 서브 카테고리의 영문 리스트 조회 (회원용)
    func requestSwipeListByCategory(main_category: String, type3_sort_num: Int, sortType: SwipeCardSortType, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeListByCategory(main_category: main_category, type3_sort_num: type3_sort_num)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    //self.swipeList = value.data ?? []
                    //fLog("idpil::: 쌍따옴표 확인 : \(value.data?.grammar)")
                    
                    guard var arr = value.data?.list else { return }
                    guard let grammar = value.data?.grammar else { return }
                    //printPrettyJSON(keyWord: "idpil grammar :::\n", from: grammar)
                    BottomSheetManager.shared.grammarInfo = grammar
                    
                    
                    switch(sortType) {
                    case .Latest:
                        arr = arr.reversed()
                    case .Oldest:
                        arr = arr
                    }
                    
                    for (index, _) in arr.enumerated() {
                        arr[index].customId = index + 1
                    }
                    //fLog("idpil::: arr : \(arr)")
                    self.swipeList = arr
                    self.fixedSwipeList_0 = arr // 처음 한 번만 저장
                    self.countOfSwipeList = Double(arr.count)
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 현재 서브 카테고리의 영문 리스트 조회 (게스트용)
    func requestSwipeListByCategoryForGuest(main_category: String, type3_sort_num: Int, sortType: SwipeCardSortType, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeListByCategoryForGuest(main_category: main_category, type3_sort_num: type3_sort_num)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    //self.swipeList = value.data ?? []
                    //fLog("idpil::: 쌍따옴표 확인 : \(value.data?.grammar)")
                    
                    guard var arr = value.data?.list else { return }
                    guard let grammar = value.data?.grammar else { return }
                    //printPrettyJSON(keyWord: "idpil grammar :::\n", from: grammar)
                    BottomSheetManager.shared.grammarInfo = grammar
                    
                    
                    switch(sortType) {
                    case .Latest:
                        arr = arr.reversed()
                    case .Oldest:
                        arr = arr
                    }
                    
                    for (index, _) in arr.enumerated() {
                        arr[index].customId = index + 1
                    }
                    //fLog("idpil::: arr : \(arr)")
                    self.swipeList = arr
                    self.fixedSwipeList_0 = arr // 처음 한 번만 저장
                    self.countOfSwipeList = Double(arr.count)
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 영어카드 좋아요 적용
    func likeCard(cardIdx: Int, isLike: Int, clickIndex: Int, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.likeCard(cardIdx: cardIdx, isLike: isLike)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    // [좋아요 상태 업데이트]
                    // 좋아요 요청 -> 1
                    if isLike == 1 {
                        self.swipeList[clickIndex].isLike = true
                    }
                    // 좋아요 취소 요청 -> 0
                    else if isLike == 0 {
                        self.swipeList[clickIndex].isLike = false
                    }
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 내가 좋아요한 카드 리스트 조회
    func requestMyCardList(isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getMyLikeCardList()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    fLog("idpil::: 내가 좋아요한 카드 리스트 조회")
                    fLog("idpil::: value : \(value)")
                    
                    
                    
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 신고하기 카테고리 리스트 조회
    func requestReportList(isSuccess: @escaping([ReportListData], Bool) -> Void) {
        ApiControl.getReportList()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess([], false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    isSuccess(value.data, true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카드 신고하기
    func reportCard(targetUid: String, targetCardIdx: Int, reportCode: Int, isDone: @escaping() -> Void) {
        ApiControl.doReportCard(targetUid: targetUid, targetCardIdx: targetCardIdx, reportCode: reportCode)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    if let message = value.message {
                        self.popupMessage = message
                        isDone()
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카드 차단/차단해제
    func blockCard(cardIdx: Int, isBlock: String, isDone: @escaping() -> Void) {
        ApiControl.doBlockCard(cardIdx: cardIdx, isBlock: isBlock)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    if let message = value.message {
                        self.popupMessage = message
                        isDone()
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 유저 차단/차단해제
    func blockUser(targetUid: String, targetNickname: String, isBlock: String, isDone: @escaping() -> Void) {
        ApiControl.doBlockUser(targetUid: targetUid, targetNickname: targetNickname, isBlock: isBlock)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    if let message = value.message {
                        self.popupMessage = message
                        isDone()
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellable)
    }
    
    
    //MARK: - 카드 삭제
    func deleteCard(idx: Int, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.deleteCard(idx: idx)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    if value.success ?? false {
                        isSuccess(true)
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isSuccess(false)
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 알고 있는 카드 추가
    /**
     * 일단 통신해서 쓰기/읽기 완성했는데,
     * 생각해보니 처음부터 끝까지 완주하는 유저들이 많이 없을 거 같기 때문에
     * 일단, 서버에 저장하는 것 보단, 로컬에서 변수에 담아서 보여주는 방향으로 한다.
     */
    func knowCard(targetCardMainCategory: String, targetCardSubCategory: String, targetCardIdx: Int, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.knowCard(targetCardMainCategory: targetCardMainCategory, targetCardSubCategory: targetCardSubCategory, targetCardIdx: targetCardIdx)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    if value.success ?? false {
                        isSuccess(true)
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isSuccess(false)
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 알고 있는 카드 읽기
    func readKnowCard(targetCardMainCategory: String, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.readKnowCard(targetCardMainCategory: targetCardMainCategory)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    if value.success ?? false {
                        isSuccess(true)
                        fLog("idpil::: 알고 있는 카드 읽기 : \(value.data)")
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isSuccess(false)
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 메인 카테고리 기준 내 모든 문장 목록
    func readMyAllCategories(mainCategory: String, isDone: @escaping() -> Void) {
        ApiControl.readMyAllCategories(mainCategory: mainCategory)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    
                    guard let arr = value.data else {
                        isDone()
                        return
                    }
                    
                    self.allMyMainCategoryList = self.convertToDoneViewModel(from: arr)
                    //fLog("idpil::: allMyMainCategoryList : \(self.allMyMainCategoryList)")
                    
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellable)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - 함수 모음
    
    func shuffleSwipeList() {
        var dummyArr = self.swipeList
        dummyArr.shuffle()
        
        for (index, _) in self.swipeList.enumerated() {
            dummyArr[index].customId = index + 1
        }
        
        self.swipeList = dummyArr
    }
    
    func cutSwipeList(percent: CGFloat, sortType: SwipeCardCutSortType, isDone: ()->Void) {
        
//        let thirtyPercent = sliceArray(exampleArray, by: 0.3) // 70% 자르기
//        let fiftyPercent = sliceArray(exampleArray, by: 0.5) // 50% 자르기
//        let seventyPercent = sliceArray(exampleArray, by: 0.7) // 30% 자르기
        self.swipeList = sliceArray(self.swipeList, by: percent, sortType: sortType)
        
        var dummyArr = self.swipeList
        
        for (index, _) in self.swipeList.enumerated() {
            dummyArr[index].customId = index + 1
        }
        
        self.swipeList = dummyArr
        //self.fixedSwipeList_0 = dummyArr // 처음 한 번만 저장
        self.countOfSwipeList = Double(self.fixedSwipeList_0.count)
        
        //printPrettyJSON(keyWord: "idpil::: self.swipeList :::\n", from: self.swipeList)
        
        
        isDone()
    }
    
    // 배열 자르기
    /**
     * [ChatGPT]
     * Swift에서 배열을 특정 비율로 자르려면, 배열의 전체 길이에 원하는 비율을 곱하여 얻은 인덱스를 사용하여 배열의 일부를 추출할 수 있습니다. 예를 들어, 배열을 30%, 50%, 70% 만큼 자르기 위해서는 각각 전체 길이의 0.3, 0.5, 0.7을 곱한 후, Int 타입으로 변환하여 정수 인덱스를 얻어야 합니다. 이 인덱스를 사용하여 배열의 시작부터 해당 인덱스까지의 부분을 추출할 수 있습니다.
     *
     * 이 코드는 먼저 sliceArray라는 함수를 정의합니다. 이 함수는 배열과 자르고자 하는 비율을 입력으로 받아, 해당 비율만큼 배열의 앞부분을 추출하여 반환합니다. 예제에서는 exampleArray라는 배열을 생성하고, 이 배열을 30%, 50%, 70% 만큼 각각 자른 결과를 출력합니다.
     
       위 코드의 sliceArray 함수는 제네릭을 사용하여 어떤 타입의 배열이든 처리할 수 있도록 설계되었습니다. guard문을 사용하여 입력된 배열이 비어 있지 않고, 비율이 0보다 큰 경우에만 작업을 수행하도록 합니다. 배열의 길이에 비율을 곱한 후, Int로 변환하여 배열의 시작부터 계산된 인덱스까지의 부분 배열을 반환합니다.
     */
    func sliceArray<T>(_ array: [T], by percentage: Double, sortType: SwipeCardCutSortType) -> [T] {
        
        guard !array.isEmpty, percentage > 0 else { return [] }
        let endIndex = Int(Double(array.count) * percentage)
        //fLog("idpil::: array.count : \(array.count)")
        //fLog("idpil::: endIndex : \(endIndex)")
        
        if sortType == .FrontCut {
            // 앞에서부터 자르기
            return Array(array.prefix(endIndex))
        }
        else if sortType == .BackCut {
            // 뒤에서부터 자르기
            return Array(array.suffix(endIndex))
        }
        else if sortType == .RandomCut {
            // 랜덤 자르기
            return Array(array.shuffled().prefix(endIndex))
        }
        else {
            return []
        }
    }
    
    // 더보기 - 사용자 차단
    // 카드 리스트에서 차단한 사용자 카드들 모두 제거하기
    func removeUserFromSwipeList(targetUid: String, isDone: ()->Void) {
        //printPrettyJSON(keyWord: "idpil::: self.swipeList :::\n", from: self.swipeList)
        
        self.swipeList.removeAll(where: { $0.uid == targetUid })
        
        isDone()
    }
    
    // 메인 카테고리 기준 내 모든 문장 목록 -> 서브 카테고리별로 개수로 정리
    func convertToDoneViewModel(from dataList: [SwipeDataList]) -> [MyAllSubCategoryCountModel] {
        var typeCount = [String: (firstIndex: Int, count: Int)]() // type 값을 키로 하고, (첫 등장 인덱스, 등장 횟수)를 값으로 하는 딕셔너리
        var order = [String]() // 순서를 기록하기 위한 배열

        // 각 요소의 type에 대해 등장 횟수를 셈
        for (index, data) in dataList.enumerated() {
            if let count = typeCount[data.type3 ?? ""] {
                typeCount[data.type3 ?? ""] = (count.firstIndex, count.count + 1)
            } else {
                typeCount[data.type3 ?? ""] = (index, 1)
                order.append(data.type3 ?? "") // 처음 등장하는 type만 순서 배열에 추가
            }
        }
        
        // 순서 정보를 유지하면서 MyAllSubCategoryCountModel 배열로 변환
        var result = [MyAllSubCategoryCountModel]()
        for type3 in order {
            if let info = typeCount[type3] {
                result.append(MyAllSubCategoryCountModel(type3: type3, count: info.count))
            }
        }
        
        return result
    }
    
    func setInitKnowCardList() {
        knowCardLocalData = []
        
        for item in allMyMainCategoryList {
            knowCardLocalData.append(
                KnowCardLocalInfo(
                    subCategory: item.type3,
                    totalCount: item.count,
                    swipeCount: 0,
                    knowCount: 0
                )
            )
        }
        //fLog("idpil::: knowCardLocalData : \(knowCardLocalData)")
    }
    
    func addKnowCardList(_ card: SwipeDataList, type swipeType: CardSwipeType, isDone: ()->Void) {
        var swipeCount: Int = 0
        var knowCount: Int = 0
        
        switch swipeType {
        case .learning: // 학습 중
            swipeCount = 1
            knowCount = 0
        case .know: // 알고 있음
            swipeCount = 1
            knowCount = 1
        }
        
        
        // 해당 sub 카테고리 정보 가져오기
        // filter : 컨테이너 내부의 값을 걸러서 새로운 컨테이너로 추출하는 메소드. 반환 타입은 Bool이며, true일 때 값을 포함한다.
        let categoryInfoList = knowCardLocalData.filter { $0.subCategory == (card.type3 ?? "") }
        
        // map : 기존 데이터를 변형하여 새로운 컨테이너를 생성하는 것
        let categoryInfoItem = categoryInfoList.map {
            KnowCardLocalInfo(
                subCategory: $0.subCategory,
                totalCount: $0.totalCount,
                swipeCount: $0.swipeCount + swipeCount,
                knowCount: $0.knowCount + knowCount
            )
        }
        //fLog("idpil::: categoryInfoItem : \(categoryInfoItem)")
        
        for (index, item) in knowCardLocalData.enumerated() {
            if (card.type3 ?? "") == item.subCategory {
                // categoryInfoItem 은 반환되는 형태가 [KnowCardLocalInfo] 이기 때문에 0번째 인덱스로 가져와야 됨
                if categoryInfoItem.count == 1 {
                    knowCardLocalData[index] = categoryInfoItem[0]
                }
            }
        }
        //fLog("idpil::: knowCardLocalData : \(knowCardLocalData)")
        
        
        
        
        
        
        /**
         * 일단 통신해서 쓰기/읽기 완성했는데,
         * 생각해보니 처음부터 끝까지 완주하는 유저들이 많이 없을 거 같기 때문에
         * 일단, 서버에 저장하는 것 보단, 로컬에서 변수에 담아서 보여주는 방향으로 한다.
         */
//        self.knowCard(
//            targetCardMainCategory: card.type2 ?? "",
//            targetCardSubCategory: card.type3 ?? "",
//            targetCardIdx: card.idx ?? 0,
//            isSuccess: { isSuccess in
//                //
//                
//                // 읽기 테스트
//                self.readKnowCard(
//                    targetCardMainCategory: card.type2 ?? "",
//                    isSuccess: { isSuccess in
//                        //
//                    }
//                )
//            }
//        )
        
    }
    
}
