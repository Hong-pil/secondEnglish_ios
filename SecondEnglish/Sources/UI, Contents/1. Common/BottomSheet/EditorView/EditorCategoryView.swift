//
//  EditorCategoryView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/16/24.
//

import SwiftUI

enum EditorCategoryViewType: Int {
    case MainCategory
    case SubCategory
}

struct EditorCategoryView {
    let viewType: EditorCategoryViewType
    var mainCategoryList: [String]?
    var subCategoryList: [String]?
    @Binding var isShow: Bool
    @Binding var selectedCategoryName: String
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let headerBottomPadding: CGFloat = 15.0
        static let horizontalPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
}

extension EditorCategoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewType == .MainCategory ? "g_main_category_select".localized : "m_sub_category_select".localized)
                .font(.title51622Medium)
                .foregroundColor(.stateEnableGray900)
            
            ScrollView(showsIndicators: false) {
                Group {
                    if viewType == .MainCategory {
                        if let list = mainCategoryList {
                            ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                                EditorCategoryRowView(
                                    viewType: viewType,
                                    categoryName: item,
                                    onPressCategory: { categoryName in
                                        selectedCategoryName = categoryName
                                        isShow = false
                                    },
                                    selectedCategoryName: selectedCategoryName
                                )
                            }
                        }
                    }
                    else if viewType == .SubCategory {
                        if let list = subCategoryList {
                            ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                                EditorCategoryRowView(
                                    viewType: viewType,
                                    categoryName: item,
                                    onPressCategory: { categoryName in
                                        selectedCategoryName = categoryName
                                        isShow = false
                                    },
                                    selectedCategoryName: selectedCategoryName
                                )
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    EditorCategoryView()
//}