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
    case swipeListByCategory(category: String)
    case myCategoryProgress
    case likeCard(cardIdx: Int, isLike: Int)
    case myLikeCardList(uid: String)
    case myCardList
    case addCardList(type1: String, type2: String, type3: String, sentence_list: [Dictionary<String, String>])
    case getReportList
    case doReportCard(targetUid: String, targetCardIdx: Int, reportCode: Int)
    case doBlockCard(cardIdx: Int, isBlock: Int)
    case doBlockUser(targetUid: String, isBlock: Int)
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
        case .swipeListByCategory:
            return "api/beginner_sentence/all/category"
        case .myCategoryProgress:
            return "api/beginner_sentence/category/my/progress"
        case .likeCard:
            return "api/card/like"
        case .myLikeCardList:
            return "api/card/my"
        case .myCardList:
            return "api/card/my/list"
        case .addCardList:
            return "api/beginner_sentence/add/sentence_list"
        case .getReportList:
            return "api/report/category/all"
        case .doReportCard:
            return "api/card/report"
        case .doBlockCard:
            return "api/card/block"
        case .doBlockUser:
            return "api/user/block"
        }
    }
    
    //moya의 장점 각 메소드가 get 인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .swipeCategory:
            return .get
        case .swipeList:
            return .get
        case .swipeListByCategory:
            return .get
        case .myCategoryProgress:
            return .get
        case .likeCard:
            return .post
        case .myLikeCardList:
            return .get
        case .myCardList:
            return .get
        case .addCardList:
            return .post
        case .getReportList:
            return .get
        case .doReportCard:
            return .post
        case .doBlockCard:
            return .post
        case .doBlockUser:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .swipeCategory:
            let params = defaultParams
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
        case .swipeList:
            let params = defaultParams
            
//            params[DefineKey.integUid] = UserManager.shared.integUid
//            params["page"] = page
//            params["sortingNum"] = sortingNum
//            params["nextCheck"] = nextCheck ? "true" : "false"
//            params["searchText"] = searchText
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .swipeListByCategory(let catetory):
            var params = defaultParams
            
            params["uid"] = UserManager.shared.uid
            params["category"] = catetory

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .myCategoryProgress:
            var params = defaultParams
            
            params["uid"] = UserManager.shared.uid

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .likeCard(let cardIdx, let isLike):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            params["cardIdx"] = cardIdx
            params["isLike"] = isLike
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .myLikeCardList(let uid):
            var params = defaultParams
            params["uid"] = uid
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .myCardList:
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .addCardList(let type1, let type2, let type3, let sentence_list):
            var params = defaultParams
            params["user_name"] = UserManager.shared.userNick
            params["type1"] = type1
            params["type2"] = type2
            params["type3"] = type3
            params["sentence_list"] = sentence_list
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .getReportList:
            let params = defaultParams

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .doReportCard(let targetUid, let targetCardIdx, let reportCode):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            params["targetUid"] = targetUid
            params["targetCardIdx"] = targetCardIdx
            params["reportCode"] = reportCode
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .doBlockCard(let cardIdx, let isBlock):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            params["cardIdx"] = cardIdx
            params["isBlock"] = isBlock
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .doBlockUser(let targetUid, let isBlock):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            params["targetUid"] = targetUid
            params["isBlock"] = isBlock
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
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
