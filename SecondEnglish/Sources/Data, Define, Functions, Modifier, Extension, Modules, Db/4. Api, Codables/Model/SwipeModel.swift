//
//  SwipeModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct SwipeDataResponse: Codable {
    var code: Int = 0
    var data: [SwipeDataList]? = []
    var message: String? = ""
}

struct SwipeDataList: Codable, Hashable {
    var customId: Int? = 0
    var idx: Int? = 0
    var type1: String? = ""
    var type2: String? = ""
    var type3: String? = ""
    var korean: String? = ""
    var english: String? = ""
    var isTimerplay: Bool? = false
    var isLike: Bool? = false
}

struct SwipeCategory: Codable {
    var code: Int = 0
    var data: [SwipeCategoryList]? = []
    var message: String? = ""
}

struct SwipeCategoryList: Codable, Hashable {
    var type1: String? = ""
    var type2: String? = ""
    var type3: String? = ""
}

struct LikeCardResponse: Codable {
    var code: Int = 0
    var success: Bool? = false
}

struct MyLikeCardResponse: Codable {
    var code: Int = 0
    var data: MyLikeCardList? = nil
    var message: String? = ""
}
struct MyLikeCardList: Codable {
    var liked_card_arr: [Int]? = []
}
