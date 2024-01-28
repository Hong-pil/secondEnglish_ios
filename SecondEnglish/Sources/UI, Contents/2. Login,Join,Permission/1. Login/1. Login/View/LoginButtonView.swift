//
//  LoginButtonView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI

enum LoginButtonType: Int {
    case google
    case apple
    case kakaotalk
    case phone
}

struct LoginButtonView : View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    var iconName: String
    var snsName: String
    let buttonType: LoginButtonType
    
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let horizontalPadding: CGFloat = 14.0
        static let padding: CGFloat = 30
        
        static let roundImageSize: CGSize = CGSize(width: 276.0, height: 42.0)
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    private struct colorInfo {
        static let kakaotalkColor: Color = Color(red: 248/255.0, green: 218/255.0, blue: 51/255.0, opacity: 1)
    }
    
    var body: some View {
        Button {
            onPress()
        } label: {
            ZStack {
                HStack(spacing: 0) {
                    Image(iconName)
                        .resizable()
                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                        .padding(.leading, sizeInfo.horizontalPadding)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text(snsName)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                    
                    Text("r_continue_at".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: sizeInfo.roundImageSize.width, height: sizeInfo.roundImageSize.height)
            .background(
                ((buttonType == .kakaotalk) ? colorInfo.kakaotalkColor : Color.gray25)
                    .cornerRadius(sizeInfo.roundImageSize.height / 2 )
            )
            .shadow(color: Color.gray100.opacity((buttonType == .kakaotalk || buttonType == .phone) ? 0 : 1), radius: 2, x: 0, y: 2)
        }
    }
}

#Preview {
    LoginButtonView(iconName: "btn_login_google", snsName: "google", buttonType: .apple) {
        
    }
    .previewLayout(.sizeThatFits)
    
}
