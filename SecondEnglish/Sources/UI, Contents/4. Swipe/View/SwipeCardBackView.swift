//
//  SwipeCardBackView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation

struct SwipeCardBackView: View {
    @StateObject private var speechManager = SpeechSynthesizerManager()
    
    let card: SwipeDataList
    
    // TTS
    @State var ttsText: String = ""
    @State var isTtsBtnClick: Bool = false
    
    var speechSynthesizer: AVSpeechSynthesizer // TTS
    

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                
                Text(card.english ?? "Empty")
                    .multilineTextAlignment(.leading)
                    .font(.title41824Medium)
                    .foregroundColor(.gray850)
                
                Spacer()
                
                Text(speechManager.isSpeaking ? "Speaking..." : "Speak")
                
                Image(systemName: "speaker.wave.2")
                    .foregroundColor(.gray850)
                    .padding(10) // 클릭 범위 확장
                    .background(Color.gray25) // 클릭 범위 확장
                    .onTapGesture {
                        fLog("speark button clicked!")
                        isTtsBtnClick.toggle()
                        ttsText = card.english ?? ""
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .leading)
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.stateActivePrimaryDefault))
        }
        .onChange(of: isTtsBtnClick) {
            if !speechManager.isSpeaking {
                speechManager.speak(card.english ?? "")
            }
        }
        .onDisappear {
            //fLog("onDisappear 호출 !!!!!!!!!!!!!!!!")
            // 아래 코드 적용 안 됨
            //speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}
