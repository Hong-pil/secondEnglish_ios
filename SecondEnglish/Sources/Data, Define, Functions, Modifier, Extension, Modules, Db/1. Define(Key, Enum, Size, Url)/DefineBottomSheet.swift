//
//  DefineBottomSheet.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI

struct DefineBottomSheet {
    
    @StateObject var languageManager = LanguageManager.shared
    
    static var reportListItems: [ReportListData] = []
    
    static var sliderAutoItems = [
        CustomBottomSheetModel(SEQ: 1, title: "자동"),
        CustomBottomSheetModel(SEQ: 2, title: "수동")
    ]
    
    static var swipeCardCutPercentItems = [
        CustomBottomSheetModel(SEQ: 1, title: "30% 자르기"),
        CustomBottomSheetModel(SEQ: 2, title: "50% 자르기"),
        CustomBottomSheetModel(SEQ: 3, title: "70% 자르기")
    ]
    
    static var globalLanItems: [CustomBottomSheetModel] = []
    static func resetGlobalLanItems() {
        globalLanItems = [
            CustomBottomSheetModel(SEQ: 1, title: "en_global".localized),
            CustomBottomSheetModel(SEQ: 2, title: "n_setting_to_my_language".localized),
            CustomBottomSheetModel(SEQ: 3, title: "d_other_language_select".localized),
        ]
    }
    
    //club setting
    static var clubOpenTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_g_open_post_in_board".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_k_hide_post_in_club".localized)
    ]
    static var memberNumberListTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_show_all_member_count".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_can_check_club_president".localized)
    ]
    static var memberListTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "k_open_all_club_members".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "k_member_only_available_club_president".localized)
    ]
    static var joinApprovalTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
    ]
    
    //club
//    static var clubOpenSettingOfClub = [
//        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_g_open_post_in_board".localized),
//        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_k_hide_post_in_club".localized)
//    ]
    static var clubOpenSettingOfClub: [CustomBottomSheetCommonModel] = []
    static func resetClubOpenSettingOfClub() {
        clubOpenSettingOfClub = [
            CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_g_open_post_in_board".localized),
            CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_k_hide_post_in_club".localized)
        ]
    }
    
//    static var joinApprovalSettingOfClub = [
//        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
//        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
//    ]
    static var joinApprovalSettingOfClub: [CustomBottomSheetCommonModel] = []
    static func resetJoinApprovalSettingOfClub() {
        joinApprovalSettingOfClub = [
            CustomBottomSheetCommonModel(SEQ: 0, subTitle: "j_auto".localized, subDescription: "g_join_immediately_after_apply".localized),
            CustomBottomSheetCommonModel(SEQ: 1, subTitle: "s_approval".localized, subDescription: "k_join_after_approves".localized)
        ]
    }
    
    //archive
    static var archiveVisibilityTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_b_can_see_non_join".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_g_visible_post".localized)
    ]
    static var archiveTypeTitle = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "a_image".localized, subDescription: "".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "a_general".localized, subDescription: "d_move_weblink_text".localized)
    ]
    
    //clubMember
    static var rejoinSetting = [
        CustomBottomSheetCommonModel(SEQ: 0, subTitle: "g_prohibition".localized, subDescription: "se_h_cannot_rejoin_this_id".localized),
        CustomBottomSheetCommonModel(SEQ: 1, subTitle: "h_allow".localized, subDescription: "se_h_can_rejoin_this_id".localized)
    ]
    
    
    static var cardMoreItem: [CustomBottomSheetModel] = []
    static func commonMore(type: CommonMore, result:((Bool) -> Void)? = nil) {
        var returnArr: [CustomBottomSheetModel] = []
        
        switch type {
        case .SwipeCardMore(let isUserBlock, let isCardBlock):
            returnArr =  [
                CustomBottomSheetModel(
                    SEQ: 1,
                    image: "icon_outline_siren",
                    title: "s_to_report".localized),
                CustomBottomSheetModel(
                    SEQ: 2,
                    image: "icon_outline_hide",
                    title: isUserBlock ? "a_see_post".localized : "a_block_post".localized),
                CustomBottomSheetModel(
                    SEQ: 3,
                    image: "icon_outline_blockaccount",
                    title: isCardBlock ? "a_unblock_this_user".localized : "a_block_this_user".localized),
            ]
        default:
            fLog("")
        }
        
        self.cardMoreItem = returnArr
        if let NOresult = result {
            NOresult(true)
        }
    }
}
