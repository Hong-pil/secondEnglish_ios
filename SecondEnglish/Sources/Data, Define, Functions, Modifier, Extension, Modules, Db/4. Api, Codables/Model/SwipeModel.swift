//
//  SwipeModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct SwipeDataResponse: Codable {
    var code: Int = 0
    var data: SwipeDataListData? = nil
    var message: String? = ""
}

struct SwipeDataListData: Codable {
    var list: [SwipeDataList]? = []
    var grammar: SwipeDataGrammar? = nil
}

struct SwipeDataGrammar: Codable {
    var type2: String? = ""
    var type2_sort_num: Int? = 0
    var step1_title: String? = ""
    var step1_content: String? = ""
    var step2_title: String? = ""
    var step2_content: String? = ""
    var step3_title: String? = ""
    var step3_content: String? = ""
    var step4_title: String? = ""
    var step4_content: String? = ""
    var step5_title: String? = ""
    var step5_content: String? = ""
    var step6_title: String? = ""
    var step6_content: String? = ""
    var step7_title: String? = ""
    var step7_content: String? = ""
    var step8_title: String? = ""
    var step8_content: String? = ""
    var step9_title: String? = ""
    var step9_content: String? = ""
    var step10_title: String? = ""
    var step10_content: String? = ""
    var step11_title: String? = ""
    var step11_content: String? = ""
    var step12_title: String? = ""
    var step12_content: String? = ""
    var step13_title: String? = ""
    var step13_content: String? = ""
    var step14_title: String? = ""
    var step14_content: String? = ""
    var step15_title: String? = ""
    var step15_content: String? = ""
    var step16_title: String? = ""
    var step16_content: String? = ""
    var step17_title: String? = ""
    var step17_content: String? = ""
    var step18_title: String? = ""
    var step18_content: String? = ""
    var step19_title: String? = ""
    var step19_content: String? = ""
    var step20_title: String? = ""
    var step20_content: String? = ""
}

struct SwipeDataList: Codable, Hashable {
    var customId: Int? = 0
    var idx: Int? = 0
    var user_name: String? = ""
    var uid: String? = ""
    var type1: String? = ""
    var type2: String? = ""
    var type3: String? = ""
    var korean: String? = ""
    var english: String? = ""
    var isLike: Bool? = false
    var isUserBlock: Bool? = false
    var isCardBlock: Bool? = false
    var type2_sort_num: Int? = 0
    var type3_sort_num: Int? = 0
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
    var type2_sort_num: Int? = 0
    var type3_sort_num: Int? = 0
}

struct SubCategoryListModel: Codable, Hashable {
    var type3: String? = ""
    var type3_sort_num: Int? = 0
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
    var category_list: [CategoryListData] = []
}

struct UserBlockResponse: Codable {
    var code: Int = 0
    var data: [UserBlockData] = []
    var message: String? = ""
}
struct UserBlockData: Codable, Hashable {
    var idx: Int = 0
    var createdAt: String? = ""
    var updatedAt: String? = ""
    var uid: String? = ""
    var target_uid: String? = ""
    var target_nickname: String? = ""
}

struct PopularCardTop10Response: Codable {
    var code: Int = 0
    var data: PopularCardTop10Data? = nil
    var message: String? = ""
}
struct PopularCardTop10Data: Codable, Hashable {
    var startDay: String? = "" // 이번주 첫 날짜 : 20240324
    var endDay: String? = "" // 이번주 끝 날짜 : 20240330
    var list: [SwipeDataList] = []
}
struct CategoryListData: Codable, Hashable {
    var type3: String? = ""
    var type3_sort_num: Int? = 0
}

struct MyLearningProgressResponse: Codable {
    var code: Int = 0
    var data: [MyLearningProgressData]? = []
    var message: String? = ""
}
struct MyLearningProgressData: Codable, Hashable {
    var main_category: String? = ""
    var sub_category: String? = ""
    var category_sentence_count: Int? = 0
    var like_number: Int? = 0
    var today_new_count: Int? = 0
}

// 변환된 데이터 모델
struct MyLearningProgressMainCategory: Codable {
    let main_category: String
    var sub_category_list: [MyLearningProgressSubCategory]
    var isLike: Bool? = false
}

struct MyLearningProgressSubCategory: Codable {
    let sub_category: String
    let category_sentence_count: Int
    let like_number: Int
    let today_new_count: Int
}

struct ReportListResponse: Codable {
    var code: Int = 0
    var data: [ReportListData] = []
    var message: String? = ""
}
struct ReportListData: Codable, Hashable {
    var name: String? = ""
    var code: Int? = 0
}

struct ReportCardResponse: Codable {
    var code: Int = 0
    var success: Bool? = false
    var message: String? = ""
}

/**
 * 일단 통신해서 쓰기/읽기 완성했는데,
 * 생각해보니 처음부터 끝까지 완주하는 유저들이 많이 없을 거 같기 때문에
 * 일단, 서버에 저장하는 것 보단, 로컬에서 변수에 담아서 보여주는 방향으로 한다.
 */
struct KnowCardResponse: Codable {
    var code: Int = 0
    var success: Bool? = false
    var data: [KnowCardListData] = []
}
struct KnowCardListData: Codable, Hashable {
    var idx: Int? = 0
    var created_at: String? = ""
    var updated_at: String? = ""
    var uid: String? = ""
    var target_card_main_category: String? = ""
    var target_card_sub_category: String? = ""
    var target_card_idx: Int? = 0
}

/**
 * 일단 통신해서 쓰기/읽기 완성했는데,
 * 생각해보니 처음부터 끝까지 완주하는 유저들이 많이 없을 거 같기 때문에
 * 일단, 서버에 저장하는 것 보단, 로컬에서 변수에 담아서 보여주는 방향으로 한다.
 */
struct KnowCardLocalInfo: Codable, Hashable {
    var subCategory: String = ""
    var totalCount: Int = 0
    var swipeCount: Int = 0 // 카드 넘긴 개수 (카드 넘길 때마다 무조건 1 더함)
    var knowCount: Int = 0
}

struct MyAllMainCategoryResponse: Codable {
    var code: Int = 0
    var success: Bool? = false
    var data: [SwipeDataList]? = nil
}
struct MyAllSubCategoryCountModel {
    var type3: String
    var count: Int
}
