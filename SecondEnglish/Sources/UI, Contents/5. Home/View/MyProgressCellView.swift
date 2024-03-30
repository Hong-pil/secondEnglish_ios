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
    var today_new_count: Int
    var category_sentence_count: Int
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text(sub_category)
                    .font(.buttons1420Medium)
                    .foregroundColor(.gray700)
                    .frame(width: DefineSize.Screen.Width/2, alignment: .leading)
                    
                Spacer()
                
                Text((String(like_number)))
                    .font(.buttons1420Medium)
                    .fontWeight(like_number==0 ? .medium : .heavy)
                    .foregroundColor(like_number==0 ? .gray700 : .primaryDefault)
                
                Text(" / \(String(category_sentence_count))")
                    .font(.buttons1420Medium)
                    .foregroundColor(.gray700)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit).frame(height: 10) //.aspectRatio().frame() 순서이여야, 높이 기준으로 비율을 유지할 수 있음.
                    .foregroundColor(.gray300)
                    .padding(.leading, 20)
                    .padding(.top, 2)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .onTapGesture {
                self.moveToSwipeTab(
                    subCategoryIdx: sub_category_index,
                    subCategoryName: sub_category,
                    mainCategoryName: main_category
                )
                
            }
            
            /**
             * [오늘 추가된 문장 개수 알림]
             * '서브 카테고리' 글자 끝에서 조금 위에 위치하기 위해 '보이지 않는 Text()' 사용
             */
            if today_new_count > 0 {
                Text(sub_category)
                    .font(.buttons1420Medium)
                    .foregroundColor(.gray700)
                    .opacity(0)
                    .padding(.leading, 20)
                    .padding(.trailing, 17)
                    .background(
                        Text(String(today_new_count))
                            .font(.caption31013Regular)
                            .fontWeight(.bold)
                            .foregroundColor(.gray25)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 7, trailing: 5)) // bottom 값이 더 커야 숫자가 중앙에 위치하는 거 같음.
                            .background(Circle().fill(Color.red.opacity(0.8)))
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .topTrailing)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    
    private func moveToSwipeTab(subCategoryIdx: Int, subCategoryName: String, mainCategoryName: String) {
        let dataDic: [String: Any] = ["subCategoryIdx": subCategoryIdx, "subCategoryName" : subCategoryName, "mainCategoryName": mainCategoryName]
        
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
