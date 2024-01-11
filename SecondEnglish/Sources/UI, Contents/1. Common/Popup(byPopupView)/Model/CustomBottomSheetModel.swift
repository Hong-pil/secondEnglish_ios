//
//  CustomBottomSheetModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct CustomBottomSheetModel {
    let SEQ: Int
    var image: String = ""
    let title: String
}
//struct HomePageLanChoiceModel {
//    var SEQ: Int
//    var subTitle: String = ""
//    var subDescription: String = ""
//}

struct CustomBottomSheetCommonModel {
    let SEQ: Int
    let subTitle: String
    let subDescription: String
    
}

// 게시글 신고 모델
struct BottomSheetBoardReportModel {
    let SEQ: Int
    let message: String
    let reportMessageId: Int
}
