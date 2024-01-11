//
//  SliderModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct SliderDataResponse: Codable {
    var code: Int = 0
    var data: [SliderDataList]? = []
}

struct SliderDataList: Codable, Hashable {
    var customId: Int? = 0
    var uid: String? = ""
    var type1: String? = ""
    var type2: String? = ""
    var type3: String? = ""
    var KOREAN: String? = ""
    var ENGLISH: String? = ""
}
