//
//  SwipeCardFrontView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation
import NaturalLanguage

/**
 * Hint 기능, ChatGTP 한테 물어봐서 해결했음.
 * 1. swiftui에서 버튼을 클릭할 때마다 Text()에서 어떤 문장에서 단어를 하나씩 보여주는 기능을 알려줘.
 * 2. swiftui에서 Text()에서 처음에는 보이지 않다가, 버튼을 클릭할 때마다  어떤 문장에서 단어를 하나씩 더해서 보여주는 기능을 알려줘.
 * 3. swiftui에서 [String] 타입의 Text를 보여줄 때, 단어 길이만큼 밑줄을 표시하는 기능을 알려줘.
 */
struct SwipeCardFrontView: View {
    let card: SwipeDataList
    var hintTxt: [String]
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    
    @State private var currentHintWordIndex = -1
    
    // TTS
    //@State var ttsText: String = ""
    //@State var isTtsBtnClick: Bool = false
    //let languageRecognizer = NLLanguageRecognizer() // 언어 감지 (아웃풋 : en, ko, ..)
    //let speechSynthesizer = AVSpeechSynthesizer() // TTS

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
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
                
                VStack(spacing: 20) {
                    Text(card.korean ?? "Empty")
                        .multilineTextAlignment(.leading)
                        .font(.title32028Bold)
                        .foregroundColor(.gray850)
                    
                    HStack(spacing: 0) {
                        ForEach(Array(hintTxt.enumerated()), id: \.offset) { index, word in
                            
                            HStack {
                                
                                if currentHintWordIndex < index {
                                    Text(word)
                                        .foregroundColor(.clear) // 실제 글자는 보이지 않게 설정
                                        //.underline(true, color: .black)
                                        .background(Rectangle().foregroundColor(Color.gray500)) // 밑줄 색상 설정
                                } else {
                                    Text(word)
                                }
                                
                                if index < hintTxt.count-1 {
                                    Text(" ")
                                }
                                // 밑줄을 글자 길이만큼 표시
//                                Text(String(repeating: "_", count: word.count))
//                                    .foregroundColor(.clear) // 실제 글자는 보이지 않게 설정
                                    //.background(Rectangle().foregroundColor(.black)) // 밑줄 색상 설정
                            }
                        }
                    }
                    .opacity((currentHintWordIndex > -1) ? 1 : 0)
                    
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
                            
//                            fLog("currentHintWordIndex : \(currentHintWordIndex)")
//                            fLog("hintTxt.count : \(hintTxt.count)")
//                            fLog((currentHintWordIndex > -1) ? hintTxt[currentHintWordIndex] : "")
                            
                            if currentHintWordIndex < hintTxt.count-1 {
                                currentHintWordIndex = (currentHintWordIndex + 1) % hintTxt.count
                            }
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
