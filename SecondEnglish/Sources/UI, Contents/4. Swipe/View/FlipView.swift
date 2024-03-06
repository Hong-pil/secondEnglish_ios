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
    @State var isFlipped: Bool = false
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    var speechSynthesizer: AVSpeechSynthesizer // TTS
    let isLastCard: Bool // 맨 위에 보이는 카드만 클릭해서 카드 뒤집을 수 있음
}

extension FlipView: View {
    var body: some View {
        ZStack {
            // Decide which view to show based on the flip state
            if isFlipped {
                // Back View Content
                SwipeCardBackView(card: item, speechSynthesizer: speechSynthesizer)
                // Correct the orientation of the content
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
            } else {
                // Front View Content
                SwipeCardFrontView(
                    card: item,
                    hintTxt: item.english?.split(separator: " ").map(String.init) ?? [], // 문장을 단어로 분할하여 저장
                    isTapLikeBtn: isTapLikeBtn,
                    isTapMoreBtn: isTapMoreBtn
                )
            }
        }
        // Apply flip animation to the container
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
        .onTapGesture {
            if isLastCard {
                withAnimation {
                    isFlipped.toggle()
                }
            }
        }
    }
}
