//
//  CommonFunction.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import UIKit

struct CommonFunction {
    static func defaultParams() -> [String: Any] {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let osVersion = UIDevice.current.systemVersion
        let countryCode = Locale.current.regionCode ?? ""
        
        var params: [String: Any] = [:]
        params[DefineKey.appVersion] = appVersion
        params[DefineKey.device] = "ios"
        params[DefineKey.osVersion] = osVersion
        params[DefineKey.countryCode] = countryCode
        
        return params
    }
    
    static func defaultHeader(acceptLanguage: String = "") -> [String:String] {
        var header: [String:String] = [:]
        header[DefineKey.referer] = "http://fantoo.co.kr"
        header[DefineKey.user_agent] = "fantoo-ios"
        
        if acceptLanguage == "" {
            header[DefineKey.accept_language] = LanguageManager.shared.getLanguageApiCode()
        } else {
            header[DefineKey.accept_language] = acceptLanguage
        }
        
        if UserManager.shared.isLogin && !UserManager.shared.accessToken.isEmpty {
//            fLog("token ---: \(UserManager.shared.accessToken)")
            header[DefineKey.access_token] = UserManager.shared.accessToken
        }
        
        return header
    }
    
    static func kstDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        return df
    }
    
    static func onPageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    static func offPageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
    static func getParameters(url:String) -> Dictionary<String, String> {
        var returnDictionary: Dictionary<String, String> = [:]
        
        let components = URLComponents(string: url)
        let parameters = components?.query ?? ""
        if parameters.count > 0, parameters != "" {
            let items = components?.queryItems ?? []
            for item in items {
                returnDictionary[item.name] = item.value ?? ""
            }
        }
        
        return returnDictionary
    }
    
    static func topController() -> UIViewController {
        var topController: UIViewController = UIWindow.key!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        
        return topController
    }
    
    static func goAppStore(){
        // 앱 업데이트
        let myAppId = "1553859430"
        
        // 앱 아이디
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(myAppId)"), UIApplication.shared.canOpenURL(url) {
            // 유효한 URL인지 검사합니다. 에뮬은 안됨.
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func getNickName(nickName:String, integUid:String) -> String {
        if nickName.count > 0 {
            return nickName
        }
        
        if integUid.count > 0 {
            return integUid.substring(to: 4) + "****"
        }
        
        return ""
    }
    
    /**
     * 기능 설명 :
     * 디폴트 이미지 5 중 랜덤으로 하나 선택해서 리턴한다.
     * 단, 동일한 사람(integUid)이 쓴 글/댓글의 기본이미지는 같아야 하기 때문에,
     * integUid를 기준으로 구분한다.
     */
    static func getRandomDefaultImage(UserUniqueId: String) -> String {
        if UserUniqueId.isEmpty {
            // integuid 값 없으면, 랜덤으로 하나 추출해서 return
            return Define.defaultImages.randomElement()!
        }
        
        let lastIndex = UserUniqueId.index(before: UserUniqueId.endIndex)
        let lastChar = String(UserUniqueId[lastIndex])
        //fLog("받은integUid : \(integUid)") // ft_u_76650468280a8b43cc84d11ed87293765bffd22fb
        //fLog("lastChar : \(lastChar)") // b
        
        var lastCharTypeInt = 0
        
        // lastChar'type is Int
        if let NOlastChar_IntType = Int(lastChar) {
            //fLog("lastChar is not nil")
            //fLog("NOlastChar_IntType : \(NOlastChar_IntType)")
            lastCharTypeInt = NOlastChar_IntType
        }
        // lastChar'type is String
        else {
            //fLog("lastChar is nil")
            // String to Ascii
            lastCharTypeInt = Int(UnicodeScalar(lastChar)!.value)
        }
        //fLog("lastCharTypeInt : \(lastCharTypeInt)")
        // 5로 나누는 이유가 5개 이미지 중 하나를 선택하는 것이기 때문 (0,1,2,3,4,0,1,2,3,4 ...)
        //fLog("\(lastCharTypeInt) 를 5로 나눈 나머지 : \(lastCharTypeInt % 5)")
        let url = Define.defaultImages[lastCharTypeInt % 5]
        //fLog("getRandomDefaultImage url : \(url)")
        return Define.defaultImages[lastCharTypeInt % 5]
    }
}
