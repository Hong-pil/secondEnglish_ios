//
//  SettingPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI
import MessageUI
import WebKit

struct SettingPage: View {
    @Environment(\.openURL) private var openURL
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var userManager = UserManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var showingAlert = false
    
    // 아래부터 안 쓰는 변수들 정리하기

    @State var showList = false
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var shouldShowSetting = false
    @State private var showAccontPage = false
    
    @State private var showPostTransPage = false
    @State private var showTransPage = false
    @State private var showPushAlarmPage = false
    @State private var showMarketingPage = false
    
    @State private var showVersionPage = false
    @State private var showNoticePage = false
    @State private var showEmailInquiryPage = false
    @State private var showChatPage = false
    
    @State private var showServiceTermsPage = false
    @State private var showFantooTermPage = false
    @State private var showPersonalTermPage = false
    @State private var showYouthProtectionPage = false
    @State private var showClubAutoJoinPage = false
    
    @State private var showAlert: Bool = false
    @State private var showAgreeAlert: Bool = false
    
    @State private var checkMap:[String:Any] = [:]
    
    @Binding var goBackMainPage: Bool
    
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellLeadingPadding: CGFloat = 16.0
        static let cellBottomPadding: CGFloat = 5.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        ScrollView {
            
            LazyVStack(spacing: 0) {
                SettingListLinkView(text:  "g_account_info".localized,
                                    subText: "",
                                    lang: "",
                                    type: .ClickAllWithArrow,
                                    showLine: true,
                                    onPress: {
                    if userManager.isLogin {
                        showAccontPage = true
                    }
                    else {
                        userManager.showLoginAlert = true
                    }
                    
                })
                
                Rectangle()
                    .fill(Color.bgLightGray50)
                    .frame(height: 6)
                
                Text("g_customer_support".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray300)
                    .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0)  {
                    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.0.0"
                    let currentVersion = ConfigManager.shared.configData?.currentVersion ?? "2.0.0"
                    let checkUpdate = currentVersion < appVersion
                    
//                    SettingListLinkView(text: "\("b_version_info".localized) \(appVersion)",
//                                        subText: "",
//                                        lang: "",
//                                        type: .ClickUpdate,
//                                        showLine: true,
//                                        imageToggle: checkUpdate,
//                                        onPress: {
//                        
//                        CommonFunction.goAppStore()
//                    })
     
                    
//                    SettingListLinkView(text: "g_notice".localized,
//                                        subText: "",
//                                        lang: "",
//                                        type: .ClickAllWithArrow,
//                                        showLine: true,
//                                        onPress: {
//                        showNoticePage = true
//                    })
                    
                    SettingListLinkView(text:  "a_inquiry_email".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        
                        if MFMailComposeViewController.canSendMail() {
                            // 유저 이메일 설정되어 있음
                            self.sendEmail()
                        } else {
                            // 유저 이메일 설정되어 있지 않음
                            self.showingAlert = true
                        }
                    })
                }
                
                Rectangle()
                    .fill(Color.bgLightGray50)
                    .frame(height: 6)
                
                Text("s_term_service".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray300)
                    .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0)  {
                    SettingListLinkView(text: "s_term_use_service".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        showServiceTermsPage = true
                    })
                    .fullScreenCover(isPresented: $showServiceTermsPage) {
                        WebPage(url: DefineUrl.Domain.Api + "/policy/terms", title: "")
                        //WebPage(url: DefineUrl.Domain.Login + "/document/SERVICEAGREE?lang=\(LanguageManager.shared.getLanguageCode())", title: "")
                    }
                    
                    SettingListLinkView(text: "g_term_privacy_info".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        showPersonalTermPage = true
                    })
                    .fullScreenCover(isPresented: $showPersonalTermPage) {
                        //WebPage(url: DefineUrl.Domain.Login + "/document/USERINFOAGREE?lang=\(LanguageManager.shared.getLanguageCode())", title: "")
                        WebPage(url: DefineUrl.Domain.Api + "/policy/privacy", title: "")
                    }
                    
                    SettingListLinkView(text:  "c_term_youth".localized,
                                        subText: "",
                                        lang: "",
                                        type: .ClickAllWithArrow,
                                        showLine: true,
                                        onPress: {
                        showYouthProtectionPage = true
                    })
                    .fullScreenCover(isPresented: $showYouthProtectionPage) {
                        //WebPage(url: DefineUrl.Domain.Login + "/document/TEENAGERAGREE?lang=\(LanguageManager.shared.getLanguageCode())", title: "")
                        WebPage(url: DefineUrl.Domain.Api + "/policy/safeguard", title: "")
                    }
                }
            }
        }
        .modifier(ScrollViewLazyVStackModifier())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                HStack(spacing: 20) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                    })
                    
                    Text("s_setting".localized)
                        .font(.title51622Medium)
                        .foregroundColor(.black)
                }
                
            }
        }
        //.background(Color.bgLightGray50)
        .navigationDestination(isPresented: $showAccontPage) {
            AccountInfoPage(goBackMainPage: $goBackMainPage)
        }
        .showCustomAlert(isPresented: $showingAlert,
                         type: .Default,
                         title: "se_email_alert_title".localized,
                         message: "se_email_alert_content".localized,
                         detailMessage: "",
                         buttons: ["c_cancel".localized, "se_email_alert_setting".localized],
                         onClick: { buttonIndex in
            if buttonIndex == 1 {
                sendEmail()
            }
        })
    }
    
    func sendEmail() {
        if let url = URL(string: "mailto:\(DefineKey.inquiryEmail)") {
            openURL(url)
        }
    }
}

//#Preview {
//    SettingPage()
//}
