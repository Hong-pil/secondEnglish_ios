//
//  Apis+LoginSNS.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/30/24.
//

import Moya
import Alamofire
import Foundation

enum ApisLoginSNS {
    case addSnsUser(login_id: String, login_type: LoginUserType)
}

extension ApisLoginSNS: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .addSnsUser:
            return "api/users/sns/register"
        }
    }
    
    // moya의 장점 : 각 메소드가 get인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .addSnsUser:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .addSnsUser(let login_id, let login_type):
            var params = defaultParams
            params["login_id"] = login_id
            params["login_type"] = login_type.getValue()
            
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
    
    var defaultParams: [String: Any] {
        return CommonFunction.defaultParams()
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            fLog("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\nheader[\(headers ?? [:])]\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

//MARK: - Log On/Off
extension ApisLoginSNS {
    func isAllLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        default: return [true, true]
        }
    }
    
    func isApiLogOn() -> Bool {
        if self.isAllLogOn(), self.isLogOn()[0] {
            return true
        }
        return false
    }
    
    func isResponseLog() -> Bool {
        if self.isAllLogOn(), self.isLogOn()[1] {
            return true
        }
        return false
    }
}

//MARK: - Check Token or not
extension ApisLoginSNS {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}

//MARK: - Caching Time : Seconds
extension ApisLoginSNS {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
