//
//  SwipeCardBackView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation

struct SwipeCardBackView: View {
    //@StateObject private var speechManager = SpeechSynthesizerManager()
    
    let card: SwipeDataList
    let isTapSpeakBtn: () -> Void
    let isSpeaking: Bool
    let isLastCard: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                
                Text(card.english ?? "Empty")
                    .multilineTextAlignment(.leading)
                    .font(.title41824Medium)
                    .foregroundColor(.gray850)
                
                Spacer()
                
                Image(systemName: "speaker.wave.2.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    //.foregroundColor(speechManager.isSpeaking ? Color.primaryDefault : Color.stateDisabledGray200)
                    .foregroundColor(isSpeaking ? Color.primaryDefault : Color.stateDisabledGray200)
                    .padding(10) // 클릭 범위 확장
                    .background(Color.gray25) // 클릭 범위 확장
                    .onTapGesture {
//                        if !speechManager.isSpeaking {
//                            speechManager.speak(card.english ?? "")
//                        }
                        isTapSpeakBtn()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(isLastCard ? 1.0 : 0.0)
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .leading)
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.stateActivePrimaryDefault))
        }
    }
}
