//
//  LoginPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
//import Firebase
//import GoogleSignIn
import BottomSheet

struct LoginPage : View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let padding6: CGFloat = 6.0
        static let padding10: CGFloat = 10.0
        static let padding14: CGFloat = 14.0
        static let padding18: CGFloat = 18.0
        static let padding20: CGFloat = 20.0
        
        static let topPadding: CGFloat = 100.0
        static let bottomPadding: CGFloat = 20.0 + DefineSize.SafeArea.bottom
        
        static let logoSize: CGSize = CGSize(width: 174.0, height: 30.0)
        static let characterSize: CGSize = CGSize(width: 128.0, height: 128.0)
        static let warningSize: CGSize = CGSize(width: 16.0, height: 16.0)
        static let snsSize: CGSize = CGSize(width: 48.0, height: 48.0)
        
        static let logoBottomPadding: CGFloat = 54.0
        static let characterBottomPadding: CGFloat = 50.0
        
        static let dismissHeight: CGFloat = 42.0
        static let snsSpacing: CGFloat = 16.0
        
        static let horizontalPadding: CGFloat = 30.0
    }
    
    @State var showBottomSheetLanguageView = false
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var userManager = UserManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject var viewModel = LoginViewModel()
    @State var lang: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    Image("secondEnglish_logo_opacity")
                        .resizable()
                        .frame(width: sizeInfo.characterSize.width, height: sizeInfo.characterSize.height)
                        .padding(.bottom, sizeInfo.characterBottomPadding)
                        .padding(.top, sizeInfo.topPadding)
                    
                    //최근 로그인 계정 : 로그인한 이력이 없으면 감춘다.
                    if userManager.oldLoginType.count > 0 {
                        recentLoginAccountView
                        .padding(.bottom, sizeInfo.padding6)
                    }
                    
                    LoginButtonView(iconName: "btn_login_google", snsName: "Google", buttonType: .google) {
                        viewModel.loginWithGoogle()
                    }
                    .padding(.bottom, sizeInfo.padding10)
                    
                    LoginButtonView(iconName: "btn_login_apple", snsName: "Apple", buttonType: .apple) {
                        viewModel.loginWithApple()
                    }
                    .padding(.bottom, sizeInfo.padding10)
                    
                    LoginButtonView(iconName: "btn_logo_KakaoTalk", snsName: "카카오톡으", buttonType: .kakaotalk) {
                        viewModel.loginWithKakao()
                    }
                    .padding(.bottom, sizeInfo.padding10)
                    
                    
                    //signup with email
//                    NavigationLink(destination: JoinPasswordPage(email: "hana_815@naver.com")) {
//                        LoginEmailView()
//                    }
//                    
//                    NavigationLink(destination: EmailLoginPage()) {
//                        LoginEmailView()
//                    }
//                    
//                    NavigationLink(destination: JoinAgreePage(email: "hana_815@naver.com", snsId: "", loginType: LoginType.email.rawValue, password: "a123456!")) {
//                        LoginEmailView()
//                    }
                    
                    Spacer()
                    
                    Button {
                        userManager.isLogin = false
                        userManager.isLogout = false
                        userManager.isLookAround = true
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("d_look_around".localized)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                            .frame(height: sizeInfo.dismissHeight, alignment: .center)
                            .padding(.horizontal, sizeInfo.padding10)
                            .padding(.bottom, sizeInfo.bottomPadding)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bgLightGray50)
                .navigationDestination(isPresented: $viewModel.showAddUserNamePage) {
                    if let loginSuccessUserId = viewModel.authSuccessedLoginId,
                       let loginSuccessType = viewModel.authSuccessedLoginType
                    {
                        UserNamePage(
                            authSuccessedLoginId: loginSuccessUserId,
                            authSuccessedLoginType: loginSuccessType
                        )
                    }
                }
//                .navigationBarBackground {
//                    Color.bgLightGray50
//                }
//                .statusBarStyle(style: .darkContent)
//                
//                .background(
//                    NavigationLink("", isActive: $vm.showJoinPage) {
//                        JoinAgreePage(email: "", snsId: vm.joinIdx, loginType: vm.joinType.rawValue, password: "")
//                    }.hidden()
//                )
//                
//                .bottomSheet(isPresented: $showBottomSheetLanguageView, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//                    BSLanguageView(isShow: $showBottomSheetLanguageView, selectedLangName: $languageManager.languageName, selectedLangCode: languageManager.getLanguageTransCode(), isChangeAppLangCode: true, type: .nonType, onClick: {  language in
//                        languageManager.setLanguageCode(code: language)
//                    })
//                })
            }
            .showAlert(isPresented: $viewModel.showAlert, type: .Default, title: viewModel.alertTitle, message: viewModel.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            })
            
            LoadingViewInPage(loadingStatus: $viewModel.loadingStatus)
        }
        .onAppear() {
            //fLog("로그인페이지 onAppear")
            userManager.isLookAround = false
        }
        .onDisappear() {
            //fLog("로그인페이지 onDisappear")
        }
        // 외부(카톡)에서 공유링크타고 앱 진입시, 해당 게시글의 메인 화면이여야 됨 (클럽 게시글이면 클럽 메인, 커뮤니티 게시글이면 커뮤니티 메인)
        // 그래서 비회원으로 진입시 로그인 화면이 보여져 있는 경우에는 로그인 화면을 닫음
        .onChange(of: UserManager.shared.showInitialViewState) { value in
            userManager.isLogin = false
            userManager.isLogout = false
            userManager.isLookAround = true
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var recentLoginAccountView: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("icon_outline_danger")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.gray500)
                .frame(width: sizeInfo.warningSize.width, height: sizeInfo.warningSize.height)
            
            Group {
                Text(" ")
                Text("c_recent_login_account".localized)
                Text(" ")
                Text(userManager.oldLoginType)
            }
            .font(Font.caption11218Regular)
            .foregroundColor(Color.gray500)
        }
        .frame(height: sizeInfo.warningSize.height)
    }
    
}

#Preview {
    LoginPage()
}
