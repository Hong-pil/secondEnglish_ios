//
//  FlipView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation

struct FlipView {
    let item: SwipeDataList
    
    /**
     * RootView에서 isRootViewFlipped을 컨트롤 하려면, @State으로 선언하면 안 됨.
     */
    //@State var isRootViewFlipped: Bool = false
    var isRootViewFlipped: Bool = false // TabSwipeCardPage에서 flip animation 주기
    @State var isChildTapFlipped: Bool = false // FlipView에서 flip animation 주기
    @Binding var isCardFlipped: Bool
    
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    let isLastCard: Bool // 맨 위에 보이는 카드만 클릭해서 카드 뒤집을 수 있음
}

extension FlipView: View {
    var body: some View {
        ZStack {
            // Decide which view to show based on the flip state
            // FlipView 또는 TabSwipeCardPage에서 flip animation 준다.
            if isRootViewFlipped || isChildTapFlipped {
                // Back View Content
                SwipeCardBackView(card: item, isCardFlipped: $isCardFlipped)
                // Correct the orientation of the content
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
            } else {
                // Front View Content
                SwipeCardFrontView(
                    card: item,
                    hintTxt: item.english?.split(separator: " ").map(String.init) ?? [], // 문장을 단어로 분할하여 저장
                    isTapLikeBtn: isTapLikeBtn,
                    isTapMoreBtn: isTapMoreBtn,
                    isCardFlipped: $isCardFlipped
                )
            }
        }
        // FlipView에서 flip animation 주기
        .rotation3DEffect(
            .degrees(
                isChildTapFlipped
                ?
                180
                :
                0
            ),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        // TabSwipeCardPage에서 flip animation 주기
        .rotation3DEffect(
            .degrees(
                isLastCard
                ?
                (
                    isRootViewFlipped
                    ?
                    180
                    :
                    0
                )
                :
                0
            ),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        // FlipView에서 flip animation 주기
        .onTapGesture {
            if isLastCard {
                withAnimation(.easeIn(duration: 0.2)) {
                    isChildTapFlipped.toggle()
                }
            }
        }
    }
}
