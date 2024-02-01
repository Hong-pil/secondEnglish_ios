//
//  Apis+Swipe.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Moya
import Alamofire
import Foundation


enum ApisSwipe {
    case swipeCategory
    case swipeList
    case likeCard(uid: String, cardIdx: Int, isLike: Int)
    case myLikeCardList(uid: String)
}

extension ApisSwipe: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .swipeCategory:
            return "api/beginner_sentence/category"
        case .swipeList:
            return "api/beginner_sentence/all"
        case .likeCard:
            return "api/card/like"
        case .myLikeCardList:
            return "api/card/my"
        }
    }
    
    //moya의 장점 각 메소드가 get 인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .swipeCategory:
            return .get
        case .swipeList:
            return .get
        case .likeCard:
            return .post
        case .myLikeCardList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .swipeCategory:
            var params = defaultParams
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
        case .swipeList:
            var params = defaultParams
            
//            params[DefineKey.integUid] = UserManager.shared.integUid
//            params["page"] = page
//            params["sortingNum"] = sortingNum
//            params["nextCheck"] = nextCheck ? "true" : "false"
//            params["searchText"] = searchText
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .likeCard(let uid, let cardIdx, let isLike):
            var params = defaultParams
            params["uid"] = uid
            params["cardIdx"] = cardIdx
            params["isLike"] = isLike
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .myLikeCardList(let uid):
            var params = defaultParams
            params["uid"] = uid
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
            
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        default:
            //header["Content-Type"] = "binary/octet-stream"
            //header["Content-Type"] = "application/x-www-form-urlencoded"
            header["Content-Type"] = "application/json"
            
        }
        
        //fLog("--- Header -----------------------------------\n\(header)")
        
        return header
    }
    
    var defaultParams: [String : Any] {
        return CommonFunction.defaultParams()
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            fLog("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\nheader[\(headers ?? [:])]\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}


//MARK: - Log On/Off
extension ApisSwipe {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        default: return [true, true]
        }
    }
    
    func isApiLogOn() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[0] {
            return true
        }
        return false
    }
    
    func isResponseLog() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[1] {
            return true
        }
        return false
    }
}

//MARK: - Check Token or not
extension ApisSwipe {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}

//MARK: - Caching Time : Seconds
extension ApisSwipe {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
