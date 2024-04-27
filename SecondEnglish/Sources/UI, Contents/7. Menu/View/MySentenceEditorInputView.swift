//
//  MySentenceEditorInputView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/26/24.
//

import SwiftUI

struct MySentenceEditorInputView {
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
}

extension MySentenceEditorInputView: View {
    var body: some View {
        
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                
                // 한글 문장
                Group {
                    MySentenceEditorInputRowView(
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
                        cardIndex: cardIndex,
                        isKorean: true
                    )
                
                    Rectangle()
                        .fill(cardIndex==activeCardIndex ? Color.primaryDefault : Color.gray300)
                        .frame(height: (cardIndex==activeCardIndex) ? 2 : 1)
                    
                    Text("한글")
                        .font(.caption21116Regular)
                        .foregroundColor(.gray400)
                }
                
                // 영어 문장
                Group {
                    MySentenceEditorInputRowView(
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
                        cardIndex: cardIndex
                    )
                    .padding(.top, 5)
                    
                    Rectangle()
                        .fill(cardIndex==activeCardIndex ? Color.primaryDefault : Color.gray300)
                        .frame(height: (cardIndex==activeCardIndex) ? 2 : 1)
                    
                    Text("영어")
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
}

struct MySentenceEditorInputRowView: View {
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
    var cardIndex: Int // 데이터 배열 인덱스
    var isKorean: Bool?
    
    
    @State private var keyboardHeight: CGFloat = 0 // 키보드 높이 (사용 안 함)
    
    var body: some View {
        ZStack {
            
            // 아이템마다 힌트 보여주니까 좀 조잡스런 느낌이라 주석처리함
            //MARK: - 힌트 TextField, 입력 안 됨
//            if currentTxt.isEmpty && arrayItemTxt.isEmpty {
//                TextField(placeholder, text: .constant(""))
//                    .font(.body11622Regular)
//                    .foregroundColor(.gray400)
//                    .padding(.vertical, 11)
//                    .disabled(true) // 보기용 (동작 안 함)
//            }
            
            
            
            //MARK: - 내용 TextField, 입력 가능
            // 백업 (동일한 카드, 예외 처리 필요한 상태)
//            TextField("", text:
//                        isTextFieldIsFocused ?
//                      $currentTxt :
//                    .constant(arrayItemTxt)
//            )
            //
            TextField("", text: isSameCard ? $currentTxt : .constant(arrayItemTxt))
            .font(.body11622Regular)
            .foregroundColor(.gray900)
            .padding(.vertical, 5).background(Color.gray25) // TextField 클릭 감도 높임
            //.opacity(currentTxt.isEmpty ? 0.2 : 1) // currentTxt 확인 테스트용
            .onChange(of: currentTxt) {
                if currentTxt.count > maxlength {
                    currentTxt = String(currentTxt.prefix(50))
                    isShowToast(true)
                }
            }
            .focused($isTextFieldIsFocused)
            .onAppear {
//                // "문장 추가하기 버튼" 클릭시,마지막 카드의 한국어 textfield 키보드 올림
//                if forceKeyboardUpIndex == cardIndex {
//                    if let _ = isKorean {
//                        DispatchQueue.main.asyncAfter(deadline: .now()) {
//                            // 이 TextField에서 키보드 강제로 올리기
//                            self.isTextFieldIsFocused = true
//                        }
//                    }
//                }
            }
            
            //MARK: - 키보드 상태 감지 (ChatGTP에게 'swiftui에서 textfield 사용할 때, 키보드가 다 올라왔는지 확인하는 방법을 알려줘.' 물어보면 됨)
            //.padding(.bottom, keyboardHeight) // 키보드 높이만큼 하단에 여백 추가
            .onAppear {
                // 키보드가 화면에 완전히 올라왔는지 간접적으로 확인하는 방법
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                        //keyboardHeight = keyboardSize.height
                        
                        // [중요 포인트]
                        // 키보드가 완전히 다 올라온 것을 확인하는 이유 :
                        // 키보드 바로 위에 View가 붙어 있기 때문에, 문장 리스트 아래쪽은 가려진다.
                        // 그래서 '키보드가 완전히 올라온 이후'에 일정 크기만큼 리스트를 올려줘야 하기 때문이다.
                        isKeyboardFocused(isTextFieldIsFocused)
                    }
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            
        }
    }
}

//#Preview {
//    MySentenceEditorInputView()
//}
