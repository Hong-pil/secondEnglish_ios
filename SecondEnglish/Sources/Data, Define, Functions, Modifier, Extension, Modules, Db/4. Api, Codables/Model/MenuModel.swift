//
//  MenuModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/21/24.
//

import Foundation

struct MenuResponse: Codable {
    var code: Int = 0
    var data: [SwipeDataList] = []
    var message: String? = nil
}

