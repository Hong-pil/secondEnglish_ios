//
//  LoginViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Combine

class LoginViewModel: NSObject ,ObservableObject {
    
    let snsLoginControl: SnsLoginControl = SnsLoginControl()
    var cancellable = Set<AnyCancellable>()
    
    // alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var showJoinPage: Bool = false
    @Published var joinIdx: String = ""
    @Published var joinType: LoginType = .google
    
    // 초기화 후, 슈퍼 클래스의 초기화 호출
    override init() {
        super.init()
        
        snsLoginControl.loginAppleResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx, type: .apple)
        }
        .store(in: &cancellable)
        
        snsLoginControl.loginKakaoResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx, type: .kakao)
        }
        .store(in: &cancellable)
        
        snsLoginControl.loginGoogleResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx.idx ?? "", type: .google)
        }
        .store(in: &cancellable)
    }
    
    //MARK: - SNS Connect
    func loginWithApple() {
        loadingStatus = .ShowWithTouchable
        snsLoginControl.appleLogin()
    }
    
    func loginWithKakao() {
        loadingStatus = .ShowWithTouchable
        snsLoginControl.kakaoLogin()
    }
    
    func loginWithGoogle() {
        loadingStatus = .ShowWithTouchable
        snsLoginControl.googleLogin()
    }
    
    
    //MARK: - Proccess
    func checkLoginResult(success:Bool, idx:String, type:LoginType) {
        fLog("\n--- checkLoginResult ------------------\nsuccess : \(success), idx : \(idx), type : \(type.rawValue)\n")
        loadingStatus = .Close
        
//        if success {
//            requestCheckJoin(idx: idx, type: type)
//        }
//        else {
//            self.alertTitle = ""
//            self.alertMessage = ErrorHandler.getCommonMessage()
//            self.showAlert = true
//        }
    }
    
    
    //MARK: - Reqeust
    func requestCheckJoin(idx: String, type:LoginType) {
        loadingStatus = .ShowWithTouchable
        ApiControl.joinCheck(loginId: idx, loginType: type.rawValue)
            .sink { error in
                
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                let isUser = value.isUser
                
                //이미 있는 계정이다. 로그인하자.
                if isUser {
                    self.requestSnsLogin(idx: idx, type: type.rawValue)
                }
                //없는 계정이다. 회원가입으로 가자.
                else {
                    self.joinIdx = idx
                    self.joinType = type
                    self.showJoinPage = true
                }
            }
            .store(in: &cancellable)
    }
    
    func requestSnsLogin(idx: String, type: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.snsLogin(idx: idx, loginType: type)
            .sink { error in
                
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
                
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                let authCode = value.authCode
                let state = value.state
                
                //success login!
                if authCode.count > 0, state.count > 0 {
                    self.requestIssueToken(authCode: authCode, state: state, loginId: idx, loginPw: "", loginType: type)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &cancellable)
    }
    
    func requestIssueToken(authCode: String, state: String, loginId: String, loginPw: String, loginType:String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.issueToken(authCode: authCode, state: state)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                let access_token = value.access_token
                let refresh_token = value.refresh_token
                let integUid = value.integUid
                let token_type = value.token_type
                let expires_in = value.expires_in
                
                //success
                if access_token.count > 0, refresh_token.count > 0, integUid.count > 0, token_type.count > 0, expires_in > 0 {
                    fLog("\n--- Email Login Result ---------------------------------\nauthCode : \(authCode)\nstate : \(state)\naccess_token : \(access_token)\nrefresh_token : \(refresh_token)\nintegUid : \(integUid)\ntoken_type : \(token_type)\nexpires_in : \(expires_in)\n")
                    
                    UserManager.shared.setLoginData(account: loginId, password: loginPw, loginType: loginType, accessToken: access_token, refreshToken: refresh_token, uid: integUid, expiredTime: expires_in)
                    UserManager.shared.checkLogin()
                    UserManager.shared.showLoginView = false
                    
                    UserManager.shared.isLogin = true
                    UserManager.shared.callLoginSuccess = true
                    UserManager.shared.isLogout = false
                    
//                    fLog("############################################")
//                    fLog("로그인테스트 - 회원가입된 상태에서 로그인")
//                    fLog("로그인타입 : \(self.joinType)")
//                    fLog("############################################")
                }
                else {
                    //성공이 아니면 에러
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &cancellable)

    }
    
    
    
    
    // SNS 인증으로 로그인 (넣을지 말지 고민해보자.)
    func sendSMS(toPhoneNumber: String, accountSid: String, authToken: String, fromPhoneNumber: String) {
        
        ApiControl.sendSMS(
            toPhoneNumber: toPhoneNumber,
            accountSid: accountSid,
            authToken: authToken,
            fromPhoneNumber: fromPhoneNumber
        )
        .sink { error in
            guard case let .failure(error) = error else { return }
            fLog("sendSMS error : \(error)")
            
            AlertManager().showAlertMessage(message: error.message) {
                self.showAlert = true
            }
        } receiveValue: { value in
            if value.code == 200 {
                fLog("로그::: value : \(value)")
            }
        }
        .store(in: &cancellable)
    }
    
    
    
    
}
