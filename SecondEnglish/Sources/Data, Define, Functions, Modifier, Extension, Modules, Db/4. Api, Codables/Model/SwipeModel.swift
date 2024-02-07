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
    var isLike: Bool? = false
    var isStartPointCategory: Bool? = false // 각 카테고리 시작점 유무 (홈탭에서 카드배너 넘겨질 때 카테고리 버튼 이동하는데 사용함)
    var isEndPointCategory: Bool? = false // 각 카테고리 마지막점 유무 (홈탭에서 카드배너 넘겨질 때 카테고리 버튼 이동하는데 사용함)
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

struct MyCardResponse: Codable {
    var code: Int = 0
    var data: MyCardData? = nil
    var message: String? = ""
}
struct MyCardData: Codable {
    var sentence_list: [SwipeDataList] = []
    var category_list: [String] = []
}
