//
//  UserManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @AppStorage(DefineKey.isFirstLaunching) var isFirstLaunching: Bool = true       //permission, login
    
    
    //MARK: - Variables : State
    @Published var isLogin: Bool = false
    @Published var showSafari = false
    @Published var showLoginView = false
    @Published var showLoginAlert = false
    @Published var showAlertAuthError = false
    @Published var showAlertNetworkError = false
    @Published var showCardShuffleError = false
    @Published var showCardCutError = false
    @Published var showCardAutoModeError = false
    @Published var showSettingAuth = false
    @Published var showClubJoinAlert = false
    @Published var deletePostAlert = false
    @Published var reportPostAlert = false
    @Published var certNumberAlert = false
    @Published var withdrawAccountAlert = false
    @Published var delegateCancelCompleteAlert = false
    @Published var delegateCompleteAlert = false
    @Published var boardReportAlert = false
    @Published var boardReportAlreadyAlert = false
    @Published var boardBlockRequestAlert = false
    @Published var boardBlockToastAlert = false
    @Published var boardUnBlockToastAlert = false
    @Published var boardUserBlockToastAlert = false
    @Published var boardUserUnBlockToastAlert = false
    @Published var boardUnBlockRequestAlert = false
    @Published var boardBlockRequestApi = false
    @Published var boardUnBlockRequestApi = false
    @Published var boardUserBlockRequestAlert = false
    @Published var boardUserUnBlockRequestAlert = false
    @Published var boardUserBlockRequestApi = false
    @Published var boardUserUnBlockRequestApi = false
    @Published var boardDeleteRequestAlert = false
    @Published var replyEditRequestAlert = false
    @Published var boardDeleteRequestApi = false
    @Published var replyEditRequestApi = false
    @Published var boardDeleteCompleteAlert = false
    @Published var delegateAlertState = false
    @Published var CommunityAlimOn = false
    @Published var CommunityAlimOff = false
    @Published var accountBlock = false
    @Published var blockClear = false
    @Published var goToClubTabHome = false
    @Published var goToCommunityTabHome = false
    @Published var showProvideFanitAlert = false
    @Published var showUploadMinute: Bool = false
    @Published var showPostReportStatue = false
    @Published var showNetworkError = false
    @Published var showCardDeleteAlert:Bool = false
    @Published var isCardDelete:Bool = false
    @Published var showCardDeletepopup:Bool = false
    
    @Published var isCheckingToken = false
    
    @Published var isLogout: Bool = false
    @Published var isLookAround: Bool = false       // 로그인페이지에서 둘러보기 클릭 -> 홈-Popular 탭으로 이동
    @Published var showInitialViewState = Date()    // 로그아웃 후 초기상태를 보여줘야 한다.
    @Published var callLoginSuccess: Bool = false   // 로그인 화면에서 로그인 성공한 경우
    
    @Published var isNewAlim: Bool = false
    @Published var isNewChatting: Bool = false
    
    @Published var safariUrl = ""
    
    // 커뮤니티 즐겨찾기 화면 - 추천순 또는 인기순 중 선택한 것 저장
    @Published var favoriteTxt: String = "p_order_by_user_recommend".localized
