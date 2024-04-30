//
//  MenuSubPageCellFlipLikeView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/29/24.
//

import SwiftUI

struct MenuSubPageCellFlipLikeView: View {
    let item: SwipeDataList
    let isDisabledLikeButton: Bool
    @State var isFlipped: Bool = false
    var isLikeCancel: (() -> Void) = {}
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Group {
                    // Decide which view to show based on the flip state
                    if isFlipped {
                        // Back View Content
                        MenuSubPageCellFlipLike(
                            sentence: item.english ?? "",
                            likeCount: item.like_count ?? 0,
                            isFlipped: isFlipped,
                            isDisabledLikeButton: isDisabledLikeButton
                        )
                        // Correct the orientation of the content
                        .rotation3DEffect(.degrees(180), axis: (x: 1.0, y: 0.0, z: 0.0)) // x:1.0 => 위-아래로 뒤짚힘 / y:1.0 => 좌-우로 뒤짚힘
                            
                    } else {
                        // Front View Content
                        MenuSubPageCellFlipLike(
                            sentence: item.korean ?? "",
                            likeCount: item.like_count ?? 0,
                            isFlipped: isFlipped,
                            isDisabledLikeButton: isDisabledLikeButton,
                            isLikeCancel: {
                                isLikeCancel()
                            }
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
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

//#Preview {
//    MenuSubPageCellFlipLikeView()
//}

struct MenuSubPageCellFlipLike: View {
    let sentence: String
    let likeCount: Int
    let isFlipped: Bool
    let isDisabledLikeButton: Bool
    var isLikeCancel: (() -> Void) = {}
    
    var body: some View {
        VStack(spacing: 30) {
            Text(sentence)
                .font(.title5Roboto1622Medium)
                .foregroundColor(.black)
                .padding(.top, 20)
                .frame(maxWidth: DefineSize.Screen.Width / 1.3, alignment: .leading) // '북마크 순위' 이미지와 안 겹치게 하려고 사이즈 설정함.
                //.background(Color.yellow.opacity(0.3))
            
            HStack(spacing: 5) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pinkDefaultColor)
                
                Text(String(likeCount))
                    .font(.body21420Regular)
                    .foregroundColor(.gray850)
                    .padding(.bottom, 2) // 글자가 조금 올라가야 하트 아이콘 중간 위치로 보임
            }
            .onTapGesture {
                if !isDisabledLikeButton {
                    isLikeCancel()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 5)
            .padding(.trailing, 20)
            .opacity(!isFlipped ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위해 사이즈 설정
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
        .background(Color.gray25)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0) // .clipShape 하지 않으면, 안쪽 뷰 요소들에도 그림자가 적용됨
    }
}
