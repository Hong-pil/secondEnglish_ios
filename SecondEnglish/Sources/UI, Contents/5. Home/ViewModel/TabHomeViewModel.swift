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
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var sentenceList: [SwipeDataList] = []
    @Published var categoryList: [String] = []
    @Published var myLearningProgressList: [MyLearningProgressData] = []
    
    
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
                    self.sentenceList = value.data?.sentence_list ?? []
                    self.categoryList = value.data?.category_list ?? []
                    
                    /**
                     * 각 카테고리 시작점과 마지막점 유무 저장
                     * (홈탭에서 카드배너 넘겨질 때 카테고리 버튼 이동하는데 사용함)
                     */
                    for categoryItem in value.data?.category_list ?? [] {
                        for (index, sentenceItem) in (value.data?.sentence_list ?? []).enumerated() {
                            if categoryItem == (sentenceItem.type3 ?? "") {
                                //fLog("idpil::: 카테고리 로그, \(sentenceItem.type3 ?? "")")
                                
                                
                                // 각 카테고리 시작점 유무 저장
                                self.sentenceList[index].isStartPointCategory = true
                                
                                // 각 카테고리 마지막점 유무 저장
                                if index > 1 {
                                    self.sentenceList[index-1].isEndPointCategory = true
                                }
                                
                                
                                break // 다음 카테고리로 이동하기 위해 반복문 빠져나감
                            }
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
    
    //MARK: - 카테고리별 진도확인 리스트 조회
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
                        self.myLearningProgressList = myProgressList
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
    
}
