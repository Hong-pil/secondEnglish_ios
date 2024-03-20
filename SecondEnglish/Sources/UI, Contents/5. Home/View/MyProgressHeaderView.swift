//
//  MyProgressHeaderView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct MyProgressHeaderView: View {
    var isLike: Bool
    var main_category: String
    var index: Int
    
    var body: some View {
        HStack(spacing: 5) {
            Image(isLike ? "icon_fill_like" : "icon_fill_dislike")
                .resizable()
                .renderingMode(.template)
                .frame(width: 18, height: 18)
                .foregroundColor(.primaryDefault)
            
            Text(main_category)
                .font(.title41824Medium)
                .foregroundColor(.primaryDefault.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .padding(.top, index==0 ? 25 : 10)
        .padding(.bottom, 10)
        .background(Color.gray25)
    }
}

//#Preview {
//    MyProgressHeaderView()
//}
