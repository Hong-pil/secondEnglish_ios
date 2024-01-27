//
//  JoinAgreePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/28/24.
//

import SwiftUI
import BottomSheet

struct JoinAgreePage : View {
    
    private struct sizeInfo {
        static let padding4: CGFloat = 4.0
        static let padding5: CGFloat = 5.0
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
        static let padding15: CGFloat = 15.0
        static let padding17: CGFloat = 17.0
        static let padding20: CGFloat = 20.0
        static let padding27: CGFloat = 27.0
        static let padding30: CGFloat = 30.0
        
        static let textBottomPadding: CGFloat = 24.0
        static let inputHeight: CGFloat = 42.0
        
        static let buttonSize: CGSize = CGSize(width: 86.0, height: 42.0)
        static let buttonCornerRadius: CGFloat = 7.0
        
        static let dropdownSize: CGSize = CGSize(width: 16.0, height: 16.0)
    }
    
    let email: String
    let snsId : String
    let loginType: String
    let password: String

    @StateObject var vm = JoinAgreeViewModel()
    @StateObject var languageManager = LanguageManager.shared

    var body: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .center, spacing: 0) {
                ScrollView() {
                    VStack(spacing: 0) {
                        Spacer().frame(height: DefineSize.Contents.TopPadding)
                        
                        Text("se_a_agree_term".localized)
                            .font(Font.title41824Medium)
                            .foregroundColor(Color.gray870)
                            .padding(.bottom, sizeInfo.textBottomPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        JoinAgreeCheckView { type, checkAll, checkAd in
                            fLog("\n--- check ---------------------\ncheckAll : \(checkAll), checkAd : \(checkAd)")
                            
                            if type == .Check {
                                vm.isAllAgree = checkAll
                                vm.isAdAgree = checkAd
                            }
                            else if type == .ShowServiceTerm {
                                vm.showWebPage = true
                                vm.showWebUrl = DefineUrl.Term.Service
                            }
                            else if type == .ShowPrivacyTerm {
                                vm.showWebPage = true
                                vm.showWebUrl = DefineUrl.Term.Privacy
                            }
                            else if type == .ShowYouthTerm {
                                vm.showWebPage = true
                                vm.showWebUrl = DefineUrl.Term.Youth
                            }
                            else if type == .ShowEventTerm {
                                vm.showWebPage = true
                                vm.showWebUrl = DefineUrl.Term.Event
                            }
                        }
                        
                        ExDivider(color: Color.gray400, height: 1)
                            .padding(.top, sizeInfo.padding27)
                            .padding(.bottom, sizeInfo.padding30)
                        
                        
                        NickNameSettingView
                        SelectCountryView
                        //ReferralCodeView
                        
                        if vm.checkInvalidate() {
                            Button {
                                if loginType == LoginType.email.rawValue {
                                        vm.requestEmailJoin(adAgreeChoice: vm.isAdAgree ? "Y" :"N", countryIsoTwo: vm.countryCode, email: email, loginPw: password, useReferralCode: vm.referralCode, userNick: vm.nickName)
                                }
                                else {
                                    vm.requestSnsJoin(adAgreeChoice: vm.isAdAgree ? "Y":"N", countryIsoTwo: vm.countryCode, snsIdx: snsId, type: loginType, useReferralCode: vm.referralCode, userNick: vm.nickName)
                                }
                            } label: {
                                CommonButton(title: "a_done".localized, bgColor: Color.stateEnablePrimaryDefault)
                                    .padding(.bottom, sizeInfo.padding20)
                            }
                        }
                        else {
                            Button {
                          
                            } label: {
                                CommonButton(title: "a_done".localized, bgColor: Color.stateDisabledGray200)
                                    .padding(.bottom, sizeInfo.padding20)
                            }
                            .disabled(true)
                        }
                    }
                    .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
                }
            }
            
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        })
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
            fLog("onPress buttonType : \(buttonType)")
        })
//        .navigationBarBackground {
//            Color.clear.shadow(radius: 0)
//        }
//        .statusBarStyle(style: .darkContent)
        
//        .background(
//            NavigationLink("", isActive: $vm.showWebPage) {
//                WebPage(url: vm.showWebUrl, title: "")
//            }.hidden()
//        )
        
