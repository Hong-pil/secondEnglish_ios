//
//  SettingListLinkView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct SettingListLinkView: View {
    @StateObject var languageManager = LanguageManager.shared
    enum TestAccountLinkViewType: Int {
        case Default
        case ClickAll
        case ClickAllWithArrow
        case ClickAllWithTextAndArrow
        case ClickRight
        case ClickRightWithArrow
        case ClickToggle
        case ClickLanguage
        case ClickUpdate
        case ClickAccount
    }
    
    let text: String
    let subText: String
    let lang: String
    let type: TestAccountLinkViewType
    let showLine: Bool
    var imageToggle: Bool = false
    let onPress: () -> Void
    @State var showAlert: Bool = false
//    @State var toggleIsOn: Bool = false
    @State var textId: String = ""
    @State var lineLimit: Int = 1
    
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 48.0
        static let cellHeight70: CGFloat = 70.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 16, height: 16)
        static let textSize: CGSize = CGSize(width: 20, height: 16)
        static let toggleSize: CGSize = CGSize(width: 40, height: 16)
        static let updateSize: CGSize = CGSize(width: 70, height: 24)
        static let idIconSize: CGSize = CGSize(width: 24, height: 24)
        static let idSize: CGFloat = 190
    }
    
    @AppStorage("toggleIsOn") var toggleIsOn = false

    var body: some View {
        ZStack {
            if type == .Default || type == .ClickAll || type == .ClickAllWithArrow || type == .ClickAllWithTextAndArrow {
                Button(
                    action: {
                        onPress()
                    },
                    label: {
                        HStack(spacing: 0) {
                            Text(text)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray870)
                                .padding([.leading], sizeInfo.cellPadding)
                                .padding([.trailing], sizeInfo.padding)
                                .fixedSize(horizontal: text.count > 50 ? false : true, vertical: true)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .allowsTightening(true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            if type != .ClickAllWithArrow {
                                Text(subText)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray500)
                                    .padding([.leading], sizeInfo.cellPadding)
                                    .padding([.trailing], type == .ClickAllWithArrow ? sizeInfo.padding : sizeInfo.cellPadding)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            }
                            
                            
                            if type == .ClickAllWithArrow {
                                Image("icon_outline_go")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                    .padding([.trailing], sizeInfo.cellPadding)
                                    .foregroundColor(.stateEnableGray200)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                    .buttonStyle(.borderless)
                    .disabled(type == .Default ? true : false)
            }
            else {
                HStack(spacing: 0) {
                    Button(
                        action: {
                            onPress()
                        },
                        label: {
                            Text(text)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray870)
                                .padding([.leading], sizeInfo.cellPadding)
                                .padding([.trailing], sizeInfo.padding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(alignment: .leading)
                        }
                    )
                    .buttonStyle(.borderless)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    if type == .ClickAccount {
                        Image("btn_logo_\(UserManager.shared.loginUserType)")
                            .resizable()
                            .frame(width: sizeInfo.idIconSize.width, height: sizeInfo.idIconSize.height, alignment: .leading)
                    }
                    
                    Button(
                        action: {
                            onPress()
                        },
                        label: {
                            HStack(spacing: 0) {
                                Text(subText)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray500)
//                                    .padding([.leading], sizeInfo.cellPadding)
                                    .padding([.trailing], type == .ClickRightWithArrow ? sizeInfo.padding : sizeInfo.cellPadding)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                
                                if type == .ClickRightWithArrow {
                                    Image("icon_outline_go")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                        .foregroundColor(.stateEnableGray200)
                                }
                                
                                if type == .ClickToggle {
                                   
                                    Toggle(isOn: $toggleIsOn, label: {
                                    })
                                        .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
//                                        .frame(width: sizeInfo.toggleSize.width, height: sizeInfo.toggleSize.height, alignment: .center)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                        .onChange(of: toggleIsOn) { value in
                                                       // action...
                                                       fLog(value)
                                            if value {
                                                showAlert = true
                                            }
                                                   }
                                }
                                if type == .ClickLanguage {
                                    Text(lang)
                                        .font(Font.body21420Regular)
                                        .foregroundColor(Color.stateEnablePrimaryDefault)
                                        .fixedSize(horizontal: true, vertical: true)
                                        .frame(width: sizeInfo.textSize.width, height: sizeInfo.textSize.height, alignment: .trailing)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                }
                                if type == .ClickAccount {
                                    HStack(spacing: 0) {
//                                        Image("btn_logo_\(UserManager.shared.loginType)")
//                                            .resizable()
//                                            .frame(width: sizeInfo.idIconSize.width, height: sizeInfo.idIconSize.height, alignment: .trailing)
//                                            .opacity(0)
//                                        Text(textId)
                                        Text(verbatim: accountText)
                                                .foregroundColor(Color.gray400)
                                                .font(Font.body21420Regular)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.trailing)
                                    }
                                    
                                    .frame(width: sizeInfo.idSize, alignment: .trailing)
                                    .padding([.trailing], sizeInfo.cellPadding)
                                }
                                if type == .ClickUpdate {
                                    HStack {
                                        Text("a_update".localized)
                                            .font(Font.body21420Regular)
                                            .foregroundColor(imageToggle ? Color.gray25 : Color.primary600)
                                            .fixedSize(horizontal: true, vertical: true)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 2)
                                            .frame(alignment: .center)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .background(RoundedRectangle(cornerRadius: 12).fill(imageToggle ? Color.gray200 : Color.primary100))
                                    }
                                    .padding([.trailing], sizeInfo.cellPadding)
                                }
                            }
                            .frame(maxHeight: .infinity)
                        }
                    )
                        .buttonStyle(.borderless)
                        .disabled(type == .ClickAccount ? true : false)
                }
                .frame(maxHeight: .infinity)
            }
            
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
//                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .frame(height: DefineSize.LineHeight)
                    .padding(EdgeInsets(top: type == .ClickAccount ? (UserManager.shared.account.count > 25 ? sizeInfo.cellHeight70 - DefineSize.LineHeight : sizeInfo.cellHeight - DefineSize.LineHeight) : (sizeInfo.cellHeight - DefineSize.LineHeight), leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: type == .ClickAccount ? (UserManager.shared.account.count > 25 ? sizeInfo.cellHeight70 : sizeInfo.cellHeight) : (sizeInfo.cellHeight)))
        .showAlert(isPresented: $showAlert,
                   type: .DateAlert,
                   title: "g_advertisement_alarm".localized,
                   message: "se_p_agree_market_info".localized,
                   detailMessage: "",
                   buttons: ["h_confirm".localized],
                   onClick: { buttonIndex in
            
        })
    }
    
    var accountText: String {
//        (UserManager.shared.loginType == DefineKey.email || UserManager.shared.loginType == DefineKey.phone) ? UserManager.shared.userEmail.isEmpty ? UserManager.shared.account : UserManager.shared.userEmail : UserManager.shared.account
        
        UserManager.shared.account
    }
}

//#Preview {
//    SettingListLinkView()
//}
