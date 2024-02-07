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
    var speechSynthesizer: AVSpeechSynthesizer // TTS
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
                SwipeCardFrontView(card: item, isTapLikeBtn: isTapLikeBtn)
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
