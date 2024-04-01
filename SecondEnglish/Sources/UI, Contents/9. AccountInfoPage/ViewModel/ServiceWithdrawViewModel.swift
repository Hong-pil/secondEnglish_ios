//
//  ServiceWithdrawViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/31/24.
//

import Foundation
import SwiftUI
import Combine

class ServiceWithdrawViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    //join data
    @Published var isAllAgree: Bool = false
    @Published var isAdAgree: Bool = false
    
    @Published var fanit: String = ""
    
    
    //MARK: - Request
    func requestUserWithdrawal(result:@escaping(Bool) -> Void) {
        ApiControl.requestWithdrawal()
            .sink { error in
                fLog("UserWithdrawal error : \(error)")
                
                guard case let .failure(error) = error else { return }
                
                result(false)
//                self.alertTitle = ""
                self.showAlert = true
                self.alertMessage = error.msg ?? ""
            } receiveValue: { value in
                result(true)
                fLog("UserWithdrawal value : \(value)")

            }
            .store(in: &cancellables)
    }
    
    func requestFanitPoint() {
//        loadingStatus = .ShowWithTouchable
//        ApiControl.FanitPoint(integ_uid: UserManager.shared.integUid)
//            .sink { error in
//                self.loadingStatus = .Close
//                
//                fLog("FanitPoint error : \(error)")
//            } receiveValue: { value in
//                self.loadingStatus = .Close
//                self.fanit = String(value.dataObj?.point ?? 0)
//                fLog("FanitPoint value : \(value.dataObj?.point ?? -1)")
//            }
//            .store(in: &canclelables)
    }
}
