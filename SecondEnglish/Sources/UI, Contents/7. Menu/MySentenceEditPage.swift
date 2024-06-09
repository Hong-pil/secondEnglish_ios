//
//  MySentenceEditPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/26/24.
//

import SwiftUI

struct MySentenceEditPage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = MenuViewModel()
    
    @State var editedSentenceList: [SwipeDataList] = []
    var sentenceList: [SwipeDataList]
    var completion: ((Bool, String) -> Void)
    
    // ToolbarItem 버튼 클릭 유무
    @State var showWriteCancelView = false
    
    @State var currentKoreanTxt: String = ""
    @State var currentEnglishTxt: String = ""
    @State var currentCardIndex: Int = -1
    
    @State private var isShowToast: Bool = false
    @State private var toastMessage: String = ""
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
        static let koreanKey: String = "korean_txt"
        static let englishKey: String = "english_txt"
        static let idxKey: String = "idx"
    }
}

extension MySentenceEditPage: View {
    var body: some View {
        LoadingViewContainer {
            // footerView 키보드 바로 위에 붙을 수 있도록 해줌
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    
                    ScrollViewReader { proxyReader in
                        
                        ScrollView(showsIndicators: false) {
                            
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(editedSentenceList.enumerated()), id: \.offset) { index, item in
                                    
                                    MySentenceEditorInputView(
                                        currentKoreanTxt: $currentKoreanTxt,
                                        currentEnglishTxt: $currentEnglishTxt,
                                        cardIndex: index,
                                        activeCardIndex: currentCardIndex,
                                        arrayItemKoreanTxt: item.korean ?? "",
                                        arrayItemEnglishTxt: item.english ?? "",
                                        korean_maxlength: DefineSize.EditorPrefixLength.txtLength,
                                        english_maxlength: DefineSize.EditorPrefixLength.txtLength,
                                        isShowTxtLengthToast: { isShow in
                                            if isShow {
                                                toastMessage = "se_editor_txt_length_limit".localized
                                                
                                                showToast()
                                            }
                                        },
                                        // 키보드 올라왔음
                                        isKeyboardFocused: { isFocused in
                                            
                                            if isFocused {
                                                
                                                sentenceListUpdate(activedIndex: index)
                                                
                                                currentCardIndex = index
                                            }
                                        }
                                    )
                                    .padding(.top, index==0 ? 20 : 10)
                                    .padding(.bottom, index==(sentenceList.count-1) ? 20 : 0)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                        }
                    }
                }
                
                footerView
                
                if isShowToast {
                    ToastView(text: toastMessage)
                        .shadow(radius: 2)
                        .padding(.bottom, 60)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
            
            // 완료
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                    // 하나도 수정 안 한 경우
                    if currentKoreanTxt.isEmpty && currentEnglishTxt.isEmpty {
                        presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        switch checkPostData() {
                        case .IsCategoryEmpty:
                            fLog("여기는 사용 안 함")
    //                        toastMessage = "se_j_write_category".localized
    //                        showToast()
                        case .IsThereEmptySentence:
                            toastMessage = "se_j_write_sentence".localized
                            showToast()
                        case .CheckOK:
                            
                            // 키보드 내리기
                            UIApplication.shared.endEditing()
                            
                            StatusManager.shared.loadingStatus = .ShowWithTouchable
                            
                            let editedArr = self.findUniqueItems(from: editedSentenceList, comparedTo: sentenceList)
                            //fLog("idpil::: 수정한 리스트 : \(editedArr)")
                            
                            
                            
                            // api 호출시, 전송되는 형태
                            // [SwipeDataList] 형태로는 전송이 안 됐는데. 해결되면 정리해둘 것.
                            var dicArr: [Dictionary<String, String>] = []
                            for (index, item) in editedArr.enumerated() {
                                dicArr.insert(
                                    [
                                        sizeInfo.koreanKey: item.korean ?? "",
                                        sizeInfo.englishKey: item.english ?? "",
                                        sizeInfo.idxKey: String(item.idx ?? 0)
                                    ]
                                    , at: index
                                )
                            }
                            
                            
                            viewModel.editCardList(
                                sentence_list: dicArr,
                                isPostComplete: { isSuccess in
                                    if isSuccess {
                                        // 로딩되는거 보여주려고 딜레이시킴
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            StatusManager.shared.loadingStatus = .Close
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            )
                            
                            
                        }
                    }
                }, label: {
                    Text("a_done".localized)
                        .font(.title51622Medium)
                        .foregroundColor(.stateEnableGray900)
                })
            }
        }
        .task {
            editedSentenceList = sentenceList
        }
        
    }
    
    var footerView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray400)
                .frame(height: 1)
         
            ZStack {
                Text("\(currentCardIndex+1) / \(sentenceList.count)")
                    .font(.caption21116Regular)
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                Button(action: {
                    // View 탭시, Keyboard dismiss 하기
                    UIApplication.shared.endEditing()
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.gray400)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(height: 40)
            .background(Color.gray25)
        }
    }
}

