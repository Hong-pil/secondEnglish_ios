//
//  TabHomeMyLearningView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/13/24.
//

import SwiftUI

struct TabHomeMyLearningView: View {
    let category: String
    let categorySetenceCount: Int
    let likeNumber: Int
    let itemIndex: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Text(category)
            
            Spacer()
            
            Text(String(categorySetenceCount))
            Text(" / ")
            Text(String(likeNumber))
        }
        .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
        .clipShape(RoundedRectangle(cornerRadius: 7))
        //.overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.primaryDefault, lineWidth: 0.5))
        .background(
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.gray25)
                .shadow(color: .gray300, radius: 2, x: 2, y: 2)
        )
        .onTapGesture {
            self.moveToSwipeTab(categoryIdx: itemIndex)
        }
    }
    
    private func moveToSwipeTab(categoryIdx: Int) {
        // Swipe Tab 으로 이동
        LandingManager.shared.showSwipePage = true
        
        //NotificationCenter.default.post(name: Notification.Name("workCompleted"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(name: Notification.Name(DefineNotification.moveToSwipeTab),
                                            object: nil,
                                            userInfo: [DefineKey.swipeViewCategoryIdx : categoryIdx] as [String : Any])
        }
    }
}

//#Preview {
//    TabHomeMyLearningView()
//}