//    // 커뮤니티 메인 화면 - 최신순 또는 인기순 중 선택한 것 저장
//    @Published var communityMainSheetTxt: String = "c_newst".localized
    
    @Published var selectedGlobalSEQ: Int = 1
    @Published var selectedSEQ: Int = 1
    
    // Joseph
    @Published var backgroundChatStatus: Bool = false    // Background -> forground check
    @Published var backgroundStatus: Bool = false        // Background -> forground check
    
    //MARK: - Variables : Login
    @AppStorage(DefineKey.accessToken) var accessToken: String = ""
    @AppStorage(DefineKey.refreshToken) var refreshToken: String = ""
    @AppStorage(DefineKey.fcmToken) var fcmToken: String = ""
    @AppStorage(DefineKey.uid) var uid: String = ""
    @AppStorage(DefineKey.integUid) var integUid: String = ""
    @AppStorage(DefineKey.userNick) var userNick: String = ""
    @AppStorage(DefineKey.userEmail) var userEmail: String = ""

    @AppStorage(DefineKey.expiredTime) var expiredTime: Int = 0
    @AppStorage(DefineKey.lastLoginAt) var lastLoginAt: String = ""
    @AppStorage(DefineKey.regDate) var regDate: Date = Date()
    
    @AppStorage(DefineKey.account) var account: String = ""
    @AppStorage(DefineKey.password) var password: String = ""
    @AppStorage(DefineKey.loginUserType) var loginUserType: String = ""
    @AppStorage(DefineKey.loginType) var loginType: String = ""
    @AppStorage(DefineKey.countryCode) var countryCode: String = ""
    @AppStorage(DefineKey.marketingToggleOn) var marketingToggleOn: Bool = false

    @AppStorage(DefineKey.oldLoginType) var oldLoginType: String = ""
    
    @AppStorage(DefineKey.authorizedAlbum) var authorizedAlbum = false
    @AppStorage(DefineKey.showProfileCompleteAlert) var showProfileCompleteAlert = false
    
    @AppStorage(DefineKey.club_favorite_on) var clubFavoriteOn = false
    
    

    var canclelables = Set<AnyCancellable>()
    
    var isMinuteMute: Bool = false
    
    
    
    //MARK: - Method
    //앱 실행 시 로그인상태 및 로그인뷰 띄워야할지 체크한다.
    func start() {
        //첫 실행하는데 로그인이 되어 있지 않다.
        //permission이 끝나면 로그인페이지를 띄운다.
        if isFirstLaunching {
            isLogin = false
            showLoginView = false
        }
        else {
            if checkValidateSSO() {
                isLogin = true
                showLoginView = false
                checkNewAlim()
            }
            else {
                isLogin = false
                showLoginView = true
            }
        }
    }
    
    func checkNewAlim() {
        isNewAlim = UserManager.shared.getBadgeCountForNormal() > 0
        isNewChatting = UserManager.shared.getBadgeCountForChat() > 0
    }
    
    func setIsLogin() {
        isLogin = checkValidate()
    }
    
    func checkLoginSSO() {
        isLogin = checkValidateSSO()
    }
    
    func setLoginData(uid: String,
                      account: String,
                      user_nickname: String,
                      loginUserType: String,
                      accessToken: String,
                      refreshToken: String)
    {
        self.uid = uid
        self.account = account
        self.userNick = user_nickname
        self.loginUserType = loginUserType
        self.oldLoginType = loginUserType
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.regDate = Date()
        //let _ = self.checkValidate()
    }
    
    func setLoginDataSSO(accessToken: String)
    {
        self.accessToken = accessToken
        self.regDate = Date()
        
        self.isLogin = self.checkValidateSSO()
        
        if self.isLogin && UserManager.shared.integUid != "" {
            NotificationCenter.default.post(name: Notification.Name(DefineNotification.changeLoginStatus), object: nil, userInfo: nil)
            RefreshManager.shared.homeRefreshSubject.send()
        }
    }
    
    func logout() {
        reset()
        isLogout = true
        isLogin = false
        callLoginSuccess = false
        showInitialViewState = Date()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserManager.shared.isNewAlim = false
        UserManager.shared.isNewChatting = false
        
        // 로그아웃 후 다른 계정으로 로그인했을 때, 이전 채팅방 리스트가 남아 있다는 버그가 있다고 해서 초기화 시킴
        //ChatManager.shared.conversations = []
        
        NotificationCenter.default.post(name: Notification.Name(DefineNotification.changeLoginStatus), object: nil, userInfo: nil)
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        withAnimation {
            UserManager.shared.showLoginView = true
        }
    }
    
    func reset() {
        fLog("\n--- logout ----------------\n")
        
//        if isLogin, fcmToken.count > 0 {
//            let _ = ApiControl.deletePushInstall(fcmToken: self.fcmToken)
//        }
        
        self.uid = ""
        self.account = ""
        self.userNick = ""
        self.loginUserType = ""
        self.oldLoginType = ""
        
        self.accessToken = ""
        self.refreshToken = ""
        
        self.password = ""
        self.loginType = ""
        setAccountForBadgeCount("")
        //self.oldLoginType = ""        //이전 로그인 정보는 계속 써야되서 초기화 하지 않는다.
        
        
        self.fcmToken = ""
        self.integUid = ""
        self.userEmail = ""
        
        self.expiredTime = 0
        self.regDate = Date()
        
        //let _ = self.checkValidateSSO()
    }
    
    
    //MARK: - Method : Check
    func refreshToken(result:@escaping((_ success:Bool) -> Void)) {
        UserManager.shared.isCheckingToken = true
        
        ApiControl.refreshToken()
            .sink { error in

                //finished error가 들어와서 막는다. 왜 여기만 들어오는지 의문임.
                guard case .failure(_) = error else { return }

                //갱신 실패시 로그인알럿 띄우자
                result(false)
                StatusManager.shared.stopAllLoading()
                AlertManager().showAlertAuthError()
                self.isCheckingToken = false
            } receiveValue: { value in
                let access_token = value.access_token
                let expires_in = value.expires_in

                //success
                if access_token.count > 0, expires_in > 0 {

                    fLog("\n--- refresh token Result ---------------------------------\naccess_token : \(access_token)\nexpires_in : \(expires_in)\n")

                    self.accessToken = access_token
                    self.expiredTime = expires_in
                    self.regDate = Date()
                    
                    self.isCheckingToken = false

                    result(true)
                }
                else {
                    //갱신 실패시 로그인알럿 띄우자
                    result(false)
                    StatusManager.shared.stopAllLoading()
                    AlertManager().showAlertAuthError()
                    self.isCheckingToken = false
                }
            }
            .store(in: &canclelables)
    }
    
