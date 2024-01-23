//
//  LoginEmailView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI

struct LoginEmailView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10
        
        static let viewSize: CGSize = CGSize(width: 240.0, height: 42.0)
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
        
        static let cornerRadius: CGFloat = 10.0
    }
    
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Image("Icon_email_login")
                    .resizable()
                    .scaledToFill()
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .foregroundColor(Color.gray800)
                    .padding(.leading, sizeInfo.padding)
                
                Text("a_continue_email".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 3)
            }
        }
        .frame(width: sizeInfo.viewSize.width, height: sizeInfo.viewSize.height, alignment: .center)
        .background(Color.bgLightGray50)
        .overlay(
            RoundedRectangle(cornerRadius: sizeInfo.cornerRadius)
            .stroke(Color.gray100, lineWidth: 0.5)
        )
    }
}

#Preview {
    LoginEmailView()
        .previewLayout(.sizeThatFits)
        .padding()
}
