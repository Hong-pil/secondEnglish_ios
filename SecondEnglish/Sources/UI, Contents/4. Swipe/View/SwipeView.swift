//
//  SwipeView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI
import AVFoundation

struct SwipeView: View {
    //let profile: Profile
    let card: SwipeDataList
    let onRemove: (LikeType) -> Void
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    let isLastCard: Bool // 맨 위에 보이는 카드만 Drag Gesture 가능
    let isTapFrontSpeakBtn: () -> Void
    let isTapBackSpeakBtn: () -> Void
    let isTapCard: () -> Void
    let isFrontSpeaking: Bool
    let isBackSpeaking: Bool
    let isAutoPlay: Bool
    
    //@State var isFlipped: Bool = false
    @Binding var isRootViewFlipped: Bool
    @State private var offset = CGSize.zero
    
    // 값이 커지면 커질수록 카드가 사라질 때까지의 시간이 길어짐
    let cardOpacityRange: Double = 100
    
    var body: some View {
        ZStack(alignment: .center) {
            
            FlipView(
                item: card,
                isRootViewFlipped: $isRootViewFlipped,
                isTapLikeBtn: isTapLikeBtn,
                isTapMoreBtn: isTapMoreBtn,
                isLastCard: isLastCard,
                isTapFrontSpeakBtn: isTapFrontSpeakBtn,
                isTapBackSpeakBtn: isTapBackSpeakBtn,
                isTapCard: isTapCard,
                isFrontSpeaking: isFrontSpeaking,
                isBackSpeaking: isBackSpeaking,
                isAutoPlay: isAutoPlay
            )
            
            // Stamps for like/dislike/superlike that fade in as you swipe
//            Group {
//                StampView(label: "외웠음 O.O", color: .green)
//                    .rotationEffect(.degrees(-15))
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                    .opacity(Double(offset.width / 50))
//
//                StampView(label: "외울것 ㅠ.ㅠ", color: .red)
//                    .rotationEffect(.degrees(15))
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                    .opacity(abs(min(Double(offset.width / 50), 0)))
//
//                StampView(label: "Key card", color: .blue)
//                    .rotationEffect(.degrees(-15))
//                    .padding(.bottom, 80)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//                    .opacity(abs(min(Double(offset.height / 100), 0)))
//            }
        }
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 2, y: offset.height)
        .opacity(2 - Double(abs(offset.width / cardOpacityRange)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if isLastCard {
                        offset = gesture.translation
                    }
                }
                .onEnded { gesture in
                    if isLastCard {
                        if offset.width > 100 {
                            //fLog("idpil::: 오른쪽")
                            onRemove(.like)
                        } else if offset.width < -100 {
                            //fLog("idpil::: 왼쪽")
                            onRemove(.dislike)
                        } else if offset.height < -100 {
                            //fLog("idpil::: 위쪽")
                            //onRemove(.superlike)
                            withAnimation(.spring()) {
                                offset = .zero
                                
                                isTapLikeBtn(card.idx ?? 0, true)
                            }
                        } else if offset.height > 100 {
                            //fLog("idpil::: 아래쪽")
                            withAnimation(.spring()) {
                                offset = .zero
                                
                                isTapLikeBtn(card.idx ?? 0, false)
                            }
                        }
                        else {
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                    }
                }
        )
    }
    
}
