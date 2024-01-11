//
//  CustomAlertView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI

struct CustomAlert: View {
    enum alertType: Int {
        case Default
        case ImageAlert
        case DateAlert
        case FanitAlert
        case followAlert
    }
    
    private struct sizeInfo {
        static let textSpacing: CGFloat = 12.0
        static let outLinePadding: CGFloat = 32.0
        static let buttonTop: CGFloat = 30.0
        static let buttonHeight: CGFloat = 36.0
        static let buttonTextSpacing: CGFloat = 5.0
    }
    
    @Binding var isPresented:Bool
    @Binding var buttonIndex:Int
    
    let type: alertType
    let title:String
    let message:String
    var detailMessage:String = ""
    var fanitMessage:String = ""
    let buttons:[String]
    
    let releaseDate = Date()
    static let stackDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 0.001

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            dimView
    
            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .background(BackgroundClearView())
        .ignoresSafeArea()
        .transition(.opacity)
        .onAppear(perform: {
            animate(isShown: true)
        })
    }
    
    
    private var alertView: some View {
        VStack(spacing: 0) {
            if type == .ImageAlert {
                HStack {
                    Spacer()
                    Button {
                        buttonIndex = 1
                        isPresented = false
                    } label: {
                        Text("SKIP")
                            .foregroundColor(Color.gray600)
                            .font(Font.caption11218Regular)
                    }
                }
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
                
                Image("character_login")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom, 10)
                
                if detailMessage.count > 0 {
                    Text(detailMessage)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray700)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
            }
            else if type == .Default {
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .fontWeight(.bold)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1620Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom], sizeInfo.buttonTop)
                }
            }
            else if type == .DateAlert {
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], sizeInfo.textSpacing)
                }
                
                
                Text("\(releaseDate, formatter: Self.stackDateFormat)")
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding([.bottom], sizeInfo.textSpacing)
                
            }
            else if type == .FanitAlert {
                if title.count > 0 {
                    Text(title)
                        .font(Font.title51622Medium)
                        .foregroundColor(.primary500)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if message.count > 0 {
                    Text(message)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
//                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                }
                
                if fanitMessage.count > 0 {
                    HStack {
                        Spacer().frame(height: .infinity)
                        Image("fanit_default")
                            .resizable()
                            .frame(width: 20, height: 20)
//                            .padding(.trailing, 20)
                        
                        Text(fanitMessage)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(.gray870)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: .infinity)
                    }
                    .padding(.vertical, sizeInfo.buttonTop)
                }
                
            }
            
            if buttons.count > 0 {
                if buttons.count == 1 {
                    Button {
                        animate(isShown: false) {
                            buttonIndex = 0
                            isPresented = false
                        }
                    } label: {
                        Text(buttons[0])
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
                }
                //2개 까지만 하자.
                else {
                    HStack(spacing: 0) {
                        Button {
                            animate(isShown: false) {
                                buttonIndex = 0
                                isPresented = false
                            }
                        } label: {
                            Text(buttons[0])
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray870)
                                .padding([.leading], sizeInfo.buttonTextSpacing)
                                .padding([.trailing], sizeInfo.buttonTextSpacing)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: sizeInfo.buttonHeight)
                                .background(Color.gray60)
                                .cornerRadius(sizeInfo.buttonHeight/2)
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer().frame(width: sizeInfo.textSpacing)
                        
                        Button {
                            animate(isShown: false) {
                                buttonIndex = 1
                                isPresented = false
                            }
                        } label: {
                            Text(buttons[1])
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
                    }
                }
                
            }
            else {
                Button {
                    animate(isShown: false) {
                        buttonIndex = 0
                        isPresented = false
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
            }
        }
        //.padding(EdgeInsets(top: 37, leading: sizeInfo.outLinePadding, bottom: 40, trailing: sizeInfo.outLinePadding))
        .padding(EdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20))
        .background(Color.gray25.cornerRadius(24))
        .clipped()
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
    }
    
    private var dimView: some View {
        Color.gray
            .opacity(0.66)
            .opacity(backgroundOpacity)
    }


    // MARK: - Function
    // MARK: Private
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
            withAnimation(.easeIn(duration: 0.1)) {

//            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
    
        case false:
            withAnimation(.easeOut(duration: 0.5)) {
                backgroundOpacity = 0
                opacity           = 0
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
        }
    }
}


struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented:Bool
    @State var buttonIndex: Int = 0
    
    let type: CustomAlert.alertType
    let title:String
    let message:String
    let buttons:[String]
    let detailMessage:String
    let fanitMessage:String
    
    let onClick: (Int) -> Void
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                CustomAlert(isPresented: $isPresented, buttonIndex: $buttonIndex, type: type, title: title, message: message, detailMessage: detailMessage, fanitMessage: fanitMessage, buttons: buttons)
                 
            }
            .transaction({ transaction in
                //transaction.disablesAnimations = false    // Alert 뷰 아래에서 나타남
                transaction.disablesAnimations = true   // Alert 뷰 아래에서 나타나지 않음
                //transaction.animation = .linear(duration: 0.5)
            })
            .onChange(of: isPresented) {
                if !isPresented {
                    fLog("\n--- close alert -------------------\nbuttonIndex : \(buttonIndex)\n")
                    onClick(buttonIndex)
                }
            }
    }
    
}

extension View {
    func showCustomAlertSimple(
        isPresented: Binding<Bool>,
        type: CustomAlert.alertType,
        title:String = "", message:String,
        detailMessage:String = "",
        fanitMessage:String = "",
        onClick:@escaping(Int) -> Void) -> some View {
            modifier(CustomAlertModifier(isPresented: isPresented, type: type, title: title, message: message, buttons: [], detailMessage: detailMessage, fanitMessage: fanitMessage, onClick: onClick))
        }
    
    func showCustomAlert(
        isPresented: Binding<Bool>,
        type: CustomAlert.alertType,
        title:String = "", message:String,
        detailMessage:String = "",
        fanitMessage:String = "",
        buttons:[String],
        onClick:@escaping(Int) -> Void) -> some View {
            modifier(CustomAlertModifier(isPresented: isPresented, type: type, title: title, message: message, buttons: buttons, detailMessage: detailMessage, fanitMessage: fanitMessage, onClick: onClick))
        }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
