//
//  AccountInfoPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/31/24.
//

import SwiftUI
import PopupView

struct AccountInfoPage {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var languageManager = LanguageManager.shared
    @StateObject var userManager = UserManager.shared

    @StateObject var viewModel = AccountInfoViewModel()
    
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var showPasswordChangePage = false
    @State private var showLogoutPage = false
    @State private var showServiceWithdrawPage = false
    
    @State private var showAlert: Bool = false
    @State private var showAgreeAlert: Bool = false
    @State private var withdrawState: Bool = false
    
    @Binding var goBackMainPage: Bool
}

extension AccountInfoPage: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    SettingListLinkView(text:  "g_account".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAccount,
                                        showLine: true,
                                        onPress: {}
                    )

                    SettingListLinkView(text:  "r_logout".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        showLogoutPage = true
                    })
                    SettingListLinkView(text:  "s_leave".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        showServiceWithdrawPage = true
                    })
                }
            }
        }
        .modifier(ScrollViewLazyVStackModifier())
        .onAppear(perform: {
            viewModel.requestUserInfo()
        })
        
        .navigationType(leftItems: [.Back],
                        rightItems: [],
                        leftItemsForegroundColor: .black,
                        rightItemsForegroundColor: .black,
                        title: "g_account_info".localized,
                        onPress: { buttonType in
            fLog("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .showCustomAlert(isPresented: $showLogoutPage,
                         type: .Default, title: "r_logout".localized,
                         message: "se_r_question_login".localized,
                         detailMessage: "", buttons: ["a_no".localized, "h_confirm".localized],
                         onClick: { buttonIndex in
            if buttonIndex == 1 {
                viewModel.requestLogout() { isSuccess in
                    if isSuccess {
                        logout()
                    }
                }
            }
        })
        .fullScreenCover(isPresented: $showServiceWithdrawPage) {
            ServiceWithdrawPage(withdrawState: $withdrawState)
        }
        .onChange(of: withdrawState) {
            if withdrawState {
                UserManager.shared.logout()
                UserManager.shared.showLoginView = true
            }
        }
//        .showCustomAlert(isPresented: $showAlert,
//                   type: .DateAlert,
//                   title: "g_advertisement_alarm".localized,
//                   message: showAlert ? "se_p_agree_market_info".localized : "se_p_disagree_marketing_info".localized,
//                   detailMessage: "",
//                   buttons: ["h_confirm".localized],
//                   onClick: { buttonIndex in
//
//        })
//        .showCustomAlert(isPresented: $vm.showAgreeAlert,
//                         type: .DateAlert,
//                         title: "g_advertisement_alarm".localized,
//                         message: vm.toggleOn ? "se_p_agree_market_info".localized : "se_p_disagree_marketing_info".localized,
//                         detailMessage: "",
//                         buttons: ["h_confirm".localized],
//                         onClick: { buttonIndex in
//        })
    }
    
    func logout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            //Google Analytics
            //Analytics.logEvent("logout", parameters: nil)
            
            //Wisetracker
            //WisetrackerManager.shared.logout(type: userManager.loginType)
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            PopupManager.dismissLast()
            UserManager.shared.logout()
            
            goBackMainPage = false
            //presentationMode.wrappedValue.dismiss()
        }
    }
    
    func showAlertJoinWait() {
        SimpleAlertView(
            type: .DateAlert,
            title: "g_advertisement_alarm".localized,
            contents: userManager.marketingToggleOn ? "se_p_agree_market_info".localized : "se_p_disagree_marketing_info".localized)
        .present {
            viewModel.showAgreeAlert = true
        }
    }
}

#Preview {
    AccountInfoPage(goBackMainPage: .constant(false))
}