//    func checkTokenAndRenewal(isCheck:Bool, result:@escaping((_ success:Bool) -> Void)) {
//        if !isCheck {
//            result(true)
//            return
//        }
//
//        if !isLogin {
//            result(true)
//            return
//        }
//
//        if checkExpiredToken() {
//            result(true)
//        }
//        else {
//            ApiControl.refreshToken()
//                .sink { error in
//
//                    //finished error가 들어와서 막는다. 왜 여기만 들어오는지 의문임.
//                    guard case .failure(_) = error else { return }
//
//                    //갱신 실패시 로그인알럿 띄우자
//                    result(false)
//                    StatusManager.shared.stopAllLoading()
//                    AlertManager().showAlertAuthError()
//                } receiveValue: { value in
//                    let access_token = value.access_token
//                    let expires_in = value.expires_in
//
//                    //success
//                    if access_token.count > 0, expires_in > 0 {
//
//                        fLog("\n--- refresh token Result ---------------------------------\naccess_token : \(access_token)\nexpires_in : \(expires_in)\n")
//
//                        self.accessToken = access_token
//                        self.expiredTime = expires_in
//
//                        result(true)
//                    }
//                    else {
//                        //갱신 실패시 로그인알럿 띄우자
//                        result(false)
//                        StatusManager.shared.stopAllLoading()
//                        AlertManager().showAlertAuthError()
//                    }
//                }
//                .store(in: &canclelables)
//        }
//    }
    
    func checkExpiredToken() -> Bool {
//        return false
        if checkValidateSSO() {
            //종료날짜를 계산
            let expiredDate = regDate.addingTimeInterval(TimeInterval(expiredTime))
            
            //종료날짜에서 현재시간을 뺀다.
            let duration = expiredDate - Date()
            
            //30분이상 차이가 나면 아직 토큰이 유효한걸로 판단.
            let checkMinutes: Double = 60 * 30
            
            
//            fLog("\n--- check expired token -------------------------------\nregDate : \(regDate)\nexpiredTime : \(expiredTime)\nexpiredDate : \(expiredDate)\ncheckMinutes : \(checkMinutes)\nduration : \(duration)\naccessToken : \(accessToken)\nintegUid : \(uid)\n\n")
            fLog("\n--- check expired token -------------------------------\nregDate : \(regDate)\nexpiredTime : \(expiredTime)\nexpiredDate : \(expiredDate)\ncheckMinutes : \(checkMinutes)\nduration : \(duration)\naccessToken : \(accessToken)\nuserNick : \(userNick)\nintegUid : \(integUid)\n\n")
            
            if duration > checkMinutes {
                return true
            }
        }
        
        return false
    }
    
    func checkValidate() -> Bool {
        fLog("\n--- checkValidate login ----------------------\naccessToken : \(accessToken)\nrefreshToken : \(refreshToken)\nuid : \(uid)\nloginUserType : \(loginUserType)\n")
        
//        if loginType == LoginType.email.rawValue {
//            if accessToken.count > 0, refreshToken.count > 0, integUid.count > 0, account.count > 0, password.count > 0, loginType.count > 0, expiredTime > 0 {
//                return true
//            }
//        }
//        else {
//            if accessToken.count > 0, refreshToken.count > 0, integUid.count > 0, account.count > 0, loginType.count > 0, expiredTime > 0 {
//                return true
//            }
//        }
        if accessToken.count > 0, refreshToken.count > 0, uid.count > 0, loginUserType.count > 0 {
            return true
        }
        
        
        
        return false
    }
    
    func checkValidateSSO() -> Bool {
        //fLog("\n--- checkValidate login ----------------------\naccessToken : \(accessToken)\nrefreshToken : \(refreshToken)\nuid : \(uid)\naccount : \(account)\npassword : \(password)\nloginType : \(loginType)\nexpiredTime : \(expiredTime)\n")
        if accessToken.count > 0 {
            return true
        }

        return false
    }
    
    
