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
    var mainCategoryList: [SwipeCategoryList]?
    var subCategoryList: [SwipeCategoryList]?
    @Binding var isShow: Bool
    @Binding var selectedCategory: SwipeCategoryList?
    
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
            if viewType == .MainCategory ||
                viewType == .SubCategory {
                Text(viewType == .MainCategory ? DefineKey.chapter : DefineKey.unit)
                    .font(.title41824Medium)
                    .foregroundColor(.stateEnableGray900)
                    .padding(.bottom, 20)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    if viewType == .MainCategory {
                        if let list = mainCategoryList {
                            ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                                EditorCategoryRowView(
                                    viewType: viewType,
                                    categoryName: item.type2 ?? "",
                                    onPressCategory: {
                                        selectedCategory = item
                                        isShow = false
                                    },
                                    selectedCategoryName: selectedCategory?.type2 ?? ""
                                )
                                .padding(.top, index==0 ? 0 : 15)
                                .padding(.bottom, index==list.count-1 ? 15 : 0)
                            }
                        }
                    }
                    else if viewType == .SubCategory {
                        if let list = subCategoryList {
                            ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                                EditorCategoryRowView(
                                    viewType: viewType,
                                    categoryName: item.type3 ?? "",
                                    onPressCategory: {
                                        selectedCategory = item
                                        isShow = false
                                    },
                                    selectedCategoryName: selectedCategory?.type3 ?? ""
                                )
                                .padding(.top, index==0 ? 0 : 15)
                                .padding(.bottom, index==list.count-1 ? 15 : 0)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    EditorCategoryView()
//}
