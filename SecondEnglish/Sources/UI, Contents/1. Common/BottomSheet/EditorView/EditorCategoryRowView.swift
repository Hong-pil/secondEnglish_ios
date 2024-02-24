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
    var onPressCategory: ((String) -> Void)
    var selectedCategoryName: String = "" // 초기엔 선택되지 않음
}

extension EditorCategoryRowView: View {
    var body: some View {
        Button(action: {
            onPressCategory(categoryName)
        }, label: {
            HStack(spacing: 0) {
                Text(categoryName)
                    .font(.body11622Regular)
                    .foregroundColor(selectedCategoryName == categoryName ? Color.primaryDefault : Color.gray800)
                
                Spacer()
                
                if selectedCategoryName == categoryName {
                    Image("icon_fill_check")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primaryDefault)
                }
            }
            .frame(height: 24)
        })
    }
}

//#Preview {
//    EditorCategoryRowView()
//}
