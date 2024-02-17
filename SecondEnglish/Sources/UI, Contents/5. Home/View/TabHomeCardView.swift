//
//  TabHomeCardView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/5/24.
//

import SwiftUI

/**
 * ChatGPT4 에게 아래 질문으로 해결했음. 미쳤네.. 밥그릇 간수 잘 해야 할 듯..정신 똑바로 차리자!
 * "Please tell me how to create a flipped view with letters when I click on view in swiftui. However, the view should look straight when flipped."
 */
struct TabHomeCardView {
    let item: SwipeDataList
    let cardWidth: CGFloat
    @State var isFlipped: Bool = false
}

extension TabHomeCardView: View {
    var body: some View {
        ZStack {
            // Decide which view to show based on the flip state
            if isFlipped {
                // Back View Content
                TabHomeCardViewRow(
                    sentence: item.english ?? "",
                    category: item.type3 ?? "",
                    isStartPointCategory: item.isStartPointCategory ?? false,
                    isEndPointCategory: item.isEndPointCategory ?? false,
                    isFlipped: isFlipped,
                    cardWidth: cardWidth
                )
                // Correct the orientation of the content
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    
            } else {
                // Front View Content
                TabHomeCardViewRow(
                    sentence: item.korean ?? "",
                    category: item.type3 ?? "",
                    isStartPointCategory: item.isStartPointCategory ?? false,
                    isEndPointCategory: item.isEndPointCategory ?? false,
                    isFlipped: isFlipped,
                    cardWidth: cardWidth
                )
            }
        }
        // Apply flip animation to the container
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
        .onTapGesture {
            withAnimation {
                isFlipped.toggle()
            }
        }
    }
}

struct TabHomeCardViewRow: View {
    let sentence: String
    let category: String
    let isStartPointCategory: Bool
    let isEndPointCategory: Bool
    let isFlipped: Bool
    let cardWidth: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.primaryDefault, lineWidth: 0.5)
                
            VStack(spacing: 30) {
                Text(category)
                Text(sentence)
                Text(isStartPointCategory ? "시작 포인트임 :)" : "None :>")
                Text(isEndPointCategory ? "마지막 포인트임 :)" : "None")
            }
        }
        .frame(width: cardWidth, height: 150)
        //.fixedSize(horizontal: false, vertical: true)
    }
}

//#Preview {
//    TabHomeCardView()
//}
