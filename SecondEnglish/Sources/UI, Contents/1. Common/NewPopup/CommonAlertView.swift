//
//  CommonAlertView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct SimpleAlertView: CentrePopup {
    
    struct sizeInfo {
        static let textSpacing: CGFloat = 12.0
        static let outLinePadding: CGFloat = 32.0
        static let middlePadding: CGFloat = 24.0
        static let buttonTop: CGFloat = 30.0
        static let buttonHeight: CGFloat = 36.0
        static let buttonTextSpacing: CGFloat = 5.0
    }
    
    var type: CustomAlert.alertType = .Default
    var autoDismiss = true
    var title: String = ""
    var contents: String = ""
    var detailMessage:String = ""
    var fanitMessage:String = ""
    var buttons: [String] = []
    var buttonHandler: ((Int) -> Void)? = nil
    
    let releaseDate = Date()
    static let stackDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup
            .tapOutsideToDismiss(false)
            .horizontalPadding((UIScreen.screenWidth * 0.25)/2)
    }
    
    func createContent() -> some View {
        VStack {
            if !title.isEmpty {
                createTitle()
            }
            
            if !contents.isEmpty {
                createContents()
            }
            
            if type == .DateAlert {
                createDate()
            } else if type == .FanitAlert {
                createFanitMessage()
            }
            
            createButtons()
        }
        .padding(32)
    }
}

extension SimpleAlertView {
    func createTitle() -> some View {
        Text(title)
            .font(Font.title51622Medium)
            .foregroundColor(.primary500)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding([.bottom], (contents.count > 0 ) ? sizeInfo.textSpacing : sizeInfo.middlePadding)
    }
    
    func createContents() -> some View {
        Text(contents)
            .font(Font.buttons1420Medium)
            .foregroundColor(.gray870)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding([.bottom], type == .Default ? sizeInfo.middlePadding : sizeInfo.textSpacing)
    }
    
    func createDate() -> some View {
        Text("\(releaseDate, formatter: Self.stackDateFormat)")
            .font(Font.caption11218Regular)
            .foregroundColor(.gray700)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding([.bottom], sizeInfo.textSpacing)
    }
    
    func createFanitMessage() -> some View {
        ZStack {
            Spacer()
            Image("fanit_default")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 100))
            Text(fanitMessage)
                .font(Font.buttons1420Medium)
                .foregroundColor(.gray870)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(EdgeInsets(top: sizeInfo.textSpacing, leading: 0, bottom: sizeInfo.buttonTop, trailing: 0))
    }
    
    func createButtons() -> some View {
        HStack(spacing: sizeInfo.textSpacing) {
            if buttons.isEmpty {
                Button {
                    buttonHandler?(0)
                    if autoDismiss {
                        dismiss()
                    }
                } label: {
                    Text("h_confirm".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        .padding([.leading], sizeInfo.buttonTextSpacing)
                        .padding([.trailing], sizeInfo.buttonTextSpacing)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: sizeInfo.buttonHeight)
                        .background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(sizeInfo.buttonHeight/2)
                }
                .buttonStyle(.borderless)
            } else {
                ForEach(Array(buttons.enumerated()), id: \.offset) { index, button in
                    Button {
                        buttonHandler?(index)
                        if autoDismiss {
                            dismiss()
                        }
                    } label: {
                        Text(button)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray25)
                            .padding([.leading], sizeInfo.buttonTextSpacing)
                            .padding([.trailing], sizeInfo.buttonTextSpacing)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: sizeInfo.buttonHeight)
                            .background(index == buttons.count - 1 ? Color.stateEnablePrimaryDefault : Color.stateEnableGray200)
                            .cornerRadius(sizeInfo.buttonHeight/2)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

struct CommonAlertView<Content>: CentrePopup where Content: View {
    
    let title: (() -> Content)?
    let contents: (() -> Content)?
    let buttons: [String]
    let buttonHandler: ((Int) -> Void)?
    let autoDismiss: Bool
    
    init(autoDismiss: Bool = true,
         @ViewBuilder title: @escaping () -> Content,
         @ViewBuilder contents: @escaping () -> Content,
         buttons: [String] = [],
         buttonHandler: @escaping (Int) -> Void = { _ in }
    ) {
        self.title = title
        self.contents = contents
        self.autoDismiss = autoDismiss
        self.buttons = buttons
        self.buttonHandler = buttonHandler
    }
    
    init(autoDismiss: Bool = true,
         @ViewBuilder title: @escaping () -> Content,
         buttons: [String] = [],
         buttonHandler: @escaping (Int) -> Void = { _ in }
    ) {
        self.title = title
        self.contents = nil
        self.autoDismiss = autoDismiss
        self.buttons = buttons
        self.buttonHandler = buttonHandler
    }
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup.horizontalPadding((UIScreen.screenWidth * 0.25)/2)
    }
    
    func createContent() -> some View {
        VStack {
            if let view = title {
                view()
                    .padding(.bottom, contents == nil ? 20 : 8)
            }
            if let view = contents {
                view()
                    .padding(.bottom, 20)
            }
            
            createButtons()
        }
        .padding(32)
    }
    
    func createButtons() -> some View {
        HStack(spacing: SimpleAlertView.sizeInfo.textSpacing) {
            if buttons.isEmpty {
                Button {
                    buttonHandler?(0)
                    if autoDismiss {
                        dismiss()
                    }
                } label: {
                    Text("h_confirm".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        .padding([.leading], SimpleAlertView.sizeInfo.buttonTextSpacing)
                        .padding([.trailing], SimpleAlertView.sizeInfo.buttonTextSpacing)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: SimpleAlertView.sizeInfo.buttonHeight)
                        .background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(SimpleAlertView.sizeInfo.buttonHeight/2)
                }
                .buttonStyle(.borderless)
            } else {
                ForEach(Array(buttons.enumerated()), id: \.offset) { index, button in
                    Button {
                        buttonHandler?(index)
                        if autoDismiss {
                            dismiss()
                        }
                    } label: {
                        Text(button)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray25)
                            .padding([.leading], SimpleAlertView.sizeInfo.buttonTextSpacing)
                            .padding([.trailing], SimpleAlertView.sizeInfo.buttonTextSpacing)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: SimpleAlertView.sizeInfo.buttonHeight)
                            .background(index == buttons.count - 1 ? Color.stateEnablePrimaryDefault : Color.stateEnableGray200)
                            .cornerRadius(SimpleAlertView.sizeInfo.buttonHeight/2)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}
