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
    
    
    static var sliderAutoItems = [
        CustomBottomSheetModel(SEQ: 1, title: "자동"),
        CustomBottomSheetModel(SEQ: 2, title: "수동")
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
    
    // 클럽 상세 페이지 네비 더보기
    static var clubDetailNaviMore: [CustomBottomSheetModel] = []
    
    static func commonMore(type: CommonMore, result:((Bool) -> Void)? = nil) {
        var returnArr: [CustomBottomSheetModel] = []
        
        switch type {
            
            // 공지(커뮤니티 메인),공지(커뮤니티 각 카테고리) - 회원&&비회원
        case .CommunityNotice:
            returnArr =  [
                //CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                //CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                //CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                //CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                //CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                //CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
            ]
            
        // 커뮤니티 게시글(home/popular 피드에도 공통 적용) - type:1 = 회원(작성자)
        // 커뮤니티 게시글(home/popular 피드에도 공통 적용) - type:2 = 회원(비 작성자)
        // 커뮤니티 게시글(home/popular 피드에도 공통 적용) - type:3 = 비회원
        // 커뮤니티 게시글(home/popular 피드에도 공통 적용) - type:4 = 게시글 차단한 경우 => "게시글 차단 해제"만 보여줌
        // 커뮤니티 게시글(home/popular 피드에도 공통 적용) - type:5 = 사용자 차단한 경우 => "사용자 차단 해제"만 보여줌
        case .CommunityBoard(let type, let isSave, let isHide, let isBlock):
            // 예외처리_1 : 게시글 차단한 경우 => "게시글 차단 해제"만 보여줌
            if type == 4 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: "a_see_post".localized),
                ])
            }
            // 예외처리_2 : 사용자 차단한 경우 => "사용자 차단 해제"만 보여줌
            else if type == 5 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: "a_unblock_this_user".localized),
                ])
            }
            else {
                if type == 2 {
                    returnArr.append(contentsOf: [
                        CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                    ])
                }
                
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                    //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                ])
                
                if type == 2 {
                    returnArr.append(contentsOf: [
                        CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                        CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                        CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                    ])
                }
                
                if type == 1 {
                    returnArr.append(contentsOf: [
                        CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                        CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                    ])
                }
            }
            
        // 커뮤니티 댓글(home/popular 피드에도 공통 적용) - type:1 = 회원(작성자)
        // 커뮤니티 댓글(home/popular 피드에도 공통 적용) - type:2 = 회원(비 작성자)
        // 커뮤니티 댓글(home/popular 피드에도 공통 적용) - type:3 = 비회원
        case .CommunityReply(let type, _, let isHide, let isBlock):
            if type == 2 {
                returnArr.append(contentsOf: [
                    //CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                    //CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                    //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                    CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                    CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                ])
            }
            
            if type == 1 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
            
        // 공지 게시글(클럽) - type:1 = 클럽장
        // 공지 게시글(클럽) - type:2 = 멤버
        case .ClubNoticeBoard(let type, let isSave, _, _):
            if type == 2 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                ])
            }
            
            returnArr.append(contentsOf: [
                CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                //CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                //CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                //CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
            ])
            
            if type == 1 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
            
        // 공지 댓글(클럽) - type:1 = 클럽장 (작성자)
        // 공지 댓글(클럽) - type:2 = 클럽장 (비 작성자)
        // 공지 댓글(클럽) - type:3 = 멤버 (작성자)
        // 공지 댓글(클럽) - type:4 = 멤버 (비 작성자)
        case .ClubNoticeReply(let type, _, let isHide, let isBlock):
            if type == 4 {
                returnArr.append(contentsOf: [
                    //CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                    //CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                    //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                    CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                    CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                ])
            }
            
            if type == 1 || type == 3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                ])
            }
            
            if type == 1 || type == 2 || type == 3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
            
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:1 = 클럽장 (작성자)
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:2 = 클럽장 (비 작성자)
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:3 = 멤버 (작성자)
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:4 = 멤버 (비 작성자)
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:5 = 비멤버 (& 회원)
        // 클럽 게시글 (home/popular 피드에도 공통 적용) - type:6 = 비회원
        case .ClubBoard(let type, let isSave, let isHide, let isBlock):
            if type==2 || type==4 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                ])
            }
            
            returnArr.append(contentsOf: [
                CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
            ])
            
            if type==5 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                ])
            }
            
            if type==4 || type==5 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                ])
            }
            
            if type==4 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                    CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                ])
            }
            
            if type==1 || type==3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                ])
            }
            
            if type==1 || type==2 || type==3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
            
        // 클럽 댓글 (home/popular 피드에도 공통 적용) - type:1 = 클럽장 (작성자)
        // 클럽 댓글 (home/popular 피드에도 공통 적용) - type:2 = 클럽장 (비 작성자)
        // 클럽 댓글 (home/popular 피드에도 공통 적용) - type:3 = 멤버 (작성자)
        // 클럽 댓글 (home/popular 피드에도 공통 적용) - type:4 = 멤버 (비 작성자)
        // 클럽 댓글 (home/popular 피드에도 공통 적용) - type:5 = 비멤버 (& 회원)
        case .ClubReply(let type, _, let isHide, let isBlock):
            if type==4 || type==5 {
                returnArr.append(contentsOf: [
                    //CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                    //CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                    //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                    CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                ])
            }
            
            if type==4 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                    CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                ])
            }
            
            if type==1 || type==3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                ])
            }
            
            if type==1 || type==2 || type==3 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
            
        // 팬투TV,한류타임즈 댓글 (home/popular 피드에도 공통 적용) - type:1 = 팔로워(작성자)
        // 팬투TV,한류타임즈 댓글 (home/popular 피드에도 공통 적용) - type:2 = 팔로워(비 작성자)
        // 팬투TV,한류타임즈 댓글 (home/popular 피드에도 공통 적용) - type:3 = 언팔로워(& 회원)
        case .FantootvHanryutimesReply(let type, _, let isHide, _):
            if type==2 || type==3 {
                returnArr.append(contentsOf: [
                    //CustomBottomSheetModel(SEQ: 1, image: "icon_outline_favorite", title: isSave ? "j_to_save".localized : "j_save_cancel".localized),
                    //CustomBottomSheetModel(SEQ: 2, image: "icon_outline_share", title: "g_to_share".localized),
                    //CustomBottomSheetModel(SEQ: 3, image: "icon_outline_join", title: "g_to_join".localized),
                    CustomBottomSheetModel(SEQ: 4, image: "icon_outline_siren", title: "s_to_report".localized),
                ])
            }
            
            if type==2 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 5, image: "icon_outline_hide", title: isHide ? "a_block_post".localized : "a_see_post".localized),
                    //CustomBottomSheetModel(SEQ: 6, image: "icon_outline_blockaccount", title: isBlock ? "a_block_this_user".localized : "a_unblock_this_user".localized),
                ])
            }
            
            if type==1 {
                returnArr.append(contentsOf: [
                    CustomBottomSheetModel(SEQ: 7, image: "icon_outline_post_n", title: "s_modify".localized),
                    CustomBottomSheetModel(SEQ: 8, image: "icon_outline_trash", title: "s_do_delete".localized),
                ])
            }
        }
        
        self.clubDetailNaviMore = returnArr
        if let NOresult = result {
            NOresult(true)
        }
    }
}
