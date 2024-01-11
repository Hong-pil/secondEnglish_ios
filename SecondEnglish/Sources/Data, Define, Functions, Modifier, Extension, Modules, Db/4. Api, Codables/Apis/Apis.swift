//
//  Apis.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Moya
import Foundation
import Alamofire

enum Apis {
    case Mconfig(deviceType: String, serviceType: String)
}

extension Apis: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .Mconfig(_, let serviceType):
            return "mconfig/" + serviceType
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Mconfig:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .Mconfig(let deviceType, let serviceType):
            var params = defultParams
            params["deviceType"] = deviceType
            params["serviceType"] = serviceType
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
            
        default:
            header["Content-Type"] = "application/json"
        }
        
        return header
    }
    
    
    var defultParams: [String : Any] {
        return CommonFunction.defaultParams()
    }
    
    func log(params: [String: Any]) {
        fLog("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\nheader[\(headers ?? [:])]\n------------------------------------------------------------------------------------------------------------------------------\n")
    }
}

extension Apis {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}



//MARK: - Log On/Off
extension Apis {
    func isAlLogOn() -> Bool {
        return false
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
extension Apis {
    func isCheckToken() -> Bool {
        switch self {
        default: return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension Apis {
    func dataCachingTime() -> Int {
        switch self {
        default: return DataCachingTime.None.rawValue
        }
    }
}
