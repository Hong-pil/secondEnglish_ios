//
//  MenuSubPageCellFlipPopularView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/23/24.
//

import SwiftUI

struct MenuSubPageCellFlipPopularView: View {
    let item: SwipeDataList
    @State var isFlipped: Bool = false
    
    // [카드뷰 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위한 기능]
    let isDoItemDelete: Bool
    @State private var swipeLeftOffset = CGSize.zero // Tracks the offset of the swipe gesture
    @State private var isShowingDeleteButton = false // Determines when to show the delete button
    private struct sizeInfo {
        static let swipeLeftOffsetSize: CGFloat = -50.0 // 왼쪽 Swipe시, 뷰 이동 거리
    }
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Group {
                    // Decide which view to show based on the flip state
                    if isFlipped {
                        // Back View Content
                        MenuSubPageCellFlipPopular(
                            sentence: item.english ?? "",
                            category: item.type3 ?? "",
                            isFlipped: isFlipped
                        )
                        // Correct the orientation of the content
                        .rotation3DEffect(.degrees(180), axis: (x: 1.0, y: 0.0, z: 0.0)) // x:1.0 => 위-아래로 뒤짚힘 / y:1.0 => 좌-우로 뒤짚힘
                            
                    } else {
                        // Front View Content
                        MenuSubPageCellFlipPopular(
                            sentence: item.korean ?? "",
                            category: item.type3 ?? "",
                            isFlipped: isFlipped
                        )
                    }
                }
            }
            // Apply flip animation to the container
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 1.0, y: 0.0, z: 0.0)) // x:1.0 => 위-아래로 뒤짚힘 / y:1.0 => 좌-우로 뒤짚힘
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    isFlipped.toggle()
                }
            }
            
            
            // Delete button
            if isShowingDeleteButton {
                Button(action: {
                    // Action to perform on delete
                    
                    // 뷰 원래 자리로 이동 (삭제이기 때문에 withAnimation 효과 줄 필요 없음)
                    self.swipeLeftOffset = CGSize.zero
                    self.isShowingDeleteButton = false
                    
                    //isItemDelete(true, cardIndex)
                }) {
                    Image(systemName: "return")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                //.padding(.leading, 20)
                /**
                 * .transition() 으로 뷰 Swipe시 애니메이션 효과준 건데,
                 * 일단 HStack spacing 으로 간격을 줬음.
                 * 그런데 애니메이션 효과를 줬다 보니까, 뷰 오른쪽으로 Swipe 됐을 때 '삭제버튼'이 미묘하게 잠시 남아 있는 문제가 있는 거 같은데, 일단 넘어감.
                 *
                 * 나중에 바꾸려면, HStack spacing 0으로 설정하고, .transition() 제거한 다음 위에 주석처리한 padding leading 값 살리면 됨.
                 *
                 * 참고) .transition() 공부하자. 유용한 거 같음.
                 */
                .transition(.move(edge: .trailing))
            }
        }
        //.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .offset(x: swipeLeftOffset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    
                    /**
                     * Drag되는 동안 카드가 움직이게 하는 기능인데, 주석처리한 이유 :
                     * 스크롤 하는 동안, 손 동작이 조금만 옆으로 움직여도 카드뷰가 움직이는 문제가 있음
                     */
                    // Only allow dragging to the left
//                    if gesture.translation.width < 0 {
//                        self.swipeLeftOffset = gesture.translation
//                    }
                }
                .onEnded { gesture in
                    if isDoItemDelete {
                        if gesture.translation.width < sizeInfo.swipeLeftOffsetSize {
                            // Threshold to show delete button
                            withAnimation {
                                self.swipeLeftOffset.width = sizeInfo.swipeLeftOffsetSize // Adjust based on your delete button's width
                                self.isShowingDeleteButton = true
                            }
                        } else {
                            withAnimation {
                                self.swipeLeftOffset = .zero
                            }
                            self.isShowingDeleteButton = false
                        }
                    }
                }
        )
    }
}

//#Preview {
//    MenuSubPageCellFlipPopularView()
//}

struct MenuSubPageCellFlipPopular: View {
    let sentence: String
    let category: String
    let isFlipped: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text(sentence)
                .font(.title5Roboto1622Medium)
                .foregroundColor(.black)
                .padding(.vertical, 20)
                .frame(maxWidth: DefineSize.Screen.Width / 1.3, alignment: .leading) // '북마크 순위' 이미지와 안 겹치게 하려고 사이즈 설정함.
                //.background(Color.yellow.opacity(0.3))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위해 사이즈 설정
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
        .background(Color.gray25)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0) // .clipShape 하지 않으면, 안쪽 뷰 요소들에도 그림자가 적용됨
    }
}
