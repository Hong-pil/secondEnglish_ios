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
    
    @Published var showAddUserNamePage = false
    @Published var authSuccessedLoginId: String?
    @Published var authSuccessedLoginType: LoginUserType?
    
    
    // 초기화 후, 슈퍼 클래스의 초기화 호출
    override init() {
        super.init()
        
        snsLoginControl.loginAppleResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx, type: .Apple)
        }
        .store(in: &cancellable)
        
        snsLoginControl.loginKakaoResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx, type: .KakaoTalk)
        }
        .store(in: &cancellable)
        
        snsLoginControl.loginGoogleResultSubject.sink { success, idx in
            self.checkLoginResult(success: success, idx: idx.idx ?? "", type: .Google)
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
    func checkLoginResult(success:Bool, idx:String, type:LoginUserType) {
        fLog("\n--- checkLoginResult ------------------\nsuccess : \(success), idx : \(idx), type : \(type.rawValue)\n")
        loadingStatus = .Close
        
        if success {
            
            /**
             * 기존 코드 (사용 안 함)
             */
            // 다른 방식으로 로그인해도 DB에 저장되는 uid는 동일해야 하니까, deviceUUID를 구해서 전송함.
            //requestAddSnsUser(loginId: idx, loginType: type)
            
            
            
            // 기존 회원 유무 확인
            // 기존 회원 -> 로그인 뷰 내리고 홈 화면 로딩
            // 새 회원 -> 별명 설정 화면으로 이동
            self.requestCheckUser(loginId: idx, loginType: type) { isUser, nickname in
                if isUser {
                    StatusManager.shared.loadingStatus = .ShowWithTouchable
                    
                    self.requestAddSnsUser(
                        loginId: idx,
                        loginType: type,
                        user_nickname: nickname
                    ) { isSuccess in
                        if isSuccess {
                            // 로딩되는거 보여주려고 딜레이시킴
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                StatusManager.shared.loadingStatus = .Close
                                UserManager.shared.showLoginView = false
                            }
                        }
                    }
                    
                } else {
                    self.authSuccessedLoginId = idx
                    self.authSuccessedLoginType = type
                    self.showAddUserNamePage = true
                }
            }
        }
        else {
            self.alertTitle = ""
            self.alertMessage = ErrorHandler.getCommonMessage()
            self.showAlert = true
        }
    }
    
    // 회원 유무 확인
    func requestCheckUser(loginId: String, loginType: LoginUserType, isUser: @escaping(Bool, String)->Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userCheck(login_id: loginId, login_type: loginType.rawValue)
            .sink { error in
                
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                if value.code == 200 && (value.isUser ?? false) {
                    isUser(true, (value.userNickname ?? ""))
                } else {
                    // Error
                    self.alertTitle = ""
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                    
                    isUser(false, "")
                }
            }
            .store(in: &cancellable)
    }
    
    // 로그인 성공 요청
    func requestAddSnsUser(loginId: String, loginType: LoginUserType, user_nickname: String, isSuccess: @escaping(Bool)->Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.addSnsUser(loginId: loginId, loginType: loginType.rawValue, user_nickname: user_nickname)
            .sink { error in
                
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
//                fLog("로그::: verifySMSCode successed :>")
//                fLog("로그::: value : \(value)")
                if value.code == 200 && value.success {
                    // 로그인 성공!
                    let uid = value.uid ?? ""
                    let account = loginId
                    let access_token = value.access_token ?? ""
                    let refresh_token = value.refresh_token ?? ""
                    
                    
                    // Success
                    if uid.count > 0, access_token.count > 0, refresh_token.count > 0 {
                      
                        fLog("\n--- Login Result ---------------------------------\nuid : \(uid)\naccess_token : \(access_token)\nrefresh_token : \(refresh_token)\n")
                        UserManager.shared.setLoginData(
                            uid: uid,
                            account: account,
                            user_nickname: user_nickname,
                            loginUserType: loginType.rawValue,
                            accessToken: access_token,
                            refreshToken: refresh_token
                        )
                        UserManager.shared.checkLogin()
                        isSuccess(true)
                        //UserManager.shared.showLoginView = false
                    }
                    else {
                        // Error
                        self.alertTitle = ""
                        self.alertMessage = ErrorHandler.getCommonMessage()
                        self.showAlert = true
                    }
                    
                } else {
                    // Error
                    self.alertTitle = ""
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &cancellable)
    }
    
//    func requestCheckJoin(idx: String, type:LoginType) {
//        loadingStatus = .ShowWithTouchable
//        ApiControl.joinCheck(loginId: idx, loginType: type.rawValue)
//            .sink { error in
//                
//                self.loadingStatus = .Close
//                
//                guard case let .failure(error) = error else { return }
//                fLog("login error : \(error)")
//                
//                self.alertTitle = ""
//                self.alertMessage = error.message
//                self.showAlert = true
//            } receiveValue: { value in
//                self.loadingStatus = .Close
//                
//                let isUser = value.isUser
//                
//                //이미 있는 계정이다. 로그인하자.
//                if isUser {
//                    self.requestSnsLogin(idx: idx, type: type.rawValue)
//                }
//                //없는 계정이다. 회원가입으로 가자.
//                else {
//                    self.joinIdx = idx
//                    self.joinType = type
//                    self.showJoinPage = true
//                }
//            }
//            .store(in: &cancellable)
//    }
    
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
                    
//                    UserManager.shared.setLoginData(account: loginId, password: loginPw, loginType: loginType, accessToken: access_token, refreshToken: refresh_token, uid: integUid, expiredTime: expires_in)
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
    
    func issueToken(authCode: String, state: String, loginId: String, loginPw: String, loginType:String) {
        ApiControl.issueToken(authCode: authCode, state: state)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                
                let access_token = value.access_token
                let refresh_token = value.refresh_token
                let integUid = value.integUid
                let token_type = value.token_type
                let expires_in = value.expires_in
                
                //success
                if access_token.count > 0, refresh_token.count > 0, integUid.count > 0, token_type.count > 0, expires_in > 0 {
                  
                    fLog("\n--- Email Login Result ---------------------------------\nauthCode : \(authCode)\nstate : \(state)\naccess_token : \(access_token)\nrefresh_token : \(refresh_token)\nintegUid : \(integUid)\ntoken_type : \(token_type)\nexpires_in : \(expires_in)\n")
                    
//                    UserManager.shared.setLoginData(account: loginId, password: loginPw, loginType: loginType, accessToken: access_token, refreshToken: refresh_token, uid: integUid, expiredTime: expires_in)
                    UserManager.shared.checkLogin()
                    UserManager.shared.showLoginView = false
                }
                else {
                    //성공이 아니면 에러
                    self.alertTitle = ""
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &cancellable)

    }
    
}
