//
//  LoginJoinModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct LoginJoinDataResponse: Codable {
    var code: Int = 0
    var success: Bool? = false
}

struct LoginSuccessResponse: Codable {
    var code: Int = 0
    var success: Bool = false
    var message: String? = ""
    var uid: String? = ""
    var access_token: String? = ""
    var refresh_token: String? = ""
}
