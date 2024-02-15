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
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var isFirstLoad = false
    
    // Category TabBar
    @Published var categoryTabIndex: Int = 0
    @Published var moveCategoryTab: Bool = false
    
    // View Data
    @Published var typeList: [SwipeCategoryList] = []
    @Published var fixedSwipeList_0: [SwipeDataList] = [] // 처음 한 번만 저장
    @Published var percentCountSwipeList: [SwipeDataList] = [] // 계산용
    @Published var swipeList: [SwipeDataList] = []
    @Published var countOfSwipeList: Double = 0
    @Published var categoryList: [String] = []
    @Published var cardPercentArr: [SwipeDataList] = [] // 카드 퍼센트 계산용
    
    // Card Like
    @Published var myLikeCardIdxList: [Int] = []
    
    
    init() {
        self.requestCategory()
        
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
        if let categoryIdx:Int = notification.userInfo![DefineKey.swipeViewCategoryIdx] as? Int {
            
            
            self.categoryTabIndex = categoryIdx
            self.moveCategoryTab = true
            
            self.requestSwipeListByCategory(
                category: self.categoryList[self.categoryTabIndex], // 첫 카테고리로 시작
                sortType: .Latest,
                isSuccess: { success in
                    //
                }
            )
            
            
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
    
    
    
    
    
    //MARK: - 카테고리 조회
    func requestCategory() {
        ApiControl.getSwipeCategory()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.typeList = value.data ?? []
                    
                    // 카테고리 헤더 데이터
                    for type in value.data ?? [] {
                        self.categoryList.append(type.type3 ?? "")
                    }
                    self.categoryList = self.categoryList.uniqued() // 중복제거
                    
                    // 카테고리별 영어문장 데이터
                    if self.categoryList.count > 0 {
                        self.requestSwipeListByCategory(
                            category: self.categoryList[self.categoryTabIndex], // 첫 카테고리로 시작
                            sortType: .Latest,
                            isSuccess: { success in
                                //
                            }
                        )
                    }
                    
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
                    
                    guard let arr = value.data else { return }
                    
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
                    self.categoryList = dumArr.uniqued()
                    
                    
                    
                    
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
                    self.resetSwipeList(category: self.categoryList[0])
                    
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
    func requestSwipeListByCategory(category: String, sortType: SwipeCardSortType, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getSwipeListByCategory(category: category)
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
                    
                    guard var arr = value.data else { return }
                    
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
    func requestMyCardList(uid: String, isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getMyCardList(uid: uid)
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
    
    
    
    
    
    
    
    
    
    func setIsFirstLoadFalse() {
        self.isFirstLoad = false
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
