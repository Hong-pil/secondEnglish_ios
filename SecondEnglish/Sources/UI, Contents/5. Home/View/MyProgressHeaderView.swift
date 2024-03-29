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
            Image("icon_fill_bookmark")
                .resizable()
                .renderingMode(.template)
                .frame(width: 18, height: 18)
                .foregroundColor(isLike ? Color.primaryDefault : Color.stateDisabledGray200)
            
            Text(main_category)
                .font(.title41824Medium)
                .foregroundColor(.primaryDefault.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        //.padding(.top, index==0 ? 25 : 10)
        .padding(.vertical, 10)
        .background(Color.gray25)
    }
}

//#Preview {
//    MyProgressHeaderView()
//}
