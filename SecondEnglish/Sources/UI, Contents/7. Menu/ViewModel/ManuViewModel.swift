//
//  ManuViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation
import SwiftUI
import Combine

class MenuViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var popupMessage: String = ""
    
    @Published var mySentenceList: [SwipeDataList] = []
    @Published var myPostLikeList: [SwipeDataList] = []
    @Published var myGetLikeList: [SwipeDataList] = []
    @Published var cardBlockData: MyCardData?
    @Published var userBlockData: [UserBlockData]?
    @Published var popularCardTop10Data: PopularCardTop10Data?
    
    // 작성한 글
    func getMySentence(isDone: @escaping() -> Void = {}) {
        ApiControl.getMySentence()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.mySentenceList = value.data ?? []
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
    }
    
    // 누른 좋아요
    func getMyPostLike(isDone: @escaping() -> Void = {}) {
        ApiControl.getMyPostLike()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.myPostLikeList = value.data
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
    }
    
    // 받은 좋아요
    func getMyGetLike(isDone: @escaping() -> Void = {}) {
        ApiControl.getMyGetLike()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.myGetLikeList = value.data
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
    }
    
    // 차단한 글
    func getMyCardBlock(isDone: @escaping() -> Void = {}) {
        ApiControl.getCardBlock()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.cardBlockData = value.data
                    //fLog("idpil::: cardBlockData : \(self.cardBlockData)")
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
    }
    
    // 차단한 사용자
    func getMyUserBlock(isDone: @escaping() -> Void = {}) {
        ApiControl.getUserBlock()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.userBlockData = value.data
                    //fLog("idpil::: userBlockData : \(self.userBlockData)")
                    isDone()
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
    }
    
    // 주간/월간 인기 글 TOP10
    func getPopularCardTop10(isWeek: Bool, isDone: @escaping() -> Void = {}) {
        ApiControl.getPopularCardTop10(isWeek: isWeek)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isDone()
            } receiveValue: { value in
                if value.code == 200 {
                    self.popularCardTop10Data = value.data
                    //fLog("idpil::: popularCardTop10Data : \(self.popularCardTop10Data)")
                    isDone()
                    
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isDone()
                }
            }
            .store(in: &cancellables)
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
            .store(in: &cancellables)
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
            .store(in: &cancellables)
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
                        self.popupMessage = "se_g_post_deleted".localized
                        isSuccess(true)
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isSuccess(false)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - 카드 수정
    func editCardList(sentence_list: [Dictionary<String, String>], isPostComplete: @escaping((Bool) -> Void)) {
        ApiControl.editCardList(sentence_list: sentence_list)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.popupMessage = error.message
                isPostComplete(false)
            } receiveValue: { value in
                if value.code == 200 {
                    if value.success ?? false {
                        isPostComplete(true)
                    }
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isPostComplete(false)
                }
            }
            .store(in: &cancellables)
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
                    isSuccess(true)
                }
                else {
                    self.popupMessage = ErrorHandler.getCommonMessage()
                    isSuccess(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func cancelBlockCard(cardIndex: Int) {
        self.cardBlockData?.sentence_list.remove(at: cardIndex)
    }
    
    func cancelBlockUser(userIndex: Int) {
        self.userBlockData?.remove(at: userIndex)
    }
    
    func removeDeletedCard(cardIndex: Int) {
        self.mySentenceList.remove(at: cardIndex)
    }
    
    func removeLikeCard(cardIndex: Int) {
        self.myPostLikeList.remove(at: cardIndex)
    }
    
    // String -> Date (yyyyMMdd 형식)
    func StringToDate(timeString: String) -> String? {
        let stringDate: String? = ""
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyyMMdd"  // String의 문자열 형식과 동일 해야함
        myFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let date = myFormatter.date(from: timeString)
        
        guard let NOdate = date else { return stringDate }
        
        return self.DateToString(timeDate: NOdate)
    }
    
    // Date -> String
    func DateToString(timeDate: Date) -> String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd"  // 변환할 형식
        let dateString = myFormatter.string(from: timeDate)
        return dateString
    }
    
}
