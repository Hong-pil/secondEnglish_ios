//
//  Apis+Setting.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/21/24.
//

import Moya
import Alamofire
import Foundation


enum ApisSetting {
    case cardBlock // 차단한 글
    case userBlock // 차단한 사용자
    case popularCardTop10(isWeek: Bool) // 주간/월간 인기 글 TOP10
}

extension ApisSetting: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .cardBlock:
            return "api/my/block/card"
        case .userBlock:
            return "api/my/block/user"
        case .popularCardTop10:
            return "api/top10/card"
        }
    }
    
    //moya의 장점 각 메소드가 get 인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .cardBlock:
            return .get
        case .userBlock:
            return .get
        case .popularCardTop10:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .cardBlock:
            var params = defaultParams

            params["uid"] = UserManager.shared.uid

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .userBlock:
            var params = defaultParams

            params["uid"] = UserManager.shared.uid

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .popularCardTop10(let isWeek):
            var params = defaultParams

            params["isWeek"] = isWeek ? "true" : "false"

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
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
extension ApisSetting {
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
extension ApisSetting {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}

//MARK: - Caching Time : Seconds
extension ApisSetting {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