extension MySentenceEditPage {
    func sentenceListUpdate(activedIndex: Int) {
        // sentenceList : 이전 카드 인덱스
        // activedIndex : 클릭한 카드 인덱스
        
//        fLog("idpil::: currentCardIndex : \(currentCardIndex)")
//        fLog("idpil::: activedIndex : \(activedIndex)")
//        fLog("idpil::: currentKoreanTxt.isEmpty : \(currentKoreanTxt.isEmpty)")
//        fLog("idpil::: currentEnglishTxt.isEmpty : \(currentEnglishTxt.isEmpty)")
        
        // 화면 진입 후, 아무 카드나 처음 클릭한 경우
        if currentKoreanTxt.isEmpty && currentEnglishTxt.isEmpty {
            // 현재 입력 중인 내용 <- 클릭한 카드에 저장되어 있던 내용 (이어서 수정해야 하니까)
            currentKoreanTxt = editedSentenceList[activedIndex].korean ?? ""
            currentEnglishTxt = editedSentenceList[activedIndex].english ?? ""
        } else {
            // 키보드 활성 상태혔던 카드가 아닌, 다른 카드를 수정하려고 선택한 경우
            if currentCardIndex != activedIndex {
                if currentCardIndex > -1 {
                    
                    // 이전 카드 <- 이전 입력 중인 내용 입력
                    editedSentenceList[currentCardIndex].korean = currentKoreanTxt
                    editedSentenceList[currentCardIndex].english = currentEnglishTxt
                    
                    // 현재 입력 중인 내용 <- 클릭한 카드에 저장되어 있던 내용 (이어서 수정해야 하니까)
                    currentKoreanTxt = editedSentenceList[activedIndex].korean ?? ""
                    currentEnglishTxt = editedSentenceList[activedIndex].english ?? ""
                }
            }
        }
    }
    
