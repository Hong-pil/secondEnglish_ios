//
//  EditorInputView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/14/24.
//

import SwiftUI
import ComposableArchitecture

struct EditorInputView {
    var store: StoreOf<EditorPageFeature>
    @Binding var activeKoreanTxt: String
    @Binding var activeEnglishTxt: String
    var inactiveKoreanTxt: String
    var inactiveEnglishTxt: String
    @Binding var activeCardIndex: Int
    var cardIndex: Int
    var forceKeyboardUpIndex: Int
    var isCardAdd: Bool
}

extension EditorInputView: View {
    
    var body: some View {
        
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                // 한글 문장
                Group {
                    EditorInputRowView(
                        store: store,
                        activeTxt: $activeKoreanTxt,
                        activeCardIndex: $activeCardIndex,
                        inactiveTxt: inactiveKoreanTxt,
                        cardIndex: cardIndex,
                        isSameCard: (activeCardIndex == cardIndex) ? true : false,
                        forceKeyboardUpIndex: forceKeyboardUpIndex,
                        isKorean: true,
                        isOtherCardClick: { beforeIndex, afterIndex in
                            updateList(beforeIndex: beforeIndex, afterIndex: afterIndex)
                        }
                    )
                
                    Rectangle()
                        .fill(cardIndex==activeCardIndex ? Color.primaryDefault : Color.gray300)
                        .frame(height: (cardIndex==activeCardIndex) ? 2 : 1)
                    
                    Text("se_korean".localized)
                        .font(.caption21116Regular)
                        .foregroundColor(.gray400)
                }
                
                // 영어 문장
                Group {
                    EditorInputRowView(
                        store: store,
                        activeTxt: $activeEnglishTxt,
                        activeCardIndex: $activeCardIndex,
                        inactiveTxt: inactiveEnglishTxt,
                        cardIndex: cardIndex,
                        isSameCard: (activeCardIndex == cardIndex) ? true : false,
                        forceKeyboardUpIndex: forceKeyboardUpIndex,
                        isOtherCardClick: { beforeIndex, afterIndex in
                            updateList(beforeIndex: beforeIndex, afterIndex: afterIndex)
                        }
                    )
                    .padding(.top, 5)
                    
                    Rectangle()
                        .fill(cardIndex==activeCardIndex ? Color.primaryDefault : Color.gray300)
                        .frame(height: (cardIndex==activeCardIndex) ? 2 : 1)
                    
                    Text("se_english".localized)
                        .font(.caption21116Regular)
                        .foregroundColor(.gray400)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위해 사이즈 설정
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 3) // .clipShape 하지 않으면, 안쪽 뷰 요소들에도 그림자가 적용됨
            
        }
        //.frame(height: 60) // Adjust based on your content
        //.background(Color.gray.opacity(0.2)) // Background of the swipeable area
    }
    
    private func updateList(
        beforeIndex: Int,   // 입력 중이던 인덱스
        afterIndex: Int     // 새로 클릭한 곳의 인덱스
    ) {
        store.send(.updateList(
            beforeIndex: beforeIndex,
            afterIndex: afterIndex)
        )
    }
    
}

struct EditorInputRowView: View {
    @FocusState private var isTextFieldIsFocused: Bool
    var store: StoreOf<EditorPageFeature>
    @Binding var activeTxt: String
    @Binding var activeCardIndex: Int
    var inactiveTxt: String
    var cardIndex: Int
    var isSameCard: Bool
    var forceKeyboardUpIndex: Int
    var isKorean: Bool?
    var isOtherCardClick: (Int, Int) -> Void
    
    var body: some View {
        TextField("", text:
                    isSameCard ?
                        $activeTxt :
                        (
                            isTextFieldIsFocused ?
                                $activeTxt :
                                .constant(inactiveTxt)
                        )
        )
        .font(.body11622Regular)
        .foregroundColor(.gray900)
        .padding(.vertical, 5).background(Color.gray25) // TextField 클릭 감도 높임
        .task {
            if forceKeyboardUpIndex == cardIndex {
                
                /// 딜레이 주는 게 중요함
                /// 딜레이 주지 않으면 추가된 TextField 뷰에서 이전 글자가 잠깐 보였다가 없어짐
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    activeTxt = ""
                    
                    if let _ = isKorean {
                        // 이 TextField에서 키보드 강제로 올리기
                        self.isTextFieldIsFocused = true
                    }
                }
            }
        }
        .onTapGesture {
            store.isCardAdd = false
        }
        /// 활성화된 TextField 감지
        .focused($isTextFieldIsFocused)
        .onChange(of: isTextFieldIsFocused) {
            if isTextFieldIsFocused {
                /// 다른 카드의 TextField가 활성화됨
                if activeCardIndex != cardIndex {
                    
                    /// 수정하기 위해, 다른 카드의 TextField 클릭한 경우
                    /// 중요! TextField의 .onTapGesture 가 먼저 호출되기 때문에 아래 조건문에서 !store.isCardAdd 를 할 수 있는 것.
                    if !store.isCardAdd {
                        /// At This Point
                        /// before index : activeCardIndex
                        /// after index : cardIndex
                        isOtherCardClick(activeCardIndex, cardIndex)
                    }
                    
                    activeCardIndex = cardIndex
                }
            }
        }
    }
}

#Preview {
    EditorInputView(
        store: Store(initialState: EditorPageFeature.State()) {
            EditorPageFeature()
        },
        activeKoreanTxt: .constant(""),
        activeEnglishTxt: .constant(""),
        inactiveKoreanTxt: "",
        inactiveEnglishTxt: "",
        activeCardIndex: .constant(0),
        cardIndex: 0,
        forceKeyboardUpIndex: 0,
        isCardAdd: false
    )
}
