//
//  MyProgressCellView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct MyProgressCellView: View {
    var sub_category_index: Int
    var sub_category: String
    var main_category: String
    var like_number: Int
    var category_sentence_count: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                Text(sub_category)
                    .frame(width: DefineSize.Screen.Width/2, alignment: .leading)
                
                Spacer()
                Text(String(like_number))
                Text(" / ")
                Text(String(category_sentence_count))
            }
            .font(.buttons1420Medium)
            .foregroundColor(.black)
            
            Image(systemName: "chevron.right")
                .resizable()
                .renderingMode(.template)
                .frame(width: 10, height: 10)
                .foregroundColor(.gray400)
                .padding(.leading, 20)
                .padding(.top, 2)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(Color.gray25)
                .shadow(color: .gray200, radius: 2, x: 2, y: 2)
        )
        .padding(.bottom, 5)
        .onTapGesture {
            self.moveToSwipeTab(
                categoryIdx: sub_category_index,
                subCategoryName: sub_category,
                mainCategoryName: main_category
            )
            
        }
    }
    
    
    private func moveToSwipeTab(categoryIdx: Int, subCategoryName: String, mainCategoryName: String) {
        let dataDic: [String: Any] = ["subCategoryIdx": categoryIdx, "subCategoryName" : subCategoryName, "mainCategoryName": mainCategoryName]
        
        // Swipe Tab 으로 이동
        LandingManager.shared.showSwipePage = true
        
        //NotificationCenter.default.post(name: Notification.Name("workCompleted"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(
                name: Notification.Name(DefineNotification.moveToSwipeTab),
                object: nil,
                userInfo: [DefineKey.subCategoryIndexAndName : dataDic] as [String : Any]
            )
        }
    }
}

//#Preview {
//    MyProgressCellView()
//}
