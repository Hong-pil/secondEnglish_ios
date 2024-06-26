//
//  EditorCategoryRowView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/16/24.
//

import SwiftUI

struct EditorCategoryRowView {
    let viewType: EditorCategoryViewType
    var categoryName: String
    var onPressCategory: (() -> Void)
    var selectedCategoryName: String = "" // 초기엔 선택되지 않음
}

extension EditorCategoryRowView: View {
    var body: some View {
        Button(action: {
            onPressCategory()
        }, label: {
            HStack(spacing: 0) {
                Text(categoryName)
                    .font(.title51622Medium)
                    .foregroundColor(selectedCategoryName == categoryName ? Color.primaryDefault : Color.gray400)
                
                Spacer()
                
                if selectedCategoryName == categoryName {
                    Image("icon_fill_check")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primaryDefault)
                }
            }
        })
    }
}

//#Preview {
//    EditorCategoryRowView()
//}
