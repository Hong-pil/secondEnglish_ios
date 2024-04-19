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
    case swipeCategory(category: String)
    case swipeMainCategory
    case swipeList
    case swipeListByCategory(main_category: String, sub_category: String)
    case myCategoryProgress
    case likeCard(cardIdx: Int, isLike: Int)
    case myLikeCardList
    case myPostCardList
    case addCardList(type1: String, type2: String, type3: String, sentence_list: [Dictionary<String, String>])
    case getReportList
    case doReportCard(targetUid: String, targetCardIdx: Int, reportCode: Int)
    case doBlockCard(cardIdx: Int, isBlock: String)
    case doBlockUser(targetUid: String, targetNickname: String, isBlock: String)
    case editCard(idx: Int, korean: String, english: String)
    case deleteCard(idx: Int)
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
        case .swipeMainCategory:
            return "api/beginner_sentence/category/main"
        case .swipeList:
            return "api/beginner_sentence/all"
        case .swipeListByCategory:
            return "api/beginner_sentence/all/category"
        case .myCategoryProgress:
            return "api/beginner_sentence/category/my/progress"
        case .likeCard:
            return "api/card/like"
        case .myLikeCardList:
            return "api/card/my/like_list"
        case .myPostCardList:
            return "api/card/my/post_list"
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
        case .editCard:
            return "api/card/edit"
        case .deleteCard:
            return "api/card/delete"
        }
    }
    
    //moya의 장점 각 메소드가 get 인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .swipeCategory:
            return .get
        case .swipeMainCategory:
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
        case .myPostCardList:
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
        case .editCard:
            return .post
        case .deleteCard:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .swipeCategory(let category):
            var params = defaultParams
            
            params["category"] = category
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
        case .swipeMainCategory:
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
            
        case .swipeListByCategory(let main_category, let sub_category):
            var params = defaultParams
            
            params["uid"] = UserManager.shared.uid
            params["main_category"] = main_category
            params["sub_category"] = sub_category

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
            
        case .myLikeCardList:
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .myPostCardList:
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .addCardList(let type1, let type2, let type3, let sentence_list):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
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
            
        case .doBlockUser(let targetUid, let targetNickname, let isBlock):
            var params = defaultParams
            params["uid"] = UserManager.shared.uid
            params["targetUid"] = targetUid
            params["targetNickname"] = targetNickname
            params["isBlock"] = isBlock
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .editCard(let idx, let korean, let english):
            var params = defaultParams
            params["idx"] = idx
            params["korean"] = korean
            params["english"] = english
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .deleteCard(let idx):
            var params = defaultParams
            params["idx"] = idx
            
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