//        .bottomSheet(isPresented: $vm.showCountryList, height: DefineSize.Screen.Height, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
//            BSCountryView(isShow: $vm.showCountryList, selectedCountryCode: vm.countryCode, type: .nonType) { countryData in
//                vm.countryCode = countryData.iso2
//                if LanguageManager.shared.getLanguageApiCode() == "ko" {
//                    vm.displayCountry = countryData.nameKr
//                } else {
//                    vm.displayCountry = countryData.nameEn
//                }
//            }
//        })
        
        .showCustomAlert(isPresented: $vm.showAlert,
                         type: .Default,
                         title: "",
                         message: vm.alertMessage,
                         detailMessage: "",
                         buttons: ["h_confirm".localized],
                         onClick: { buttonIndex in
        })
    }
    
    
    var NickNameSettingView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Text("n_setting_nickname".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray870)
                
                Text("*")
                    .foregroundColor(Color.primary500)
                    .font(.headline)
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Text("\(vm.nickName.count)")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray300) +
                
                Text("/30")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray300)
            }
            .padding(.bottom, sizeInfo.padding8)
            
            HStack(spacing: 0) {
                CustomTextField(
                    text: $vm.nickName,
                    correctStatus: $vm.nickNameCorrectStatus,
                    isKeyboardEnter: $vm.nickNameDidEnter,
                    isFocused: .constant(false),
                    placeholder: "se_n_write_nickname".localized
                )
                    .frame(height: sizeInfo.inputHeight)
                    .padding(.trailing, sizeInfo.padding5)
                    .onChange(of: vm.nickName) { newValue in
                        vm.nicknameValueCheck = false

                        if vm.nickName.count == 0 {
                            vm.nickNameCorrectStatus = .Check
                            vm.checkNickNameWarning = ""
                        }
                        else {
                            if vm.nickName.count >= 2, vm.nickName.count <= 30 {
                                vm.nickNameCorrectStatus = .Check
                                vm.checkNickNameWarning = ""
                            }
                            else {
                                vm.nickNameCorrectStatus = .Wrong
                                vm.checkNickNameWarning = "se_num_write_within".localized
                            }
                        }
                    }
                
                if vm.nickName.count >= 2, vm.nickName.count <= 20 {
                    Button {
                        vm.nicknameValueCheck = true
                        vm.requestCheckNickName(nickName: vm.nickName)
                    } label: {
                        VStack(spacing: 0) {
                            Text("j_check_duplicate".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray25)
                        }
                        .frame(width: sizeInfo.buttonSize.width, height: sizeInfo.buttonSize.height)
                        .background(vm.nickNameCorrectStatus == .Correct ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200)
                        .cornerRadius(sizeInfo.buttonCornerRadius)
                    }
                    .disabled(false)
                }
                else {
                    Button {
                        vm.nicknameValueCheck = true
                        vm.requestCheckNickName(nickName: vm.nickName)
                    } label: {
                        VStack(spacing: 0) {
                            Text("j_check_duplicate".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray25)
                        }
                        .frame(width: sizeInfo.buttonSize.width, height: sizeInfo.buttonSize.height)
                        .background(Color.stateDisabledGray200)
                        .cornerRadius(sizeInfo.buttonCornerRadius)
                    }
                    .disabled(false)
                }
                
            }
            
//            if vm.nickNameCorrectStatus == .Check {
//                Spacer().frame(height: sizeInfo.padding20)
//            }
//            else {
                Text(vm.checkNickNameWarning)
                    .font(Font.caption21116Regular)
                    .foregroundColor(vm.nickNameCorrectStatus == .Wrong ? Color.stateDanger : Color.primary500)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, sizeInfo.padding12)
                    .padding(.top, sizeInfo.padding4)
                    .padding(.bottom, sizeInfo.padding17)
                    .opacity(vm.nicknameValueCheck ? 1 : 0)
//            }
        }
    }
    
    
    var SelectCountryView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Text("g_select_country".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray870)
                
                Text("*")
                    .foregroundColor(Color.primary500)
                    .font(.headline)
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, sizeInfo.padding8)
            
            Button {
                vm.showCountryList = true
            } label: {
                HStack{
                    let countryName = vm.countryCode
                    Text(countryName.count > 0 ? vm.displayCountry : "g_select_country".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(countryName.count > 0 ? Color.gray870 : Color.gray400)
                    
                    Spacer()
                        .frame(maxHeight: .infinity)
                    
                    Image("icon_outline_dropdown")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.dropdownSize.width, height: sizeInfo.dropdownSize.height)
                        .foregroundColor(Color.gray400)
                }
                .padding(.horizontal, sizeInfo.padding15)
                .frame(height: sizeInfo.inputHeight)
                .background(Color.gray25)
                .cornerRadius(DefineSize.CornerRadius.TextField)
                .overlay(RoundedRectangle(cornerRadius: DefineSize.CornerRadius.TextField)
                    .stroke(Color.gray100, lineWidth: 1))
            }
            .padding(.bottom, sizeInfo.padding20)
        }
    }
    
    var ReferralCodeView: some View {
        VStack(spacing: 0) {
            Text("c_referral_code".localized)
                .font(Font.buttons1420Medium)
                .foregroundColor(Color.gray870)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, sizeInfo.padding8)
            
            
            CustomTextField(
                text: $vm.referralCode,
                correctStatus: $vm.referralCodeCorrectStatus,
                isKeyboardEnter: $vm.referralCodeDidEnter,
                isFocused: .constant(false),
                placeholder: "c_write_referral_code".localized
            )
                .frame(height: sizeInfo.inputHeight)
                .padding(.bottom, sizeInfo.padding30)
                .onChange(of: vm.referralCode) { newValue in
                    if vm.referralCode.count > 4 {
                        vm.referralCodeCorrectStatus = .Correct
                    }
                    else {
                        vm.referralCodeCorrectStatus = .Check
                    }
                }
        }
    }
}

#Preview {
    JoinAgreePage(email: "m@m.com", snsId: "", loginType: LoginType.email.rawValue, password: "a123456!")
        .previewLayout(.sizeThatFits)
}
