//
//  TabHomeMyProgressView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/16/24.
//

import SwiftUI

struct TabHomeMyProgressView: View {
    let categoryData: MyLearningProgressMainCategory
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Image((categoryData.isLike ?? false) ? "icon_fill_like" : "icon_fill_dislike")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.primaryDefault)
                
                Text(categoryData.main_category)
                    .font(.title41824Medium)
                    .foregroundColor(.primaryDefault.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach((Array(categoryData.sub_category_list.enumerated())), id: \.offset) { index, item in
                        
                        HStack(spacing: 0) {
                            Group {
                                Text(item.sub_category)
                                    .frame(width: DefineSize.Screen.Width/2, alignment: .leading)
                                
                                Spacer()
                                Text(String(item.like_number))
                                Text(" / ")
                                Text(String(item.category_sentence_count))
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
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                        .background(
                            Rectangle()
                                .fill(Color.gray25)
                                .shadow(color: .gray200, radius: 2, x: 2, y: 2)
                        )
                        .padding(.bottom, 5)
                        .onTapGesture {
                            self.moveToSwipeTab(
                                categoryIdx: index,
                                subCategoryName: item.sub_category,
                                mainCategoryName: categoryData.main_category
                            )
                            
                        }
                        
                    }
                }
//                .background(
//                    Image("home_bg_01")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .overlay(Color.primaryDefault.opacity(0.8))
//                )
            }
        }
        .padding(15)
        //.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
        .background(Color.gray25)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        //.shadow(color: .gray300, radius: 2, x: 2, y: 2)
        //.overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.primaryDefault, lineWidth: 0.5))
//        .background(
//            RoundedRectangle(cornerRadius: 7)
//                .fill(Color.gray25)
//                .shadow(color: .gray300, radius: 2, x: 2, y: 2)
//        )
//        .onTapGesture {
//            self.moveToSwipeTab(categoryIdx: itemIndex)
//        }
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
//    TabHomeMyProgressView()
//}
