//
//  Apis+LoginJoin.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Moya
import Alamofire
import Foundation

enum ApisLoginJoin {
    case send_sms(toPhoneNumber: String, accountSid: String, authToken: String, fromPhoneNumber: String)
    case verify_sms_code(toPhoneNumber: String, code: String, login_type: LoginUserType)
}

extension ApisLoginJoin: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .send_sms:
            return "api/send-sms"
        case .verify_sms_code:
            return "api/check-sms"
        }
    }
    
    // moya의 장점 : 각 메소드가 get인지 post인지 설정가능
    var method: Moya.Method {
        switch self {
        case .send_sms:
            return .post
        case .verify_sms_code:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .send_sms(let toPhoneNumber, let accountSid, let authToken, let fromPhoneNumber):
            var params = defaultParams
            params["toPhoneNumber"] = toPhoneNumber
            params["accountSid"] = accountSid
            params["authToken"] = authToken
            params["fromPhoneNumber"] = fromPhoneNumber
            
            log(params: params)
            return.requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .verify_sms_code(let toPhoneNumber, let code, let login_type):
            var params = defaultParams
            params["login_id"] = toPhoneNumber
            params["code"] = code
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
extension ApisLoginJoin {
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
extension ApisLoginJoin {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}

//MARK: - Caching Time : Seconds
extension ApisLoginJoin {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
