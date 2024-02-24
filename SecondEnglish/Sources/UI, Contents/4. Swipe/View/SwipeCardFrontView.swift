//
//  SwipeCardFrontView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation
import NaturalLanguage

struct SwipeCardFrontView: View {
    let card: SwipeDataList
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    @State var isShowHint: Bool = false
    
    // TTS
    //@State var ttsText: String = ""
    //@State var isTtsBtnClick: Bool = false
    //let languageRecognizer = NLLanguageRecognizer() // 언어 감지 (아웃풋 : en, ko, ..)
    //let speechSynthesizer = AVSpeechSynthesizer() // TTS

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                
                HStack(spacing: 0) {
                    Text("made by \(card.user_name ?? "")")
                        .font(.caption21116Regular)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Button(action: {
                        isTapMoreBtn()
                    }, label: {
                        Image("icon_more_dark")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5).background(Color.gray25.opacity(0.3)) // 클릭 범위 확장
                    })
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    HStack(spacing: 5) {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                        
                        Text(card.korean ?? "Empty")
                            .multilineTextAlignment(.leading)
                            .font(.title32028Bold)
                            .foregroundColor(.gray850)
                    }
                    
                    Text("힌트기능 ! 단어 하나씩 보여주기 :)")
                        .opacity(isShowHint ? 1 : 0)
                }
                
                
                Spacer()
                
                HStack(spacing: 20) {
                    Image(systemName: (card.isLike ?? false) ? "bookmark.fill" : "bookmark")
                        .renderingMode(.template)
                        .foregroundColor(.gray850)
                        .padding(10) // 클릭 범위 확장
                        .background(Color.gray25) // 클릭 범위 확장
                        .onTapGesture {
                            // 좋아요 취소 요청 -> false
                            // 좋아요 요청 -> true
                            isTapLikeBtn(card.idx ?? 0, (card.isLike ?? false) ? false : true)
                        }
                    
                    Image(systemName: "figure.highintensity.intervaltraining")
                        .foregroundColor(.gray850)
                        .padding(10) // 클릭 범위 확장
                        .background(Color.gray25) // 클릭 범위 확장
                        .onTapGesture {
                            isShowHint.toggle()
                        }
                    
//                    Image(systemName: "speaker.wave.2")
//                        .foregroundColor(.gray850)
//                        .padding(10) // 클릭 범위 확장
//                        .background(Color.gray25) // 클릭 범위 확장
//                        .onTapGesture {
//                            isTtsBtnClick.toggle()
//                            ttsText = card.korean ?? ""
//                        }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                    
            }
            .padding()
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .leading)
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green))
        }
//        .onChange(of: isTtsBtnClick) {
//            languageRecognizer.processString(ttsText)
//            
//            if let dominantLanguage = languageRecognizer.dominantLanguage {
//                fLog("로그::: 감지된 언어 : \(dominantLanguage.rawValue)")
//                
//                
//                let utterance = AVSpeechUtterance(string: ttsText)
//                utterance.pitchMultiplier = 1.0 // 목소리의 높낮이
//                utterance.rate = 0.5 // 읽는 속도
//                //utterance.volume = 1.0 // 음성 볼륨
//                //utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                utterance.voice = AVSpeechSynthesisVoice(language: dominantLanguage.rawValue)
//                 
//                speechSynthesizer.speak(utterance)
//            }
//        }
        .onDisappear {
            //fLog("onDisappear 호출 !!!!!!!!!!!!!!!!")
            // 아래 코드 적용 안 됨
            //speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}
