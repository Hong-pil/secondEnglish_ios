//
//  SwipeCardBackView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation
import NaturalLanguage

struct SwipeCardBackView: View {
    let card: SwipeDataList
    
    // TTS
    @State var ttsText: String = ""
    @State var isTtsBtnClick: Bool = false
    let languageRecognizer = NLLanguageRecognizer() // 언어 감지 (아웃풋 : en, ko, ..)
    var speechSynthesizer: AVSpeechSynthesizer // TTS
    

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.pink)
                    
                    Text(card.english ?? "Empty")
                        .multilineTextAlignment(.leading)
                        .font(.title32028Bold)
                        .foregroundColor(.gray850)
                }
                
                Spacer()
                
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
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
        }
        .onChange(of: isTtsBtnClick) {
            languageRecognizer.processString(ttsText)
            
            if let dominantLanguage = languageRecognizer.dominantLanguage {
                fLog("로그::: 감지된 언어 : \(dominantLanguage.rawValue)")
                
                
                let utterance = AVSpeechUtterance(string: ttsText)
                utterance.pitchMultiplier = 1.0 // 목소리의 높낮이
                utterance.rate = 0.5 // 읽는 속도
                //utterance.volume = 1.0 // 음성 볼륨
                //utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.voice = AVSpeechSynthesisVoice(language: dominantLanguage.rawValue)
                 
                speechSynthesizer.speak(utterance)
            }
        }
        .onDisappear {
            //fLog("onDisappear 호출 !!!!!!!!!!!!!!!!")
            // 아래 코드 적용 안 됨
            //speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}
