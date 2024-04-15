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
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var popupMessage: String = ""
    
    @Published var mySentenceNum: Int = 0
    @Published var myPostLikeNum: Int = 0
    @Published var myGetLikeNum: Int = 0
    @Published var cardBlockData: MyCardData?
    @Published var userBlockData: [UserBlockData]?
    @Published var popularCardTop10Data: PopularCardTop10Data?
    
    // 작성한 글
    func getMySentence() {
        ApiControl.getMySentence()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.mySentenceNum = value.data ?? 0
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 누른 좋아요
    func getMyPostLike() {
        ApiControl.getMyPostLike()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.myPostLikeNum = value.data ?? 0
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 받은 좋아요
    func getMyGetLike() {
        ApiControl.getMyGetLike()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.myGetLikeNum = value.data ?? 0
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 차단한 글
    func getMyCardBlock() {
        ApiControl.getCardBlock()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.cardBlockData = value.data
                    fLog("idpil::: cardBlockData : \(self.cardBlockData)")
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 차단한 사용자
    func getMyUserBlock() {
        ApiControl.getUserBlock()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.userBlockData = value.data
                    fLog("idpil::: userBlockData : \(self.userBlockData)")
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 주간/월간 인기 글 TOP10
    func getPopularCardTop10(isWeek: Bool) {
        ApiControl.getPopularCardTop10(isWeek: isWeek)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.popularCardTop10Data = value.data
                    //fLog("idpil::: popularCardTop10Data : \(self.popularCardTop10Data)")
                    
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
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
    
    func cancelBlockCard(cardIndex: Int) {
        self.cardBlockData?.sentence_list.remove(at: cardIndex)
    }
    
    func cancelBlockUser(userIndex: Int) {
        self.userBlockData?.remove(at: userIndex)
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
