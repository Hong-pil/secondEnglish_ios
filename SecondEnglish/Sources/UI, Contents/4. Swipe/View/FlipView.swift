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
    @Binding var isRootViewFlipped: Bool // TabSwipeCardPage에서 flip animation 주기
    
    let isTapLikeBtn: (Int, Bool) -> Void
    let isTapMoreBtn: () -> Void
    let isLastCard: Bool // 맨 위에 보이는 카드만 클릭해서 카드 뒤집을 수 있음
    let isTapFrontSpeakBtn: () -> Void
    let isTapBackSpeakBtn: () -> Void
    let isTapCard: () -> Void
    let isFrontSpeaking: Bool
    let isBackSpeaking: Bool
    let isAutoPlay: Bool
}

extension FlipView: View {
    var body: some View {
        ZStack {
            // Decide which view to show based on the flip state
            if isRootViewFlipped {
                // Back View Content
                SwipeCardBackView(
                    card: item,
                    isTapSpeakBtn: isTapBackSpeakBtn,
                    isSpeaking: isBackSpeaking,
                    isLastCard: isLastCard
                )
                // Correct the orientation of the content
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
            } else {
                // Front View Content
                SwipeCardFrontView(
                    card: item,
                    hintTxt: item.english?.split(separator: " ").map(String.init) ?? [], // 문장을 단어로 분할하여 저장
                    isTapLikeBtn: isTapLikeBtn,
                    isTapMoreBtn: isTapMoreBtn,
                    isTapSpeakBtn: isTapFrontSpeakBtn,
                    isSpeaking: isFrontSpeaking,
                    isAutoPlay: isAutoPlay,
                    isLastCard: isLastCard
                )
            }
        }
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
        .onTapGesture {
            isTapCard()
        }
//        // FlipView에서 flip animation 주기
//        .onTapGesture {
//            if isAutoPlay {
//                UserManager.shared.showCardAutoModeError = true
//            }
//            else {
//                if isLastCard {
//                    /// 자동모드 종료시,
//                    /// '한글 카드'인 상태 -> isRootViewFlipped == false
//                    /// '영어 카드'인 상태 -> isRootViewFlipped == true
//                    ///
//                    /// 자동모드 종료시 '한글 카드'인 상태에서 탭 하는 건, "기존 탭 순서(한글 -> 영어)와 같기 때문에 문제가 없지만
//                    /// '영어 카드'인 상태에서 탭 하는 건 "기존 탭 순서"와 다르기 때문에 문제가 된다.
//                    ///
//                    /// 문제가 되는 이유는
//                    /// 탭 할 때마다 'isChildTapFlipped.toggle()'로 .rotation3DEffect(.degrees())를 조절하기 때문.
//                    ///
//                    /// 그래서 변수(isForceFlipped)를 하나 생성해서 분기를 나눠줬음.
//                    ///
//                    fLog("idpil::: isRootViewFlipped : \(isRootViewFlipped)")
//                    fLog("idpil::: isChildTapFlipped : \(isChildTapFlipped)")
//                    if isRootViewFlipped {
//                        withAnimation(.easeIn(duration: 0.2)) {
//                            isForceFlipped = true
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            isRootViewFlipped = false
//                            isChildTapFlipped = false
//                        }
//                    }
//                    else {
//                        isForceFlipped = false
//                        withAnimation(.easeIn(duration: 0.2)) {
//                            isChildTapFlipped.toggle()
//                        }
//                    }
//                    
//                    
//                    withAnimation(.easeIn(duration: 0.2)) {
//                        isChildTapFlipped.toggle()
//                    }
//                }
//            }
//        }
    }
}
