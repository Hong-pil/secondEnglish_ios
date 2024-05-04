//
//  ContentView+Alert.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/12/24.
//

import Foundation
import SwiftUI
import PopupView

struct ContentViewAlert: ViewModifier {
    
    @StateObject var userManager = UserManager.shared
    @StateObject var configManager = ConfigManager.shared
    @StateObject var languageManager = LanguageManager.shared
    
    func body(content: Content) -> some View {
        content
        
        // 네트워크 끊김
            .showCustomAlert(
                isPresented: $userManager.showAlertNetworkError,
                type: .Default,
                title: "",
                message: "se_a_disconnected_network".localized,
                detailMessage: "",
                buttons: ["h_confirm".localized],
                onClick: { buttonIndex in
                    //
                })
        // 카드 랜덤정렬 불가
            .popup(isPresenting: $userManager.showCardShuffleError,
                   cornerRadius: 5,
                   locationType: .bottom,
                   autoDismiss: .after(2),
                   popup:
                    CommonPopupView(text: "card_shuffle_error".localized)
            )
        // 카드 자르기 불가
            .popup(isPresenting: $userManager.showCardCutError,
                   cornerRadius: 5,
                   locationType: .bottom,
                   autoDismiss: .after(2),
                   popup:
                    CommonPopupView(text: "card_cut_error".localized)
            )
        // SwipePage 자동모드시 버튼 클릭 불가
            .popup(isPresenting: $userManager.showCardAutoModeError,
                   cornerRadius: 5,
                   locationType: .bottom,
                   autoDismiss: .after(2),
                   popup:
                    CommonPopupView(text: "card_auto_error".localized)
            )
        // 카드 삭제
            .showCustomAlert(isPresented: $userManager.showCardDeleteAlert,
                             type: .Default,
                             title: "s_card_delete_title".localized,
                             message: "s_card_delete_body".localized,
                             detailMessage: "",
                             buttons: ["c_cancel".localized, "s_delete".localized],
                             onClick: { buttonIndex in
                if buttonIndex == 1 {
                    userManager.isCardDelete = true
                }
            })
        // 카드 삭제 완료 알림
            .popup(isPresenting: $userManager.showCardDeletepopup,
                   cornerRadius: 5,
                   locationType: .bottom,
                   autoDismiss: .after(2),
                   popup:
                    CommonPopupView(text: "se_g_post_deleted".localized)
            )
        // 게스트에게 로그인 유도
            .showCustomAlert(isPresented: $userManager.showLoginAlert,
                             type: .Default,
                             title: "",
                             message: "se_r_need_login".localized,
                             detailMessage: "",
                             buttons: ["c_cancel".localized, "r_login".localized],
                             onClick: { buttonIndex in
                if buttonIndex == 1 {
                    PopupManager.dismissAll()
                    UserManager.shared.logout()
                }
            })
        // Config Alert
        /*
         긴급공지, 업데이트 강제/권장
         */
            .showCustomAlert(isPresented: $configManager.showNoticeAlert,
                             type: .Default,
                             title: "g_notice_short".localized,
                             message: configManager.notice,
                             detailMessage: "",
                             buttons: ["j_quit".localized],
                             onClick: { buttonIndex in
                exit(-1)
            })
//            .showCustomAlert(isPresented: $configManager.showUpdateAlert,
//                             type: .Default,
//                             title: "a_update_noti".localized,
//                             message: "se_b_do_update_now".localized,
//                             detailMessage: "",
//                             buttons: ["n_later".localized, "a_update".localized],
//                             onClick: { buttonIndex in
//                if buttonIndex == 1 {
//                    CommonFunction.goAppStore()
//                }
//            })
//            .showCustomAlert(isPresented: $configManager.showForceUpdateAlert,
//                             type: .Default,
//                             title: "a_update_noti".localized,
//                             message: "se_b_do_update_now".localized,
//                             detailMessage: "",
//                             buttons: ["j_quit".localized, "a_update".localized],
//                             onClick: { buttonIndex in
//                if buttonIndex == 1 {
//                    CommonFunction.goAppStore()
//                }
//                else {
//                    exit(-1)
//                }
//            })
//        
//        
//        // Service Alert
//        // 위치 허용
////            .showCustomAlert(isPresented: $userManager.showAlertLocationPermission,
////                             type: .Default,
////                             title: "alert_location_title".localized,
////                             message: "alert_location_message".localized,
////                             detailMessage: "",
////                             buttons: ["alert_common_button_cancel".localized, "alert_common_button_setting".localized],
////                             onClick: { buttonIndex in
////                // 취소
////                if buttonIndex == 0 {
////                    //
////                }
////                // 설정
////                else if buttonIndex == 1 {
////                    // 앱 설정화면으로 이동
////                    DispatchQueue.main.async {
////                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
////                    }
////                }
////            })
//        
//        
//        
//        
//        
//        
//        //로그인알럿
//            .showCustomAlert(isPresented: $userManager.showLoginAlert,
//                             type: .Default,
//                             title: "r_need_login".localized,
//                             message: "se_r_need_login".localized,
//                             detailMessage: "",
//                             buttons: ["c_cancel".localized, "h_confirm".localized],
//                             onClick: { buttonIndex in
//                if buttonIndex == 1 {
//                    userManager.showLoginView = true
//                }
//            })
//        
//        //인증오류 알럿, 로그인뷰에서는 안뜬다.
//            .showCustomAlert(isPresented: $userManager.showAlertAuthError,
//                       type: .Default,
//                       title: "",
//                       message: "alert_auth_error".localized,
//                       detailMessage: "",
//                       buttons: ["h_confirm".localized],
//                       onClick: { buttonIndex in
//                userManager.logout()
//            })
//        // 게시글 차단
//            .showCustomAlert(isPresented: $userManager.boardBlockRequestAlert,
//                             type: .Default,
//                             title: "a_block_post".localized,
//                             message: "se_a_want_to_block_post".localized,
//                             detailMessage: "",
//                             buttons: ["c_cancel".localized, "h_confirm".localized],
//                             onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.boardBlockRequestApi = true
//                }
//            })
//        // 게시글 차단 해재
//            .showCustomAlert(isPresented: $userManager.boardUnBlockRequestAlert,
//                             type: .Default,
//                             title: "g_unblock_post".localized,
//                             message: "se_a_want_to_unblock_post".localized,
//                             detailMessage: "",
//                             buttons: ["c_cancel".localized, "h_confirm".localized],
//                             onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.boardUnBlockRequestApi = true
//                }
//            })
//        // 게시글 사용자 차단
//            .showCustomAlert(isPresented: $userManager.boardUserBlockRequestAlert,
//                             type: .Default,
//                             title: "g_block_account".localized,
//                             message: "se_s_do_you_want_block_select_user".localized,
//                             detailMessage: "",
//                             buttons: ["c_cancel".localized, "h_confirm".localized],
//                             onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.boardUserBlockRequestApi = true
//                }
//            })
//        // 게시글 사용자 차단 해제
//            .showCustomAlert(isPresented: $userManager.boardUserUnBlockRequestAlert,
//                             type: .Default,
//                             title: "a_unblock_this_user".localized,
//                             message: "se_s_do_you_want_release_block_select_user".localized,
//                             detailMessage: "",
//                             buttons: ["c_cancel".localized, "h_confirm".localized],
//                             onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.boardUserUnBlockRequestApi = true
//                }
//            })
//        // 게시글 댓글 수정
//            .showCustomAlert(isPresented: $userManager.replyEditRequestAlert,
//                       type: .Default,
//                       title: "a_modify_comment".localized,
//                       message: "se_a_want_modify_comment".localized,
//                       detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized],
//                       onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.replyEditRequestApi = true
//                }
//            })
//        // 게시글/댓글 삭제
//            .showCustomAlert(isPresented: $userManager.boardDeleteRequestAlert,
//                       type: .Default,
//                       title: "s_do_delete".localized,
//                       message: "se_h_want_to_delete_post".localized,
//                       detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized],
//                       onClick: { buttonIndex in
//                // 취소
//                if buttonIndex == 0 {
//                    //
//                }
//                // 확인
//                else if buttonIndex == 1 {
//                    userManager.boardDeleteRequestApi = true
//                }
//            })
//        // 클럽가입
//            .showCustomAlert(isPresented: $userManager.showClubJoinAlert,
//                             type: .Default,
//                             title: "",
//                             message: "se_k_can_using_after_join".localized,
//                             detailMessage: "",
//                             buttons: ["h_confirm".localized],
//                             onClick: { buttonIndex in
//                if buttonIndex == 0 {
//                    LandingManager.shared.goBackClubPost = true
//                }
//            })
//            .showCustomAlert(isPresented: $userManager.showSettingAuth,
//                             type: .Default,
//                             title: "테스트중",
//                             message: "허용해주세요",
//                             detailMessage: "",
//                             buttons: ["h_confirm".localized],
//                             onClick: { buttonIndex in
//                if buttonIndex == 0 {
//                    UserManager.shared.authorizedAlbum = true
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                }
//            })
//        
//        //관심사 설정
//        .showCustomAlert(isPresented: $userManager.showProvideFanitAlert,
//                         type: .FanitAlert,
//                         title: "g_set_interest".localized,
//                         message: "se_g_interests_complete_message".localized,
//                         fanitMessage: "500 FANiT",
//                         buttons: ["h_confirm".localized],
//                         onClick: { buttonIndex in
//        })
//        
//        
//        // 인증번호 전송 팝업
//        .popup(isPresenting: $userManager.certNumberAlert,
//               cornerRadius: 5,
//               locationType: .bottom,
//               autoDismiss: .after(2),
//               popup:
//                ZStack {
//            Spacer()
//            Text("se_a_sent_cert_number".localized)
//                .foregroundColor(Color.gray25)
//                .font(Font.body21420Regular)
//                .padding(.horizontal, 14)
//                .padding(.vertical, 8)
//                .background(Color.gray800)
//        }
//        )
//        
//        //보관함 삭제된 글
//            .popup(isPresenting: $userManager.deletePostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    CommonPopupView(text: "se_s_post_delete".localized))
//        
//        //보관함 신고된 글
//            .popup(isPresenting: $userManager.reportPostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    CommonPopupView(text: "se_s_post_hide_by_report_long".localized))
//        
//        // 위임 취소 완료
//            .popup(isPresenting: $userManager.delegateCancelCompleteAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    CommonPopupView(text: "se_k_completed_to_cancel_delegating".localized))
//        
//        // 위임 처리 완료
//            .popup(isPresenting: $userManager.delegateCompleteAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    CommonPopupView(text: "se_k_completed_to_delegating".localized))
//        
//        // 커뮤니티 알림 on
//            .popup(isPresenting: $userManager.CommunityAlimOn,
//                   cornerRadius: 5,
//                   locationType: .bottom,
//                   autoDismiss: .after(2),
//                   popup:
//                    CommonPopupView(text: "se_k_setted_community_alarm_on".localized)
//            )
//        // 커뮤니티 알림 off
//            .popup(isPresenting: $userManager.CommunityAlimOff,
//                   cornerRadius: 5,
//                   locationType: .bottom,
//                   autoDismiss: .after(2),
//                   popup:
//                    CommonPopupView(text: "se_k_setted_community_alarm_off".localized)
//            )
//        // 게시글 신고 완료
//            .popup(isPresenting: $userManager.boardReportAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_s_report_complete".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 이미 신고한 경우 알림
//            .popup(isPresenting: $userManager.boardReportAlreadyAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("Error_FE2025".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 삭제 완료된 경우 알림
//            .popup(isPresenting: $userManager.boardDeleteCompleteAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_g_post_deleted".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 차단 요청 완료
//            .popup(isPresenting: $userManager.boardBlockToastAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_g_post_blocked".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 차단 해제 요청 완료
//            .popup(isPresenting: $userManager.boardUnBlockToastAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_g_post_unblocked".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 사용자 차단 요청 완료
//            .popup(isPresenting: $userManager.boardUserBlockToastAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_s_blocked_select_user".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 게시글 사용자 차단 해제 요청 완료
//            .popup(isPresenting: $userManager.boardUserUnBlockToastAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("se_s_block_released_select_user".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
//        // 네트워크 오류
//            .popup(isPresenting: $userManager.showNetworkError, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
//                    ZStack {
//                Spacer()
//                Text("alert_network_error".localized)
//                    .foregroundColor(Color.gray25)
//                    .font(Font.body21420Regular)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.gray800)
//            }
//            )
    }
}


struct CommonPopupView: View {
    
    let text: String
    
    var body: some View {
        ZStack {
            Spacer()
            Text(text)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
    }
}
