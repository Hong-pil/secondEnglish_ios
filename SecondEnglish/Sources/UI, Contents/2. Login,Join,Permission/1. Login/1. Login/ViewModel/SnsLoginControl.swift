//
//  SnsLoginControl.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import Foundation
import Combine

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

//import FirebaseAuth
//import Firebase
//import GoogleSignIn

// Firebase
import FirebaseCore
import FirebaseAuth

// Google Login
import GoogleSignIn

// Apple Login
import AuthenticationServices
import JWTDecode



struct LoginItem {
    let idx: String?
    let email: String?
}

class SnsLoginControl: NSObject, ObservableObject {
    
    @Published var loginItem: LoginItem? = nil
    
    // Apple Login
    var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    
    var loginAppleResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginKakaoResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginGoogleResultSubject = PassthroughSubject<(Bool, LoginItem), Never>()
    
    // Google Login
    static var rootViewController: UIViewController? {
        
        // 아래 deprecated 된 코드 수정
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        else {
            return nil
        }
        
        
        
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//
//            return topController
//        }
//        else {
//            return nil
//        }
        
        /*
         guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
             return .init()
         }
         
         guard let root = screen.windows.first?.rootViewController else {
             return .init()
         }
         return root
         */
    }
    
    
    //MARK: - Google Login
    func loginWithGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            if let data = loginItem {
                self.loginGoogleResultSubject.send((false, data))
            }
            return
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: SnsLoginControl.rootViewController!) { [unowned self] result, err in
            
            if let _ = err {
                if let data = self.loginItem {
                    self.loginGoogleResultSubject.send((false, data))
                }
                return
            }
            
          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              if let data = self.loginItem {
                  self.loginGoogleResultSubject.send((false, data))
              }
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                if let _ = error {
                    if let data = self.loginItem {
                        self.loginGoogleResultSubject.send((false, data))
                    }
                    return
                }
                guard let user = GIDSignIn.sharedInstance.currentUser else {
                    if let data = self.loginItem {
                        self.loginGoogleResultSubject.send((false, data))
                    }
                    return
                }
                
                let idx = user.userID ?? ""
                let email = user.profile?.email ?? ""
                if idx.count > 0 {
                    self.loginItem = LoginItem(idx: idx, email: email)
                    if let data = self.loginItem {
                        self.loginGoogleResultSubject.send((true, data))
                    }
                }
                else {
                    if let data = self.loginItem {
                        self.loginGoogleResultSubject.send((false, data))
                    }
                }
            }
        }
    }
    
    //MARK: - Apple Login
    func loginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self.presentationContextProvider
        authorizationController.performRequests()
    }
    
    //MARK: - Kakao Login
    func loginWithKakao() {
        //카카오톡이 설치되어 있는지 확인하는 함수
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }

                if let _ = oauthToken{
                    UserApi.shared.me { user, error in
                        let idx = user?.id ?? 0
                        if idx == 0 {
                            self.loginKakaoResultSubject.send((false, ""))
                        }
                        else {
                            fLog("idpilLog::: 카톡로그인 성공1 :>")
                            if let properties = user?.properties {
                                fLog("idpilLog::: nickname : \(properties["nickname"] ?? "")")
                                fLog("idpilLog::: profile_image : \(properties["profile_image"] ?? "")")
                                fLog("idpilLog::: thumbnail_image : \(properties["thumbnail_image"] ?? "")")
                            }
                            self.loginKakaoResultSubject.send((true, String(idx)))
                        }
                    }
                }
            }
        }
        else {
            //카카오 계정으로 로그인하는 함수
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }

                if let _ = oauthToken{
                    UserApi.shared.me { user, error in
                        let idx = user?.id ?? 0
                        if idx == 0 {
                            self.loginKakaoResultSubject.send((false, ""))
                        }
                        else {
                            fLog("idpilLog::: 카톡로그인 성공2 :>")
                            if let properties = user?.properties {
                                fLog("idpilLog::: nickname : \(properties["nickname"] ?? "")")
                                fLog("idpilLog::: profile_image : \(properties["profile_image"] ?? "")")
                                fLog("idpilLog::: thumbnail_image : \(properties["thumbnail_image"] ?? "")")
                            }
                            self.loginKakaoResultSubject.send((true, String(idx)))
                        }
                    }
                }
            }
        }
    }
}


//MARK: - Apple
extension SnsLoginControl: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) { credentialState, error in
                
                let authorizationCode = appleIDCredential.authorizationCode?.base64EncodedString()
                let token = appleIDCredential.identityToken?.base64EncodedString()
                let authorizedScopes = appleIDCredential.authorizedScopes.debugDescription
                
                fLog("\n--- apple info ----------------------------\nuser : \(appleIDCredential.user)\nauthorizationCode : \(authorizationCode ?? "")\ntoken : \(token ?? "")\nauthorizedScopes : \(authorizedScopes)\n")
                
                switch credentialState {
                case .authorized:
                    // 인증 성공 상태
                    fLog("idpilLog::: Apple Login Successed :>")
                    
                    //appleIDCredential.user
                    //UserManager().userAppleName = (appleIDCredential.fullName?.nickname != nil) ? appleIDCredential.fullName?.nickname : ""
                    
                    
                    let userid = appleIDCredential.user
                    if userid.count > 0 {
                        UserManager.shared.isLogin = true
                        
                        self.loginAppleResultSubject.send((true, userid))
                    }
                    else {
                        self.loginAppleResultSubject.send((false, ""))
                    }
                    
                    
                    // User Email Check
                    var email = ""
                    
                    let tokenString = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                    let jwt = try! decode(jwt: tokenString!)
                    
                    let claim = jwt.claim(name: "email")
                    if let appleEmail = claim.string, !email.contains("appleid.com") {
                        email = appleEmail
                    }
                    
                    
                    
                    break
                    
                case .revoked:
                    // 인증 만료 상태
                    self.loginAppleResultSubject.send((false, ""))
                    break
                    
                case .notFound:
                    self.loginAppleResultSubject.send((false, ""))
                    break
                    
                default:
                    self.loginAppleResultSubject.send((false, ""))
                    break
                }
            }
        }
    }
    
    // apple login 실패 시
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        fLog("\(error.localizedDescription)")
    }
}
