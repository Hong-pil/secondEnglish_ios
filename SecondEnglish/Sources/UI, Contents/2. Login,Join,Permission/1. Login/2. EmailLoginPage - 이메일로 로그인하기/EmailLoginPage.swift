//
//  EmailLoginPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/23/24.
//

import SwiftUI

struct EmailLoginPage: View {
    
    private struct sizeInfo {
        static let padding8: CGFloat = 8.0
        static let textBottomPadding: CGFloat = 24.0
        static let loginButtonBottomPadding: CGFloat = 12.0
        static let inputHeight: CGFloat = 42.0
        static let dividerSize: CGSize = CGSize(width: 1.0, height: 14.0)
        static let dividerPadding: CGFloat = 6.0
    }
    
    @StateObject var languageManager = LanguageManager.shared
    //@StateObject var vm = EmailLoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    @State var emailCorrectStatus:CheckCorrectStatus = .Check
    @State var passwordCorrectStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: DefineSize.Contents.TopPadding)

            Text("a_continue_email".localized)
                .font(Font.title41824Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, sizeInfo.textBottomPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomTextField(
                text: $email,
                correctStatus: $emailCorrectStatus,
                isKeyboardEnter: $isKeyboardEnter,
                isFocused: .constant(false),
                placeholder: "a_write_email".localized
            )
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .padding(.bottom, sizeInfo.padding8)
                .onChange(of: email) { newValue in
                    if email.count > 0 {
                        if newValue.validateEmail() {
                            emailCorrectStatus = .Correct
                        }
                        else {
                            emailCorrectStatus = .Wrong
                        }
                    }
                    else {
                        emailCorrectStatus = .Check
                    }
                }
            
            CustomTextField(
                text: $password,
                correctStatus: $passwordCorrectStatus,
                isKeyboardEnter: $isKeyboardEnter,
                isFocused: .constant(false),
                placeholder: "b_password".localized,
                type: .Security
            )
                .frame(maxWidth: .infinity)
                .frame(height: sizeInfo.inputHeight)
                .padding(.bottom, sizeInfo.textBottomPadding)
                .onChange(of: password) { newValue in
                    if password.count > 4 {
                        passwordCorrectStatus = .Correct
                    }
                    else {
                        passwordCorrectStatus = .Check
                    }
                }
            
            //로그인
            if emailCorrectStatus == .Correct && passwordCorrectStatus == .Correct {
                Button {
                    //vm.login(loginId: email, loginPw: password)
                } label: {
                    CommonButton(title: "r_login".localized, bgColor: Color.stateEnablePrimaryDefault)
                        .padding(.bottom, sizeInfo.loginButtonBottomPadding)
                }
            }
            else {
                Button {
                } label: {
                    CommonButton(title: "r_login".localized, bgColor: Color.stateDisabledGray200)
                        .padding(.bottom, sizeInfo.loginButtonBottomPadding)
                }
                .disabled(true)
            }
            
            HStack(alignment: .center, spacing: 0) {
                NavigationLink(destination: JoinEmailPage()) {
                    Text("h_join".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray800)
                }
                
                VerticalDivider(color: Color.gray800, width: sizeInfo.dividerSize.width)
                    .frame(height: sizeInfo.dividerSize.height)
                    .padding(.horizontal, sizeInfo.dividerPadding)

//                NavigationLink(destination: FindPasswordPage()) {
//                    Text("b_find_password".localized)
//                        .font(Font.buttons1420Medium)
//                        .foregroundColor(Color.gray800)
//                }
            }
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
            fLog("onPress buttonType : \(buttonType)")
        })
//        .navigationBarBackground {
//            Color.gray25
//        }
//        .statusBarStyle(style: .darkContent)
//        .showAlert(isPresented: $vm.showAlert, type: .Default, title: vm.alertTitle, message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
//        })
    }
}

#Preview {
    EmailLoginPage()
}