    func showToast(already: Bool = true) {
        if already {
            if !isShowToast {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowToast = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if isShowToast {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowToast = false
                        }
                    }
                }
            }
        }
    }
    
    // 취소버튼 클릭시 검사
    func checkMinimalData() -> Bool {
//        return selectedMainCategoryName.count>0 ||
//                selectedSubCategoryName.count>0 ||
//            (
//                // view load될 때 sentenceList에 빈 문자 저장함
//                sentenceList.count>1 ?
//                    sentenceList.count>1 :
//                    (currentKoreanTxt.count>0 || currentEnglishTxt.count>0)
//            )
        return false
        
    }
    
    // 등록버튼 클릭시 검사
    func checkPostData() -> EditorPostCheckType {
        
        // 1. 입력 중이던 카드 내용 업데이트
        editedSentenceList[currentCardIndex].korean = currentKoreanTxt
        editedSentenceList[currentCardIndex].english = currentEnglishTxt
        
        // 2. 선택 안 된 카테고리가 있는지 검사
//        if selectedMainCategoryName.isEmpty || selectedSubCategoryName.isEmpty {
//            return .IsCategoryEmpty
//        }
        
        // 3. 빈 문장 있는지 검사
        for item in editedSentenceList {
            //fLog("koreanKey : \(item[sizeInfo.koreanKey] ?? "")")
            //fLog("englishKey : \(item[sizeInfo.englishKey] ?? "")")
            if (item.korean ?? "").isEmpty ||
                (item.english ?? "").isEmpty {
                
                return .IsThereEmptySentence
            }
        }
        
        // 3. 검사 통과
        return .CheckOK
    }
    
    // 수정된 카드만 모아서 리턴
    func findUniqueItems(from editedList: [SwipeDataList], comparedTo originalList: [SwipeDataList]) -> [SwipeDataList] {
        
        /// Swift에서 두 개의 SwipeDataList 배열을 비교하고, 한 배열(editedSentenceList)에 있는 요소들 중 다른 배열(sentenceList)에는 존재하지 않는 요소들만을 추출하여 새로운 배열로 반환하는 함수를 만드는 작업은 Hashable 프로토콜의 특성을 활용할 수 있습니다. Hashable 프로토콜을 채택함으로써, 우리는 각 SwipeDataList 인스턴스를 Set의 원소로 사용할 수 있게 되어, 효율적으로 비교하고, 차집합을 구할 수 있습니다.
        /// 이 함수는 두 개의 매개변수를 받습니다:
        /// editedList: 수정된 목록을 나타내는 [SwipeDataList] 배열입니다.
        /// originalList: 원본 목록을 나타내는 [SwipeDataList] 배열입니다.
        /// 함수의 내부 동작은 다음과 같습니다:
        /// 먼저, 각 목록을 `Set 으로 변환합니다. 이 변환 과정은 각각의 리스트를 Set` 타입으로 만들어 중복을 제거하고, Set 간의 연산을 가능하게 합니다.
        /// originalSet과 editedSet을 생성한 후, subtracting 메소드를 사용하여 editedSet에서 originalSet에 속한 요소들을 제외한 나머지 요소들만을 추출합니다. 이 메소드는 editedSet에만 존재하고 originalSet에는 존재하지 않는 요소들의 집합을 반환합니다.
        /// 마지막으로, uniqueItems 집합을 다시 배열로 변환하여 반환합니다.
        /// 이 함수를 사용하면, 사용자가 수정한 리스트(editedSentenceList)에서 원본 리스트(sentenceList)에는 존재하지 않는 새로운 데이터만을 추출할 수 있습니다. 이러한 기능은 특히 사용자가 데이터를 수정하거나 추가한 후 그 변경사항만을 추출해야 할 필요가 있을 때 유용합니다.
        ///
        /// 다음은 이 함수를 사용하는 방법의 예입니다:
        /// let sentenceList: [SwipeDataList] = [/* 여기에 초기 데이터를 채웁니다 */]
        /// let editedSentenceList: [SwipeDataList] = [/* 여기에 수정된 데이터를 채웁니다 */]
        ///
        /// let uniqueItems = findUniqueItems(from: editedSentenceList, comparedTo: sentenceList)
        ///
        /// // `uniqueItems` 배열은 `editedSentenceList`에만 있는 요소들을 포함합니다
        ///
        /// 이 구현은 SwipeDataList가 정확히 어떤 값을 가지고 있느냐에 따라 달라질 수 있습니다. 예를 들어, 모든 속성이 optional인 경우, 두 개체가 동일한지 비교하기 위해 Hashable 프로토콜을 구현할 때 더 세밀한 조정이 필요할 수 있습니다. 또한, 객체의 식별이 customId나 idx 같은 특정 필드에 의존하는 경우, 해당 필드만을 사용하여 비교 로직을 구성할 수도 있습니다.
        
        
        let originalSet = Set(originalList)
        let editedSet = Set(editedList)
        let uniqueItems = editedSet.subtracting(originalSet)
        return Array(uniqueItems)
    }
    
    private func moveToSwipeTab(subCategoryIdx: Int, subCategoryName: String, mainCategoryName: String) {
        let dataDic: [String: Any] = ["subCategoryIdx": subCategoryIdx, "subCategoryName" : subCategoryName, "mainCategoryName": mainCategoryName]
        
        // Swipe Tab 으로 이동
        LandingManager.shared.showSwipePage = true
        
        //NotificationCenter.default.post(name: Notification.Name("workCompleted"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(
                name: Notification.Name(DefineNotification.moveToSwipeTab),
                object: nil,
                userInfo: [DefineKey.subCategoryIndexAndName : dataDic] as [String : Any]
            )
        }
    }
}

//#Preview {
//    MySentenceEditPage()
//}
