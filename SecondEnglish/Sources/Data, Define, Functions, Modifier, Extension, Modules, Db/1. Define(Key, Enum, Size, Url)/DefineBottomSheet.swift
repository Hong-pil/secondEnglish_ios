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
        [
            SwipeCutBottomSheetModel(SEQ: 1, percent: 30, caption: "30% 앞에서부터 자르기"),
            SwipeCutBottomSheetModel(SEQ: 2, percent: 50, caption: "50% 앞에서부터 자르기"),
            SwipeCutBottomSheetModel(SEQ: 3, percent: 70, caption: "70% 앞에서부터 자르기")
        ],
        [
            SwipeCutBottomSheetModel(SEQ: 4, percent: 30, caption: "30% 뒤에서부터 자르기"),
            SwipeCutBottomSheetModel(SEQ: 5, percent: 50, caption: "50% 뒤에서부터 자르기"),
            SwipeCutBottomSheetModel(SEQ: 6, percent: 70, caption: "70% 뒤에서부터 자르기")
        ],
        [
            SwipeCutBottomSheetModel(SEQ: 7, percent: 30, caption: "30% 랜덤 자르기"),
            SwipeCutBottomSheetModel(SEQ: 8, percent: 50, caption: "50% 랜덤 자르기"),
            SwipeCutBottomSheetModel(SEQ: 9, percent: 70, caption: "70% 랜덤 자르기")
        ]
    ]
    static var swipeCardCutTypeItems = [
        CustomBottomSheetModel(SEQ: 0, title: "앞에서부터 자르기"),
        CustomBottomSheetModel(SEQ: 1, title: "뒤에서부터 자르기"),
        CustomBottomSheetModel(SEQ: 2, title: "랜덤 자르기")
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
        case .SwipeCardMore(let isUserBlock, let isCardBlock, let isAdmin, let isMyPost):
            /// 관리자 작성글 : 신고하기 / 이 글 차단
            /// 내가 작성한 글 : 수정하기 / 삭제하기
            /// 그 외 모두 : 신고하기 / 이 글 차단하기 / 사용자 차단하기
            ///
            /// 신고하기 SEQ : 1
            /// 이 글 차단하기 SEQ : 2
            /// 사용자 차단하기 SEQ : 3
            /// 수정하기 SEQ : 4
            /// 삭제하기 SEQ : 5
            if isAdmin {
                returnArr =  [
                    CustomBottomSheetModel(
                        SEQ: 1,
                        image: "icon_outline_siren",
                        title: "s_to_report".localized),
                    CustomBottomSheetModel(
                        SEQ: 2,
                        image: "icon_outline_hide",
                        title: isUserBlock ? "a_see_post".localized : "a_block_post".localized),
                ]
            }
            else if isMyPost {
                returnArr =  [
                    CustomBottomSheetModel(
                        SEQ: 4,
                        image: "icon_outline_edit",
                        title: "s_modify".localized),
                    CustomBottomSheetModel(
                        SEQ: 5,
                        image: "icon_outline_trash",
                        title: "s_do_delete".localized),
                ]
            }
            else {
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
            }
        default:
            fLog("")
        }
        
        self.cardMoreItem = returnArr
        if let NOresult = result {
            NOresult(true)
        }
    }
}
