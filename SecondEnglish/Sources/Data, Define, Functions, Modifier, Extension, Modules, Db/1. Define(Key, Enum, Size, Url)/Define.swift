//
//  Define.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct Define {
    
    //oauth key
    struct OAuth {
        static let ClientId = "o2w7wixc5h7f6mrctn3yjy4a4g0m7hjk"
        static let CliendSecret = "j7c7zjgjoiyima92sf14dl2exjll6xzeffuiqsmsovze93jb68nuwet0g5bnl1fl"
        static let RedirectUrl = "https://fauth.fantoo.co.kr/token/redirect"
    }
    
    static let LANGUAGE_KEY = "Apple"
    static let ProfileDefaultImage = "profileCharacter"
    static let ClubDefaultImage = "club_img_default"
    
    struct Taboola {
        static let publisherId = "fantoo-ios"
        static let apiKey = "09b31c91273eeb0674729d1f6e3d70b4a88f9136"
        
        static let article = "article"
        static let pageUrl = "https://apps.apple.com/app/id1553859430"
        
        struct Position {
            struct Home_Home {
                static let mode = "thumbnails-mobile-1x1-a"
                static let placement = "iOS HomePage Text Under"
                static let pageType = "article"
            }
            
            struct Home_Popular {
                static let mode = "thumbnails-mobile-1x1-b"
                static let placement = "iOS HP Popular Text Under"
                static let pageType = "article"
            }
            
            struct Community_Main {
                static let mode = "thumbnails-mobile-stream-1x1-a"
                static let placement = "iOS Community Main Stream"
                static let pageType = "article"
            }
            
            struct Community_Category {
                static let mode = "thumbnails-mobile-stream-1x1-b"
                static let placement = "iOS Community Category Stream"
                static let pageType = "article"
            }
            
            //클럽탭, 클럽메인
            struct Club_Main {
                static let mode = "thumbnails-mobile-stream-1x1-c"
                static let placement = "iOS Club Stream"
                static let pageType = "article"
            }
            
            //각 클럽 홈
            struct Club_Home {
                static let mode = "thumbnails-mobile-1x1-c"
                static let placement = "iOS Club Text Under"
                static let pageType = "article"
            }
            
            struct Chatting_Main {
                static let mode = "thumbnails-mobile-stream-1x1-d"
                static let placement = "iOS Chat Stream"
                static let pageType = "article"
            }
            
            struct Post {
                static let mode = "thumbnails-mobile-stream-1x1-e"
                static let placement = "iOS Details Stream"
                static let pageType = "article"
            }
        }
    }
    
    static let defaultImages: [String] = [
        "profile_random_character1",
        "profile_random_character2",
        "profile_random_character3",
        "profile_random_character4",
        "profile_random_character5",
    ]
    // sample url) https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/cf1140b6-2856-46be-1655-be8f332fd500/public
//    static let defaultImages: [String] = [
//        "cf1140b6-2856-46be-1655-be8f332fd500",
//        "afda8132-07d6-4a23-25eb-a0a9d7adf500",
//        "6d8360e9-cc3e-47cc-9573-768ad242e200",
//        "262493ea-7997-4560-a868-069344977900",
//        "bdb62e54-5a3f-46b9-de6b-298ecdcbae00",
//    ]
}

public func fLog(_ object: Any, filename: String = #fileID, _ line: Int = #line, _ funcname: String = #function, _ date: Date = Date()) {
    print("[\(date)][\(filename) \(line)] \(object)")
}


struct LoginPublicKey {
    static let Key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnLe0m55w8tEJp+LTYAIixz7Cnk1ZjSRU0pgHWHS9ebT9pkO6fW46PdKpsdnFS65Y8S9wtFJSAq7g3PoDnTCTpd6jGdNnQDyqQoxZl6z7qnge1cxnEnZ/LK6mkhCCNv6oLY4uqYde7SSDKj5etyp6Ntbf2HTr5s2vSEDwicZbjtyVfeDuY2DHxwIcMweJsmcV74hcRlLFQZS0DR9d8Jfh1IaAGze8bmSye30fGwnODWxQtz0HREtJjPH0K4Fpt5Ot5WQMPRE8n9lo7VKuhZ8IYvvmGfdqUDCGn/ckIUjoWP9nO9OcSEP+q7SwuhgGETJXpQLe/HGA6YcxQgopso73HQIDAQAB"
}


/*
 [ChatGPT 만세]
 
 "swift에서 Codable 또는 Codable, Hashable 프로토콜을 상속받는 struct 타입 배열을 print()로 이쁘게 출력하는 방법을 알려줘."
 
 Swift에서 Codable 또는 Codable과 Hashable을 모두 준수하는 struct 타입의 배열을 print() 함수를 사용하여 예쁘게 출력하고 싶을 때, JSON 직렬화를 활용하는 방법이 있습니다. 이 방법은 JSONEncoder를 사용하여 struct 배열을 JSON 데이터로 변환하고, 이 데이터를 문자열로 변환하여 print 함수로 출력합니다. 이때, JSONEncoder의 outputFormatting 프로퍼티에 .prettyPrinted 옵션을 설정하면 JSON 문자열이 가독성 있게 출력됩니다.
 */
// Codable을 준수하는 어떤 타입의 데이터도 받아 JSON 형태로 예쁘게 출력하는 함수
func printPrettyJSON<T: Codable>(keyWord: String, from codableData: T) {
    // JSONEncoder를 사용하여 struct 배열을 JSON 문자열로 변환
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // 예쁘게 출력하기 위한 설정
    
    do {
        let jsonData = try encoder.encode(codableData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\(keyWord)\(jsonString)")
        }
    } catch {
        print("Error encoding JSON: \(error)")
    }
}
