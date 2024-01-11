//
//  LanguageManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    
    enum Language: String {
        case arabic = "ar"
        case german = "de"
        case eng = "en" // 영어
        case spa = "es" // 스페인어
        case fre = "fr" // 프랑스어
        
        case hindi = "hi"
        case ind = "id" // 인도네시아어
        case italian = "it"
        case jpn = "ja" // 일본어
        case kor = "ko"   // 한국어
        
        case polish = "pl"  //폴란드
        case portuguese = "pt-PT"    //포루투칼
        case rus = "ru" // 러시아어
        case thai = "th"    //태국
        case vietnamese = "vi-VN"       //베트남
        
        case chi = "zh-Hans" // 중국어(간체)
        case chi_t = "zh-Hant" // 중국어(번체)
        
        func getCodeForTrans() -> String {
            switch self {
            case .polish:
                return "pt"
                
            case .vietnamese:
                return "vi"
                
            case .chi:
                return "zh_cn"
                
            case .chi_t:
                return "zn_tw"
                
            default:
                return self.rawValue
            }
        }
        
        static var language: Language {
            get {
                guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
                    return Language.eng
                }
                
                if let languageCode = defaults.string(forKey: "Apple"),
                   let language = Language(rawValue: languageCode) {
                    return language
                }
                else {
                    var lang = NSLocale.current.languageCode ?? "en"
                    if lang == "zh" {
                        lang = "zh-" + (NSLocale.current.scriptCode ?? "")
                    }
                    
                    defaults.set(lang, forKey: "Apple")
                    
                    guard let localization = Language(rawValue: lang) else {
                        return Language.eng
                    }
                    
                    
                    return localization
                }
            }
            set {
                guard language != newValue else {
                    return
                }
                
                //change language in the app
                //the language will be changed after restart
                DispatchQueue.main.async {
                    if let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") {
                        defaults.set(newValue.rawValue, forKey: "Apple")
                        defaults.synchronize()
                        
                        NotificationCenter.default.post(name: Notification.Name("ChageLanguage"), object: self, userInfo: nil)
                    }
                }
            }
        }
    }
    
    enum LanguageName: String {
        case ar = "العربية"
        case de = "Deutsch"
        case en = "English" // 영어
        case es = "Español" // 스페인어
        case fr = "Français" // 프랑스어
        
        case hi = "हिन्दी"
        case id = "Bahasa Indonesia" // 인도네시아어
        case it = "Italiano"
        case ja = "日本語" // 일본어
        case ko = "한국어"   // 한국어
        
        case pl = "Język polski"  //폴란드
        case pt = "Português"    //포루투칼
        case ru = "русский" // 러시아어
        case th = "ภาษาไทย"    //태국
        case vi = "Tiếng Việt"       //베트남
        
        case zh = "中國語 (简体)" // 중국어(간체)
        case zn = "中國語 (繁體, 台灣)" // 중국어(번체)
        
        func getNameForTrans() -> String {
            switch self {
            case .th:
                return "Język polski"
                
            case .vi:
                return "Tiếng Việt"
                
            case .zh:
                return "中國語 (简体)"
                
            case .zn:
                return "中國語 (繁體, 台灣)"
                
            default:
                return self.rawValue
            }
        }
    }
    
    static let shared = LanguageManager()
    
    //ios lang code 기준으로 넣는다. 번역시에는 구글언어코드로 치환해서 써야한다.
    @AppStorage(DefineKey.language) private var languageCode: String = ""
    @AppStorage(DefineKey.langName) var languageName: String = ""
    
    //MARK: - Start
    //앱 시작 시 무조건 호출해서 세팅하자.
    func start() {
        if languageCode.count == 0 {
            var lang = NSLocale.current.languageCode ?? "en"
            if lang == "zh" || lang == "pt" || lang == "vi" {
                lang = lang + "-" + (NSLocale.current.scriptCode ?? "")
            }
            
            guard let localization = Language(rawValue: lang) else {
                languageCode = "en"
                return
            }
            
            languageCode = localization.rawValue
            LanguageManager.Language.language = localization
            
            //여기서 네임 지정
            if languageName.count == 0 {
                let langName = langname(code: languageCode)
                languageName = langName

            }
        }
    }
    
    
    //MARK: - Get
    func getLanguageName() -> String {
        return languageName
    }
    
    //언어팩이 코드에 맞춰서 바뀌어야하는데 languageCode가 언어팩에 맞는 코드
    func getLanguageCode() -> String {
        return languageCode
    }
    
    var isKor: Bool {
        languageCode == Language.kor.rawValue
    }
    
    var isRightAlignment: Bool {
        languageCode == Language.arabic.rawValue || languageCode == Language.hindi.rawValue
    }
    
    //번역용, 구글번역에 쓰이는 코드가 따로 있다.
    func getLanguageTransCode() -> String {
        if languageCode == "vi-VN" {
            return "vi"
        }
        else if languageCode == "pt-PT" {
            return "pt"
        }
        else if languageCode == "zh-Hans" {
            return "zh_cn"
        }
        else if languageCode == "zh-Hant" {
            return "zn_tw"
        }
        else if languageCode == "id" {
            return "in"
        }
        
        return languageCode
    }
    
    //서버용
    func getLanguageApiCode() -> String {
        if languageCode == "vi-VN" {
            return "vi"
        }
        else if languageCode == "pt-PT" {
            return "pt"
        }
        else if languageCode == "zh-Hans" {
            return "cn"
        }
        else if languageCode == "zh-Hant" {
            return "tw"
        }
        else if languageCode == "id" {
            return "in"
        }
        
        return languageCode
    }
    
    
    //MARK: - Set
    func setLanguageCode(code: String) {
        
        let lang = convertTransToLanguage(code: code)
        languageCode = lang
        
        LanguageManager.Language.language = LanguageManager.Language(rawValue: lang) ?? .eng
        
        let langName = langname(code: languageCode)
        languageName = langName

        NotificationCenter.default.post(name: Notification.Name(DefineNotification.changeLanguage), object: nil, userInfo: nil)
    }
    
    
    //MARK: - Method
    func convertTransToLanguage(code: String) -> String {
        if code == "vi" {
            return "vi-VN"
        }
        else if code == "pt" {
            return "pt-PT"
        }
        else if code == "cn" {
            return "zh-Hans"
        }
        else if code == "tw" {
            return "zh-Hant"
        }
        else if code == "in" {
            return "id"
        }
        
        return code
    }
    
    func convertLanguageToTrans(code: String) -> String {
        if code == "vi-VN" {
            return "vi"
        }
        else if code == "pt-PT" {
            return "pt"
        }
        else if code == "zh-Hans" {
            return "zh_cn"
        }
        else if code == "zh-Hant" {
            return "zn_tw"
        }
        else if code == "id" {
            return "in"
        }
        
        return code
    }
    
    func langname(code: String) -> String {
        switch code {
        case "pt":
            return "Português"
        case "pt-PT":
            return "Português"
        case "in":
            return "Bahasa Indonesia"
        case "id":
            return "Bahasa Indonesia"
        case "vi":
            return "Tiếng Việt"
        case "vi-VN":
            return "Tiếng Việt"
        case "th":
            return "ภาษาไทย"
        case "ar":
            return "العربية"
        case "es":
            return "Español"
        case "fr":
            return "Français"
        case "pl":
            return "Język polski"
        case "it":
            return "Italiano"
        case "ru":
            return "русский"
        case "de":
            return "Deutsch"
        case "hi":
            return "हिन्दी"
        case "zh-cn":
            return "中國語 (简体)"
        case "zh-Hans":
            return "中國語 (简体)"
        case "cn":
            return "中國語 (简体)"
        case "zh-tw":
            return "中國語 (繁體, 台灣)"
        case "zh-Hant":
            return "中國語 (繁體, 台灣)"
        case "tw":
            return "中國語 (繁體, 台灣)"
        case "ko":
            return "한국어"
        case "ja":
            return "日本語"
        case "en":
            return "English"
        default:
            return "English"
        }
    }
}
