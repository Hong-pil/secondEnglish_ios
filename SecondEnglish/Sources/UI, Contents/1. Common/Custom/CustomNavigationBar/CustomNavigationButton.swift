//
//  CustomNavigationButton.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct CustomNavigationButton: View {
    
    let type:CustomNavigationBarButtonType
    let foregroundColor: Color
    var bookmarkForegroundColor: Color?
    let onPress: (CustomNavigationBarButtonType) -> Void
    
    private struct sizeInfo {
        static let iconEdgeInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
    }
    
    var body: some View {
        Button(
            action: {
                onPress(type)
            },
            label: {
                if type.isTextButton() {
                    Text(type.getText())
                        .font(Font.body21420Regular)
                        .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : foregroundColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                        .fixedSize()
                }
                else {
                    if type == .MarkActive {
                        Image(type.getImageString())
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: type.getImageSize().width, height: type.getImageSize().height)
                            .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : bookmarkForegroundColor)
                    }
                    else if type == .Logo {
                        Image(type.getImageString())
                    }
                    else {
                        Image(type.getImageString())
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: type.getImageSize().width, height: type.getImageSize().height)
                            .foregroundColor((type.getImageForegroundColor() != nil) ? type.getImageForegroundColor()! : foregroundColor)
                    }
                }
            }
        )
        .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
        .disabled(!type.isClickable())
        // 좌측 아이템들은 패딩값 안 줌
        .padding(.leading,
                 (type == .Back || type == .Home || type == .Logo || type == .Close || type == .AlertBack || type == .Search || type == .Profile || type == .AlarmOn || type == .Chatting || type == .ChattingNew || type == .Present || type == .AlarmNew || type == .CoverBack || type == .ClubSetting || type == .More || type == .Like || type == .UnLike)
                 ?
                 0 : 20)
        //홈 아이템은 패딩값 줘야 함
        .padding(.leading,
                 (type == .Search || type == .Profile || type == .AlarmOn || type == .Chatting || type == .ChattingNew || type == .Present || type == .AlarmNew || type == .ClubSetting || type == .More)
                 ?
                 16 : 0)
        // fullCover랑 겹치는 아이템
        .padding(.leading, (type == .CoverBack) ? -17 : 0)
        .padding(.trailing,
                 (type == .Close)
                 ?
                 20 : 0)
//        .padding(.horizontal, (type == .AlarmOn) ? 8 : 0)
    }
}
