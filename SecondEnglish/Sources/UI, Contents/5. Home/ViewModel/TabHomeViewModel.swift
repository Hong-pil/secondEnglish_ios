//
//  TabHomeViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/3/24.
//

import Foundation
import Combine

class TabHomeViewModel: ObservableObject {
    var cancellable = Set<AnyCancellable>()
    static let shared = TabHomeViewModel()
    
    @Published var isFirst: Bool = false
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var myLikeCardList: [SwipeDataList] = []
    @Published var myLikeCardCategoryList: [CategoryListData] = []
    @Published var myPostCardList: [SwipeDataList] = []
    @Published var myPostCardCategoryList: [CategoryListData] = []
    @Published var myLearningProgressList: [MyLearningProgressMainCategory] = []
    
    
    //MARK: - 내가 좋아요한 카드 리스트 조회
    func requestMyLikeCardList(idDone: @escaping() -> Void) {
        ApiControl.getMyLikeCardList()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSwipeList error : \(error)")
                
                self.alertMessage = error.message
//                AlertManager().showAlertMessage(message: self.alertMessage) {
//                    self.showAlert = true
//                }
                idDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.myLikeCardList = value.data?.sentence_list ?? []
                    self.myLikeCardCategoryList = value.data?.category_list ?? []
//                    printPrettyJSON(keyWord: "idpil myLikeCardList :::\n", from: self.myLikeCardList)
//                    printPrettyJSON(keyWord: "idpil myLikeCardCategoryList :::\n", from: self.myLikeCardCategoryList)
                    
                    idDone()
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
//                    AlertManager().showAlertMessage(message: self.alertMessage) {
//                        self.showAlert = true
//                    }
                    idDone()
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - 내가 작성한 카드 리스트 조회
    func requestMyPostCardList(isSuccess: @escaping(Bool) -> Void) {
        ApiControl.getMyPostCardList()
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
                    self.myPostCardList = value.data?.sentence_list ?? []
                    self.myPostCardCategoryList = value.data?.category_list ?? []
//                    printPrettyJSON(keyWord: "idpil myPostCardList :::\n", from: self.myPostCardList)
//                    printPrettyJSON(keyWord: "idpil myPostCardCategoryList :::\n", from: self.myPostCardCategoryList)
                    
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
    
    //MARK: - 내 카테고리별 진도확인 리스트 조회
    func requestMyCategoryProgress() {
        ApiControl.getMyCategoryProgress()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    if let myProgressList = value.data {
                        
                        //self.myLearningProgressList = self.transformCategoriesKeepingOrder(myProgressList)
                        
                        
                        self.myLearningProgressList = self.setMainCategoryIsLike(myProgressList)
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
    
    //MARK: - 카테고리별 진도확인 리스트 조회 (게스트용)
    func requestGuestCategoryProgress() {
        ApiControl.getGuestCategoryProgress()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    if let myProgressList = value.data {
                        
                        //self.myLearningProgressList = self.transformCategoriesKeepingOrder(myProgressList)
                        
                        self.myLearningProgressList = self.setMainCategoryIsLike(myProgressList)
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
    
    func transformCategoriesKeepingOrder(_ categories: [MyLearningProgressData]) -> [MyLearningProgressMainCategory] {
        /**
         '''
         서버에서 아래 형태로 응답온다. 하지만 앱에서 원하는 형태가 아니다.
         서버에서 처리할 수도 있지만, swift 언어로 처리해보고 싶어서 놔둔 것.
         [
           {
             "main_category": "category1",
             "sub_category": "google1",
             "category_sentence_count": 1,
             "like_number": 1
           },
           {
             "main_category": "category1",
             "sub_category": "google2",
             "category_sentence_count": 1,
             "like_number": 1
           },
           {
             "main_category": "category2",
             "sub_category": "google1",
             "category_sentence_count": 1,
             "like_number": 1
           }
         ]

         위 형태를 아래 형태로 변경해야 됨.
         이유 :
         홈화면에서 '내 학습 현황'을 보여줄 때, 원래는 카테고리 종류가 하나밖에 없었지만,
         메인 카테고리, 서브 카테고리로 카테고리를 하나 더 늘렸기 때문에 추가 작업이 필요해진 것.

         [
           {
             "main_category": "category1",
             "sub_category_list": [
             { "sub_category": "google1",
             "category_sentence_count": 1,
             "like_number": 1},
             { "sub_category": "google2",
             "category_sentence_count": 1,
             "like_number": 1}
             ]
           },
           {
             "main_category": "category2",
             "sub_category_list": [
             {"sub_category": "google1",
             "category_sentence_count": 1,
             "like_number": 1}
             ]
           }
         ]
         '''
         */
        
        
        // main_category 값을 유지하기 위한 배열
        var order: [String] = []
        // 중복 제거와 순서 유지를 위해 각 main_category가 이미 추가되었는지 확인
        categories.forEach { category in
            if !order.contains(category.main_category ?? "") {
                order.append(category.main_category ?? "")
            }
        }
        
        var result: [MyLearningProgressMainCategory] = []
        
        // 순서대로 각 main_category를 처리
        for mainCategory in order {
            
            let filteredCategories = categories.filter { $0.main_category == mainCategory }
            
            let subCategories = filteredCategories.map {
                
                MyLearningProgressSubCategory(
                    sub_category: $0.sub_category ?? "",
                    category_sentence_count: $0.category_sentence_count ?? 0,
                    like_number: $0.like_number ?? 0,
                    today_new_count: $0.today_new_count ?? 0
                )
            }
            let mainCat = MyLearningProgressMainCategory(
                main_category: mainCategory,
                sub_category_list: subCategories)
            
            result.append(mainCat)
        }
        
        return result
    }
    
    /**
     * 홈 화면에서 '메인 카테고리' 앞에 하트 아이콘이 추가됐는데,
     * 해당 메인 카테고리에 포함된 서브 카테고리 중에서 좋아요한 개수가 하나 이상인 경우에는 '꽉찬 하트 아이콘'을 보여주고,
     * 하나도 없다면 '깨진 하트 아이콘'을 보여준다.
     * 이 함수는 '꽉찬 하트 아이콘'을 보여주는 기준이 되는 값(isLike)을 설정하는 기능을 한다.
     */
    func setMainCategoryIsLike(_ list: [MyLearningProgressData]) -> [MyLearningProgressMainCategory] {
        
        var tmpMyLearningProgressList: [MyLearningProgressMainCategory] = []
        let tmpArr = self.transformCategoriesKeepingOrder(list)
        
        for item in tmpArr {
            
            var likeNum: Int = 0
            var tmpMyLearningProgress: MyLearningProgressMainCategory = item
            
            for item2 in item.sub_category_list {
                likeNum = likeNum + item2.like_number
            }
            
            if likeNum > 0 {
                // 좋아요한 카테고리 있음
                tmpMyLearningProgress.isLike = true
            } else if likeNum == 0 {
                // 좋아요한 카테고리 없음
                tmpMyLearningProgress.isLike = false
            }
            
            
            tmpMyLearningProgressList.append(tmpMyLearningProgress)
        }
        
        return tmpMyLearningProgressList
    }
}
