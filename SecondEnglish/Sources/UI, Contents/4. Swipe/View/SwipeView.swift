//
//  SwipeView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI

struct SwipeView: View {
    //let profile: Profile
    let card: SwipeDataList
    let onRemove: (LikeType) -> Void
    let isTapLikeBtn: (Int, Bool) -> Void
    @State private var offset = CGSize.zero
    
    // 값이 커지면 커질수록 카드가 사라질 때까지의 시간이 길어짐
    let cardOpacityRange: Double = 100
    
    @State var isFlipped: Bool = false
    @State var isDisabled: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .center) {
            
            FlipView(
                ProfileInfoView(card: card, isTapLikeBtn: isTapLikeBtn),
                ProfileInfoView_backView(card: card),
                tap: {
                    let _ = print("탭 쳣음 !!!!!!!!")
                },
                flipped: $isFlipped,
                disabled: $isDisabled
            )
            
            // Stamps for like/dislike/superlike that fade in as you swipe
            Group {
                StampView(label: "외웠음 O.O", color: .green)
                    .rotationEffect(.degrees(-15))
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .opacity(Double(offset.width / 50))

                StampView(label: "외울것 ㅠ.ㅠ", color: .red)
                    .rotationEffect(.degrees(15))
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .opacity(abs(min(Double(offset.width / 50), 0)))

                StampView(label: "Key card", color: .blue)
                    .rotationEffect(.degrees(-15))
                    .padding(.bottom, 80)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .opacity(abs(min(Double(offset.height / 100), 0)))
            }
        }
//        .background(
//          LinearGradient(colors: [.gray, .mint], startPoint: .top, endPoint: .bottom)
//        )
//        .cornerRadius(8)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 2, y: offset.height)
        .opacity(2 - Double(abs(offset.width / cardOpacityRange)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    if offset.width > 100 {
                        fLog("idpil::: 오른쪽")
                        onRemove(.like)
                    } else if offset.width < -100 {
                        fLog("idpil::: 왼쪽")
                        onRemove(.dislike)
                    } else if offset.height < -100 {
                        fLog("idpil::: 위쪽")
                        //onRemove(.superlike)
                        withAnimation(.spring()) {
                            offset = .zero
                            
                            isTapLikeBtn(card.idx ?? 0, true)
                        }
                    } else if offset.height > 100 {
                        fLog("idpil::: 아래쪽")
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
        )
    }
}