//    var lang:String {
//        //return Locale.current.languageCode ?? "en"
//        let appleLanguagesKey = "Apple"
//        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
//            return "en"
//        }
//
//        if let languageCode = defaults.string(forKey: appleLanguagesKey) {
//            return languageCode
//        }
//        else {
//            var lang = NSLocale.current.languageCode ?? "en"
//            if lang == "zh" {
//                lang = "zh-" + (NSLocale.current.scriptCode ?? "")
//            }
//
//            defaults.set(lang, forKey: appleLanguagesKey)
//            return lang
//        }
//    }
    
    func badgeCountSetting() {
        let count = getBadgeCountForNormal() + getBadgeCountForChat()
        fLog("badgeCountSetting count : \(count)")
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    func setAccountForBadgeCount(_ value: String) {
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return
        }
        defaults.set(value, forKey: "AccountForBadgeCount")
        defaults.synchronize()
    }
    
    func setBadgeCountForNormal(_ value: Int) {
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return
        }
        
        let key = defaults.string(forKey: "AccountForBadgeCount") ?? ""
        let newValue = "\(key)=\(value)"
        defaults.set(newValue, forKey: "BadgeCountForNormal")
        defaults.synchronize()
    }
    
    func getBadgeCountForNormal() -> Int {
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return 0
        }
        let key = defaults.string(forKey: "AccountForBadgeCount") ?? ""
        let value = defaults.string(forKey: "BadgeCountForNormal")
        let newValue = value?.replacingOccurrences(of: "\(key)=", with: "")
        return Int(newValue ?? "0") ?? 0
    }
    
    func setBadgeCountForChat(_ value: Int) {
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return
        }
        let key = defaults.string(forKey: "AccountForBadgeCount") ?? ""
        let newValue = "\(key)=\(value)"
        defaults.set(newValue, forKey: "BadgeCountForChat")
        defaults.synchronize()
    }
    
    func getBadgeCountForChat() -> Int {
        guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
            return 0
        }
        let key = defaults.string(forKey: "AccountForBadgeCount") ?? ""
        let value = defaults.string(forKey: "BadgeCountForChat")
        let newValue = value?.replacingOccurrences(of: "\(key)=", with: "")
        return Int(newValue ?? "0") ?? 0
    }
}
