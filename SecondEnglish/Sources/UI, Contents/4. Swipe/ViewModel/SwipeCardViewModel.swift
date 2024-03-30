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
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    // Category TabBar
    @Published var categoryTabIndex: Int = 0
    @Published var moveCategoryTab: Bool = false
    
    // View Data
    @Published var typeList: [SwipeCategoryList] = []
    @Published var fixedSwipeList_0: [SwipeDataList] = [] // 처음 한 번만 저장
    @Published var percentCountSwipeList: [SwipeDataList] = [] // 계산용
    @Published var swipeList: [SwipeDataList] = []
    @Published var countOfSwipeList: Double = 0
    @Published var mainCategoryList: [String] = []
    @Published var subCategoryList: [String] = []
    @Published var cardPercentArr: [SwipeDataList] = [] // 카드 퍼센트 계산용
    
    // Card Like
    @Published var myLikeCardIdxList: [Int] = []
    
    // NotificationCenter를 통해 탭 이동시키는 변수
    @Published var isNotificationCenter: Bool = false
    @Published var noti_selectedMainCategoryName: String = ""
    @Published var noti_selectedSubCategoryIndex: Int = 0
    
    
    init() {
//        NotificationCenter.default.addObserver(forName: Notification.Name("workCompleted"), object: nil, queue: nil) { _ in
//          // Handler ...
//            fLog("idpil::: Work Completed!")
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustMovedCategoryData(_:)),
                                               name: NSNotification.Name(rawValue: DefineNotification.moveToSwipeTab),
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
    
    
    
    //MARK: - 메인 카테고리 조회
    func requestMainCategory(isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeMainCategory()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
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
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카테고리 조회
    func requestCategory(isInit: Bool, category: String, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeCategory(category: category)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
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
                        self.subCategoryList.append(type.type3 ?? "")
                    }
                    
                    // 중복제거
                    self.subCategoryList = self.subCategoryList.uniqued()
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 영어카드 모든 리스트 조회
    func requestSwipeList(sortType: SwipeCardSortType, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeList()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    //self.swipeList = value.data ?? []
                    
                    guard let arr = value.data?.list else { return }
                    
//                    var dummyArr = arr
//
//                    for (index, _) in arr.enumerated() {
//                        dummyArr[index].id = index + 1
//                    }
//                    //fLog("로그확인::: dummyArr : \(dummyArr)")
//                    self.swipeList = dummyArr
                    
                    
                    
                    var dummyArr = arr
//                    
                    var dumArr: [String] = []
//                    dumArr.append("초급부터")
//                    dumArr.append("고급부터")
//                    dumArr.append("무작위")
                    for element in arr {
                        dumArr.append(element.type3 ?? "")
                    }
                    self.subCategoryList = dumArr.uniqued()
                    
                    
                    
                    
                    switch(sortType) {
                    case .Latest:
                        dummyArr = dummyArr.reversed()
                    case .Oldest:
                        dummyArr = dummyArr
                    }
                    
                    
                    /**
                     *
                     */
                    for (index, _) in arr.enumerated() {
                        dummyArr[index].customId = index + 1
                    }
                    //fLog("로그확인::: dummyArr : \(dummyArr)")
                    self.swipeList = dummyArr
                    self.percentCountSwipeList = dummyArr
                    self.fixedSwipeList_0 = dummyArr // 처음 한 번만 저장
                    self.countOfSwipeList = Double(dummyArr.count)
                    
                    
                    
                    
                    
                    // 처음 Step부터 시작하기
                    self.resetSwipeList(category: self.subCategoryList[0])
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카테고리별 영어문장 조회
    func requestSwipeListByCategory(main_category: String, sub_category: String, sortType: SwipeCardSortType, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeListByCategory(main_category: main_category, sub_category: sub_category)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    //self.swipeList = value.data ?? []
                    //fLog("idpil::: 쌍따옴표 확인 : \(value.data?.grammar)")
                    
                    guard var arr = value.data?.list else { return }
                    guard let grammar = value.data?.grammar else { return }
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
                    //fLog("로그확인::: arr : \(arr)")
                    self.swipeList = arr
                    self.percentCountSwipeList = arr
                    //self.fixedSwipeList_0 = arr // 처음 한 번만 저장
                    self.countOfSwipeList = Double(arr.count)
                    
                    
                    
                    
                    
                    // 처음 Step부터 시작하기
                    //self.resetSwipeList(category: self.topTabBarList[0])
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
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
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
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
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 불러온 영어카드 리스트에서 좋아요 적용
    func requestMyLikeCardList(uid: String, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getMyLikeCardList(uid: uid)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    //self.swipeList = value.data ?? []
                    
//                    guard let liked_card_arr = value.data else { return }
//                    fLog("idpil::: 내 좋아요 내역 : \(liked_card_arr)")
                    self.myLikeCardIdxList = value.data?.liked_card_arr ?? []
                    
//                    var dummyArr = arr
//
//                    for (index, _) in arr.enumerated() {
//                        dummyArr[index].id = index + 1
//                    }
//                    //fLog("로그확인::: dummyArr : \(dummyArr)")
//                    self.swipeList = dummyArr
                    
                    
                    
                    // 좋아요 상태 업데이트
                    for (index, element) in self.swipeList.enumerated() {
                        if self.myLikeCardIdxList.contains(element.idx ?? 0) {
                            self.swipeList[index].isLike = true
                        }
                    }
                    
                    
                    
                    
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 내가 좋아요한 카드 리스트 조회
    func requestMyCardList(isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getMyCardList()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    fLog("idpil::: 내가 좋아요한 카드 리스트 조회")
                    fLog("idpil::: value : \(value)")
                    
                    
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
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
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess([], false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    isSuccess(value.data, true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카드 신고하기
    func reportCard(targetUid: String, targetCardIdx: Int, reportCode: Int, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.doReportCard(targetUid: targetUid, targetCardIdx: targetCardIdx, reportCode: reportCode)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 카드 차단하기
    func blockCard(cardIdx: Int, isBlock: Int, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.doBlockCard(cardIdx: cardIdx, isBlock: isBlock)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 유저 차단하기
    func blockUser(targetUid: String, targetNickname: String, isBlock: Bool, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.doBlockUser(targetUid: targetUid, targetNickname: targetNickname, isBlock: isBlock)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                isSuccess(false)
            } receiveValue: { value in
                if value.code == 200 {
                    
                    isSuccess(true)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
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
    
    func cutSwipeList(percent: CGFloat) {
        
//        let thirtyPercent = sliceArray(exampleArray, by: 0.3) // 70% 자르기
//        let fiftyPercent = sliceArray(exampleArray, by: 0.5) // 50% 자르기
//        let seventyPercent = sliceArray(exampleArray, by: 0.7) // 30% 자르기
        self.swipeList = sliceArray(self.swipeList, by: percent)
        
        
        var dummyArr = self.swipeList
        
        for (index, _) in self.swipeList.enumerated() {
            dummyArr[index].customId = index + 1
        }
        
        self.swipeList = dummyArr
        self.percentCountSwipeList = dummyArr
        self.countOfSwipeList = Double(self.swipeList.count)
    }
    
    // 배열 자르기
    /**
     * [ChatGPT]
     * Swift에서 배열을 특정 비율로 자르려면, 배열의 전체 길이에 원하는 비율을 곱하여 얻은 인덱스를 사용하여 배열의 일부를 추출할 수 있습니다. 예를 들어, 배열을 30%, 50%, 70% 만큼 자르기 위해서는 각각 전체 길이의 0.3, 0.5, 0.7을 곱한 후, Int 타입으로 변환하여 정수 인덱스를 얻어야 합니다. 이 인덱스를 사용하여 배열의 시작부터 해당 인덱스까지의 부분을 추출할 수 있습니다.
     *
     * 이 코드는 먼저 sliceArray라는 함수를 정의합니다. 이 함수는 배열과 자르고자 하는 비율을 입력으로 받아, 해당 비율만큼 배열의 앞부분을 추출하여 반환합니다. 예제에서는 exampleArray라는 배열을 생성하고, 이 배열을 30%, 50%, 70% 만큼 각각 자른 결과를 출력합니다.
     
       위 코드의 sliceArray 함수는 제네릭을 사용하여 어떤 타입의 배열이든 처리할 수 있도록 설계되었습니다. guard문을 사용하여 입력된 배열이 비어 있지 않고, 비율이 0보다 큰 경우에만 작업을 수행하도록 합니다. 배열의 길이에 비율을 곱한 후, Int로 변환하여 배열의 시작부터 계산된 인덱스까지의 부분 배열을 반환합니다.
     */
    func sliceArray<T>(_ array: [T], by percentage: Double) -> [T] {
        guard !array.isEmpty, percentage > 0 else { return [] }
        let endIndex = Int(Double(array.count) * percentage)
        return Array(array.prefix(endIndex))
    }
    
    func resetSwipeList(category: String) {
        var dummyArr: [SwipeDataList] = []
        
        if category == "초급부터" {
            self.swipeList = fixedSwipeList_0
            self.percentCountSwipeList = fixedSwipeList_0
            self.countOfSwipeList = Double(fixedSwipeList_0.count)
            
        }
        else if category == "고급부터" {
            var dummyArr = fixedSwipeList_0
            dummyArr.reverse()
            
            for (index, _) in fixedSwipeList_0.enumerated() {
                dummyArr[index].customId = index + 1
            }
            
            self.swipeList = dummyArr
            self.percentCountSwipeList = dummyArr
            self.countOfSwipeList = Double(fixedSwipeList_0.count)
        }
        else if category == "무작위" {
            var dummyArr = fixedSwipeList_0
            dummyArr.shuffle()
            
            for (index, _) in fixedSwipeList_0.enumerated() {
                dummyArr[index].customId = index + 1
            }
            
            self.swipeList = dummyArr
            self.percentCountSwipeList = dummyArr
            self.countOfSwipeList = Double(fixedSwipeList_0.count)
        }
        else {
            for element in fixedSwipeList_0 {
                if category == (element.type3 ?? "") {
                    dummyArr.append(element)
                }
            }
            for (index, _) in dummyArr.enumerated() {
                dummyArr[index].customId = index + 1
            }
            
            self.swipeList = dummyArr
            self.percentCountSwipeList = dummyArr
            self.countOfSwipeList = Double(dummyArr.count)
        }
    }
}
