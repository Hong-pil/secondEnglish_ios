//
//  EditorInputView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/17/24.
//

import SwiftUI

/**
 * ChatGPT4 미쳤음..
 * "how to swipe scrollview item from right to left show delete button using DragGesture() in swiftui?"
 * 라고 질문했더니 바로 만들어줌.. 밥그릇 간수 잘 해야됨..
 */
struct EditorInputView {
    @Binding var currentKoreanTxt: String
    @Binding var currentEnglishTxt: String
    var cardIndex: Int // 데이터 배열 인덱스
    var activeCardIndex: Int // 키보드가 올라가 있는 카드 인덱스
    var arrayItemKoreanTxt: String
    var arrayItemEnglishTxt: String
    var korean_placeholder: String = "se_j_write_korean".localized
    var english_placeholder: String = "se_j_write_english".localized
    var korean_maxlength: Int
    var english_maxlength: Int
    var isShowTxtLengthToast: ((Bool) -> Void)
    var isKeyboardFocused: ((Bool) -> Void)
    var forceKeyboardUpIndex: Int
    var isItemDelete: ((Bool, Int) -> Void)
    
    
    // [카드뷰 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위한 기능]
    // Tracks the offset of the swipe gesture
    @State private var swipeLeftOffset = CGSize.zero
    // Determines when to show the delete button
    @State private var isShowingDeleteButton = false
    private struct sizeInfo {
        static let swipeLeftOffsetSize: CGFloat = -50.0 // 왼쪽 Swipe시, 뷰 이동 거리
    }
}

extension EditorInputView: View {
    
    var body: some View {
        
        HStack(spacing: 20) {
            VStack(spacing: 0) {
                EditorInputRowView(
                    currentTxt: $currentKoreanTxt,
                    
                    
                    isSameCard: (cardIndex==activeCardIndex) ? true : false,
                    
                    arrayItemTxt: arrayItemKoreanTxt,
                    placeholder: korean_placeholder,
                    maxlength: korean_maxlength,
                    isShowToast: { isShow in
                        if isShow {
                            isShowTxtLengthToast(true)
                        }
                    },
                    isKeyboardFocused: { isFocused in
                        if isFocused {
                            isKeyboardFocused(isFocused)
                        }
                    },
                    forceKeyboardUpIndex: forceKeyboardUpIndex,
                    cardIndex: cardIndex,
                    isKorean: true
                )
             
                Divider()
                
                EditorInputRowView(
                    currentTxt: $currentEnglishTxt,
                    
                    isSameCard: (cardIndex==activeCardIndex) ? true : false,
                    
                    arrayItemTxt: arrayItemEnglishTxt,
                    placeholder: english_placeholder,
                    maxlength: english_maxlength,
                    isShowToast: { isShow in
                        if isShow {
                            isShowTxtLengthToast(true)
                        }
                    },
                    isKeyboardFocused: { isFocused in
                        if isFocused {
                            isKeyboardFocused(isFocused)
                        }
                    },
                    forceKeyboardUpIndex: forceKeyboardUpIndex,
                    cardIndex: cardIndex
                )
                
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽으로 Swipe 시, 삭제 버튼 보이기 위해 사이즈 설정
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 1.0))
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray25))
            
            
            // Delete button
            if isShowingDeleteButton {
                Button(action: {
                    // Action to perform on delete
                    
                    // 뷰 원래 자리로 이동 (삭제이기 때문에 withAnimation 효과 줄 필요 없음)
                    self.swipeLeftOffset = CGSize.zero
                    self.isShowingDeleteButton = false
                    
                    isItemDelete(true, cardIndex)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
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
        .offset(x: swipeLeftOffset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Only allow dragging to the left
                    if gesture.translation.width < 0 {
                        self.swipeLeftOffset = gesture.translation
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.width < sizeInfo.swipeLeftOffsetSize {
                        // Threshold to show delete button
                        withAnimation {
                            self.swipeLeftOffset.width = sizeInfo.swipeLeftOffsetSize // Adjust based on your delete button's width
                            self.isShowingDeleteButton = true
                        }
                    } else {
                        withAnimation {
                            self.swipeLeftOffset = .zero
                            self.isShowingDeleteButton = false
                        }
                    }
                }
        )
        //.frame(height: 60) // Adjust based on your content
        //.background(Color.gray.opacity(0.2)) // Background of the swipeable area
    }
    
}

struct EditorInputRowView: View {
    @Binding var currentTxt: String
    
    /**
     * [개념 중요]
     * 카드 하나에, TextField 가 두 개이기 때문에 "동일한 카드 처리" 필요함
     * 동일한 카드이면 -> 키보드 입력 중인 데이터(@Binding 되는 변수) 사용
     * 동일한 카드 아니면 -> 이전에 입력했던 데이터(배열에 저장된 변수) 사용
     */
    var isSameCard: Bool
    
    var arrayItemTxt: String
    var placeholder: String
    var maxlength: Int
    var isShowToast: ((Bool) -> Void)
    @FocusState private var isTextFieldIsFocused: Bool
    var isKeyboardFocused: ((Bool) -> Void) // 키보드 활성 유무
    var forceKeyboardUpIndex: Int
    var cardIndex: Int // 데이터 배열 인덱스
    var isKorean: Bool?
    
    
    var body: some View {
        ZStack {
            
            //MARK: - 힌트 TextField, 입력 안 됨
            if currentTxt.isEmpty && arrayItemTxt.isEmpty {
                TextField(placeholder, text: .constant(""))
                    .font(.body11622Regular)
                    .foregroundColor(.gray400)
                    .padding(.vertical, 11)
                    .disabled(true) // 보기용 (동작 안 함)
            }
            
            
            
            //MARK: - 내용 TextField, 입력 가능
            // 백업 (동일한 카드, 예외 처리 필요한 상태)
//            TextField("", text:
//                        isTextFieldIsFocused ?
//                      $currentTxt :
//                    .constant(arrayItemTxt)
//            )
            //
            TextField("", text:
                        isSameCard ?
                            $currentTxt :
                            (
                                isTextFieldIsFocused ?
                                    $currentTxt :
                                    .constant(arrayItemTxt)
                            )
            )
            .font(.body11622Regular)
            .lineLimit(2)
            .foregroundColor(.gray900)
            .padding(.vertical, 11)
            //.opacity(currentTxt.isEmpty ? 0.2 : 1) // currentTxt 확인 테스트용
            .onChange(of: currentTxt) {
                if currentTxt.count > maxlength {
                    currentTxt = String(currentTxt.prefix(50))
                    isShowToast(true)
                }
            }
            .focused($isTextFieldIsFocused)
            .onChange(of: isTextFieldIsFocused) {
                isKeyboardFocused(isTextFieldIsFocused)
            }
            .onAppear {
                // "문장 추가하기 버튼" 클릭시,마지막 카드의 한국어 textfield 키보드 올림
                if forceKeyboardUpIndex == cardIndex {
                    if let _ = isKorean {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            // 이 TextField에서 키보드 강제로 올리기
                            self.isTextFieldIsFocused = true
                        }
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    EditorInputView()
//}
