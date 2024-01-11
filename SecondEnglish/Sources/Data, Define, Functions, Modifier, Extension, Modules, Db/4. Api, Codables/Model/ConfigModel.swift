//
//  ConfigModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct MconfigData: Codable {
    var adUrl: String? = ""
    var apiUrl: String? = ""
    var currentVersion: String? = ""
    var description: String? = ""
    var deviceType: String? = ""
    var enable: Int? = 0
    var endDate: String? = ""
    var forceUpdate: Int? = 0
    var imageUrl: String? = ""
    var integUid: String? = ""
    var messageEng: String? = ""
    var messageKr: String? = ""
    var payUrl: String? = ""
    var serviceType: String? = ""
    var startDate: String? = ""
    var transUrl: String? = ""
    var updateEnable: Int? = 0
    var webUrl: String? = ""
    var popupAppLink: String? = ""
    var popupImgKo: String? = ""
    var popupImgEn: String? = ""
    var popupStartDate: String? = ""
    var popupEndDate: String? = ""
    var popupEnable: Int? = 0
}
