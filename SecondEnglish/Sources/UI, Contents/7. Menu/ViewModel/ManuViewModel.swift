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
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var profileUrl: String = "" { didSet { checkStepValue() } }
    @Published var nickName: String = "" { didSet { checkStepValue() } }
    @Published var countryCode: String = "" { didSet { checkStepValue() } }
    @Published var gender: String = "" { didSet { checkStepValue() } }
    @Published var birthDay: String = "" { didSet { checkStepValue() } }
    @Published var interests: [String] = [] { didSet { checkStepValue() } }
    
    @Published var referralCode: String = ""
    @Published var useReferralCode: String = ""
    @Published var joinedDate: Date = Date()
    
    @Published var myPostCount: String = "0"
    @Published var myCommentCount: String = "0"
    @Published var savedPostCount: String = "0"
    
    @Published var stepValue:Int = 0
    @Published var stepState:Bool = false
    @Published var userInfoResult:Bool = false
    
    
    @Published var alimUnread: AlimUnreadMessage?
    @Published var alimList = [AlimMessage]()
    
    
    var cancellables = Set<AnyCancellable>()
    
    
    
    
    func checkStepValue() {
        var step = 0
        
//        if self.profileUrl.count > 0 {
//            step += 1
//        }
//
//        if self.nickName.count > 0 {
//            step += 1
//        }
//
//        if self.countryCode.count > 0 {
//            step += 1
//        }
//
//        if self.gender.count > 0 && gender != "none" {
//            step += 1
//        }
//
//        if self.birthDay.count > 0 {
//            step += 1
//        }
        
        if self.interests.count > 0 {
            step += 1
            stepState = true
        }
        
        stepValue = step
    }
}
