//
//  AlertManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI

class AlertManager {
    
    func showAlertMessage(message: String, notAvailable: () -> Void) {
        SimpleAlertView(
            contents: message
        )
        .present(notAvailable: notAvailable)
    }
    
    func isTransFail(notAvailable: () -> Void) {
        SimpleAlertView(
            title: "b_trans_alim".localized,
            contents: "b_trans_fail".localized
        )
        .present(notAvailable: notAvailable)
    }
    
    func showPermissionSetting(notAvailable: () -> Void) {
        SimpleAlertView(
            contents: PermissionCheck.albumPermissionMessage,
            buttons: ["c_cancel".localized, "s_setting".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        .present(notAvailable: notAvailable)
    }
    
    func showLoginAlert() {
        SimpleAlertView(
            title: "r_need_login".localized,
            contents: "se_r_need_login".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.showLoginView = true
            }
        }
        .present {
            UserManager.shared.showLoginAlert = true
        }
    }
    
    func showAlertAuthError() {
        SimpleAlertView(
            contents: "alert_auth_error".localized,
            buttons: ["h_confirm".localized]
        ) { _ in
            UserManager.shared.logout()
            PopupManager.dismissAll()
        }
        .present {
            UserManager.shared.showAlertAuthError = true
        }
    }
    
    func boardBlockRequestAlert() {
        SimpleAlertView(
            title: "a_block_post".localized,
            contents: "se_a_want_to_block_post".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.boardBlockRequestApi = true
            }
        }
        .present {
            UserManager.shared.boardBlockRequestAlert = true
        }
    }
    
    func boardUnBlockRequestAlert() {
        SimpleAlertView(
            title: "g_unblock_post".localized,
            contents: "se_a_want_to_unblock_post".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.boardUnBlockRequestApi = true
            }
        }
        .present {
            UserManager.shared.boardUnBlockRequestAlert = true
        }
    }
    
    func boardUserBlockRequestAlert() {
        SimpleAlertView(
            title: "g_block_account".localized,
            contents: "se_s_do_you_want_block_select_user".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.boardUserBlockRequestApi = true
            }
        }
        .present {
            UserManager.shared.boardUserBlockRequestAlert = true
        }
    }
    
    func boardUserUnBlockRequestAlert() {
        SimpleAlertView(
            title: "a_unblock_this_user".localized,
            contents: "se_s_do_you_want_release_block_select_user".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                UserManager.shared.boardUserUnBlockRequestApi = true
            }
        }
        .present {
            UserManager.shared.boardUserUnBlockRequestAlert = true
        }
    }
    
    func boardDeleteRequestAlert() {
        SimpleAlertView(
            title: "s_do_delete".localized,
            contents: "se_h_want_to_delete_post".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                PopupManager.dismissAll()
                UserManager.shared.boardDeleteRequestApi = true
            }
        }
        .present {
            UserManager.shared.boardDeleteRequestAlert = true
        }
    }
    
    func showProvideFanitAlert() {
        SimpleAlertView(
            type: .FanitAlert,
            title: "g_set_interest".localized,
            contents: "se_g_interests_complete_message".localized,
            fanitMessage: "500 FANiT"
        )
        .present {
            UserManager.shared.showProvideFanitAlert = true
        }
    }
    
    func showClubJoinAlert() {
        SimpleAlertView(
            contents: "se_k_can_using_after_join".localized,
            buttons: ["h_confirm".localized]
        ) { _ in
            LandingManager.shared.goBackClubPost = true
        }
        .present {
            UserManager.shared.showClubJoinAlert = true
        }
    }
    
    func replyEditRequestAlert() {
        SimpleAlertView(
            title: "a_modify_comment".localized,
            contents: "se_a_want_modify_comment".localized,
            buttons: ["c_cancel".localized, "h_confirm".localized]
        ) { buttonIndex in
            if buttonIndex == 1 {
                PopupManager.dismissAll()
                UserManager.shared.replyEditRequestApi = true
            }
        }
        .present {
            UserManager.shared.replyEditRequestAlert = true
        }
    }
    
    func showAlertNetworkDisconnected() {
        SimpleAlertView(
            contents: "se_a_disconnected_network".localized,
            buttons: ["h_confirm".localized]
        ) { _ in
            PopupManager.dismissAll()
        }
        .present {
            UserManager.shared.showAlertNetworkError = true
        }
    }
    
}
