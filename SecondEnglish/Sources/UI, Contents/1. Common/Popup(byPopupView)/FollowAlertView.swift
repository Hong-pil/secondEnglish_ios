//
//  FollowAlertView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import PopupView
//import ExytePopupView
import SDWebImageSwiftUI


struct FollowAlertView: View {
    enum alertType: Int {
        case VoteAlert
        case FanitAlert
        case DateAlert
    }
    
    private struct sizeInfo {
        static let textSpacing: CGFloat = 12.0
        static let outLinePadding: CGFloat = 32.0
        static let buttonTop: CGFloat = 30.0
        static let buttonHeight: CGFloat = 36.0
    }
    
    @State var buttonToggle = false
    
    let clubProfileImg: String
    let title:String
    let message:String
    let number:String
    var detailMessage:String = ""
    let buttons:[String]
    let onClick: (Int) -> Void
    let onPress: () -> Void
    @Binding var isPresented:Bool
    @Binding var follow:Bool
    
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: clubProfileImg.imageOriginalUrl))
                    .placeholder(content: {
                        Image("profile_character_manager")
                            .resizable()
                    })
                    .resizable()
                    .frame(width: 54, height: 54, alignment: .center)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray25, lineWidth: 1)
                            .frame(width: 54, height: 54)
                    )
                    .padding(EdgeInsets(top: -65, leading: 0, bottom: 0, trailing: 0))
                
                HStack {
                    Spacer().frame(maxWidth: .infinity)
                    ZStack {
                        Button(action: {
                            onPress()
                        }, label: {
                            Text(follow ? "p_follow".localized : "p_following".localized)
                                .frame(height: 26)
                                .font(.caption11218Regular)
                                .padding(.horizontal, 5)
                                .foregroundColor(follow ? Color.gray25 : Color.primary500)
                                .background(follow ? Color.primary500 : Color.clear)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.primary500, lineWidth: 1)
                                        .frame(height: 26)
                                )
                        })
                    }
                }
                .padding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: -10))
                
                if title.count > 0 {
                    Text(title)
                        .font(Font.title41824Medium)
                        .foregroundColor(.gray870)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding([.bottom], message.count > 0 ? sizeInfo.textSpacing : sizeInfo.buttonTop)
                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                }
                
                if message.count > 0 {
                    ZStack {
                        HStack {
                            Text("p_follower".localized)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray400)
                            Text(message)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray700)
                        }
                    }
                    .frame(width: 240, height: 36, alignment: .center)
                    .background(Color.bgLightGray50)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.bgLightGray50, lineWidth: 0)
                            .frame(width: 240, height: 36)
                    )
                }
                if detailMessage.count > 0 {
                    Text(detailMessage)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray700)
                        .multilineTextAlignment(.center)
                }
                
                if buttons.count > 0 {
                    if buttons.count == 1 {
                        Button(buttons[0]) {
                            isPresented = false
                            onClick(0)
                        }
                        .buttonStyle(.borderless)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: sizeInfo.buttonHeight)
                        
                        .background(Color.stateEnablePrimaryDefault)
                        .cornerRadius(sizeInfo.buttonHeight/2)
                    }
                    //2개 까지만 하자.
                    else {
                        VStack(spacing: 0) {
                            Button {
                                isPresented = false
                                buttonToggle = false
                                onClick(0)
                            } label: {
                                Text(buttons[0])
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(buttonToggle ? Color.stateEnableGray400 : Color.gray25)
                                    .frame(width: 196, height: sizeInfo.buttonHeight)
                                    .background(buttonToggle ? Color.gray25 : Color.stateEnablePrimaryDefault)
                                    .cornerRadius(sizeInfo.buttonHeight / 2)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            Button {
                                isPresented = false
                                buttonToggle = true
                                onClick(1)
                            } label: {
                                Text(buttons[1])
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(buttonToggle ? Color.gray25 : Color.stateEnableGray400)
                                    .frame(width: 196, height: sizeInfo.buttonHeight)
                                    .background(buttonToggle ? Color.stateEnablePrimaryDefault : Color.gray25)
                                    .cornerRadius(sizeInfo.buttonHeight/2)
                            }
                        }
                    }
                    
                }
                else {
                    Button("h_confirm".localized) {
                        isPresented = false
                        onClick(0)
                    }
                    .buttonStyle(.borderless)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray25)
                    
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.buttonHeight)
                    
                    .background(Color.stateEnablePrimaryDefault)
                    .cornerRadius(sizeInfo.buttonHeight/2)
                }
            }
        }
        //        .frame(width: 276)
        .padding(EdgeInsets(top: 37, leading: sizeInfo.outLinePadding, bottom: 24                , trailing: sizeInfo.outLinePadding))
        .background(Color.gray25.cornerRadius(24))
//                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
//                .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
        .padding(.top, 32)

    }
}

struct FollowAlertViewModifier: ViewModifier {
    
    
    @Binding var isPresented:Bool
    @Binding var follow: Bool
    
    let clubProfileImg: String
    let title:String
    let message:String
    let number:String
    let buttons:[String]
    var detailMessage:String = ""
    let onClick: (Int) -> Void
    let onPress: () -> Void
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented) {
                FollowAlertView(clubProfileImg: clubProfileImg,
                                title: title,
                                message: message,
                                number: number,
                                detailMessage: detailMessage,
                                buttons: buttons, onClick: onClick,
                                onPress: onPress,
                                isPresented: $isPresented,
                                follow: $follow)
            } customize: {
                $0
                    .type(.default)
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.4))
            }
        
//            .popup(isPresented: $isPresented,
//                   dragToDismiss: true,
//                   closeOnTap: false,
//                   closeOnTapOutside: false,
//                   backgroundColor: .black.opacity(0.4),
//                   view: {
//                FollowAlertView(clubProfileImg: clubProfileImg,
//                                title: title,
//                                message: message,
//                                number: number,
//                                detailMessage: detailMessage,
//                                buttons: buttons, onClick: onClick,
//                                onPress: onPress,
//                                isPresented: $isPresented,
//                                follow: $follow)
//
//            })
    }
}

extension View {
    func showFollowAlert(
        isPresented: Binding<Bool>,
        follow: Binding<Bool>,
        clubProfileImg: String = "",
        title:String = "",
        message:String = "",
        number:String = "",
        detailMessage:String = "",
        buttons:[String],
        onClick:@escaping(Int) -> Void,
        onPressFollow:@escaping() -> Void) -> some View {
            modifier(FollowAlertViewModifier(isPresented: isPresented,
                                             follow: follow,
                                             clubProfileImg: clubProfileImg,
                                             title: title,
                                             message: message,
                                             number: number,
                                             buttons: buttons,
                                             detailMessage: detailMessage,
                                             onClick: onClick,
                                             onPress: onPressFollow))
        }
}
