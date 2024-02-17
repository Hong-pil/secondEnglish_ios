//
//  EditorInputView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/17/24.
//

import SwiftUI

struct EditorInputView: View {
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
    
    var body: some View {
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
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 1.0))
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray25))
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
            if currentTxt.isEmpty && arrayItemTxt.isEmpty {
                TextField(placeholder, text: .constant(""))
                    .font(.body11622Regular)
                    .foregroundColor(.gray400)
                    .padding(.vertical, 11)
                    .disabled(true) // 보기용 (동작 안 함)
            }
            
            // 백업 (동일한 카드, 예외 처리 필요한 상태)
//            TextField("", text:
//                        isTextFieldIsFocused ?
//                      $currentTxt :
//                    .constant(arrayItemTxt)
//            )
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
            .opacity(currentTxt.isEmpty ? 0.25 : 1)
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
