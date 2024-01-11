//
//  CommonModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

struct ErrorModel: Codable, Error {
    var code : String = ""
    
    var msg : String? = ""
//    var code: String = "" {
//        didSet {
//
//        }
//    }
    
    var dataObj: DataObj? = nil

    var message: String {
        return ErrorHandler.getErrorMessage(code: code)
    }
    
    var accessToken: String {
        return dataObj?.access_token ?? ""
    }
    
    var needReLogin: Bool {
        return accessToken.isEmpty
    }
}

struct DataObj: Codable {
    var access_token: String? = nil
    var path: String? = nil
    var error: String? = nil
    var time: String? = nil
    var message: String? = nil
}
