//
//  AccountInfoViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/31/24.
//

import Foundation
import SwiftUI
import Combine

class AccountInfoViewModel: ObservableObject {
    var cancellable = Set<AnyCancellable>()
    
    // alert
    @Published var showAlert: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var loginId: String = ""
    @Published var loginType: String = ""
    
    @Published var adAgreeYn: Bool = false
    @AppStorage(DefineKey.marketingToggleOn) var marketingToggleOn = false
    @Published var showAgreeAlert: Bool = false
    
    
    
    //MARK: - Request
    func requestLogout(result: @escaping((_ success:Bool) -> Void)) {
        ApiControl.requestLogout()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("sendSMS error : \(error)")
                result(false)
                AlertManager().showAlertMessage(message: error.message) {
                    self.showAlert = true
                }
            } receiveValue: { value in
                if value.code==200 && (value.success ?? false) {
                    result(true)
                }
            }
            .store(in: &cancellable)
    }
    func requestUserInfo() {
        loadingStatus = .ShowWithTouchable
//        ApiControl.myInfo(integUid: UserManager.shared.integUid)
//            .sink { error in
//                fLog("getUserInfo error : \(error)")
//                self.loadingStatus = .Close
//            } receiveValue: { value in
//                fLog("getUserInfo value : \(value)")
//                self.loadingStatus = .Close
//                
//                self.loginId = value.loginId ?? ""
//                self.loginType = value.loginType ?? ""
////                self.toggleOn = value.adAgreeYn ?? false
//                
//            }.store(in: &canclelables)
    }
    
    func authCheck(completion: @escaping () -> Void) {
//        Authenticator.shared.validToken()
//            .sink { completion in
//                guard case let .failure(error) = completion else { return }
//                fLog(error)
//                if
//                    let err = error as? AuthenticationError,
//                    err == .loginRequired {
//                    DispatchQueue.main.async {
//                        StatusManager.shared.stopAllLoading()
//                        AlertManager().showAlertAuthError()
//                    }
//                }
//            } receiveValue: { value in
//                completion()
//            }
//            .store(in: &canclelables)

    }
    
    func getAdAgree() {
        loadingStatus = .ShowWithTouchable
//        ApiControl.adAgree(integUid: UserManager.shared.integUid)
//            .sink { error in
//                fLog("getAdAgree error : \(error)")
//                self.loadingStatus = .Close
//            } receiveValue: { value in
//                fLog("getAdAgree value : \(value)")
//                self.loadingStatus = .Close
//                UserManager.shared.marketingToggleOn = value.adAgreeYn
//                self.showAgreeAlert = true
//            }.store(in: &canclelables)
    }
}
