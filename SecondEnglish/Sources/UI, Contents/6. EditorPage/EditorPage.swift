//
//  EditorPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/15/24.
//

import SwiftUI

struct EditorPage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = EditorViewModel()
    
    // 호출하는 곳에서 받아야 함
    var completion: ((Bool, String) -> Void)
    
    @State var showWriteCancel = false
    
    @State var selectedMainCategoryName: String = "" {
        didSet(oldValue) {
            // 메인 카테고리 변경한 경우 -> 서브 카테고리 초기화
            if oldValue != selectedMainCategoryName {
                self.selectedSubCategoryName = "m_summury_select".localized
            }
        }
    }
    @State var selectedSubCategoryName: String = ""
    @State var categoryBottomSheetHeight: CGFloat = 0.0
    
    @State var currentKoreanTxt: String = ""
    @State var currentEnglishTxt: String = ""
    @State var currentCardIndex: Int = 0
    @State var forceKeyboardUpIndex: Int = 0
    
    @State private var isShowToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var isShowMainCategoryListView: Bool = false
    @State private var isShowSubCategoryListView: Bool = false
    @State private var isKeyboardFocused: Bool = false
    @State private var isPressPlusButton: Bool = false
    
    // 데이터 가공, 목표 형태
    // [
    //  {"korean_txt": "", "english_txt": ""},
    //  {"korean_txt": "", "english_txt": ""},
    //  ...
    // ]
    @State private var sentenceList: [Dictionary<String, String>] = []
    
    var type: EditorType = .Write
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
        static let koreanKey: String = "korean_txt"
        static let englishKey: String = "english_txt"
    }
}

extension EditorPage: View {
    var body: some View {
        // View 탭시, Keyboard dismiss 하기
        BackgroundTapGesture {
            NavigationView {
                LoadingViewContainer {
                    // footerView 키보드 바로 위에 붙을 수 있도록 해줌
                    ZStack(alignment: .bottom) {
                        ScrollViewReader { proxyReader in
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    categorySelectView
                                    
                                    ForEach(Array(sentenceList.enumerated()), id: \.offset) { index, item in
                                        
                                        EditorInputView(
                                            currentKoreanTxt: $currentKoreanTxt,
                                            currentEnglishTxt: $currentEnglishTxt,
                                            cardIndex: index,
                                            activeCardIndex: currentCardIndex,
                                            arrayItemKoreanTxt: item[sizeInfo.koreanKey] ?? "",
                                            arrayItemEnglishTxt: item[sizeInfo.englishKey] ?? "",
                                            korean_maxlength: 50,
                                            english_maxlength: 50,
                                            isShowTxtLengthToast: { isShow in
                                                if isShow {
                                                    toastMessage = "se_j_title_length_limit".localized
                                                    
                                                    showToast()
                                                }
                                            },
                                            // 키보드 올라왔음
                                            isKeyboardFocused: { isFocused in
                                                if isFocused {
                                                    /**
                                                     * [키보드가 올라오는 경우의 수는 두 가지가 있음. 이 두가지를 구분하기 위한 기능]
                                                     * 첫 번째, '카드 추가 버튼' 클릭했을 때 추가된 마지막 카드의 한글 TextField 에서 키보드 활성됨
                                                     * 두 번째, 추가된 카드 중에서 TextField 클릭한 경우, 해당 TextField에서 키보드 활성됨
                                                     *
                                                     * 아래는 "두 번째" 경우에만 실행될 수 있도록 구현한 기능
                                                     */
                                                    var isOnlyEditMode = false
                                                    if isPressPlusButton {
                                                       isOnlyEditMode = false
                                                        isPressPlusButton = false
                                                    } else {
                                                        isOnlyEditMode = true
                                                    }
                                                    
                                                    // 작성했던 이전 카드 중에서 특정 카드를 수정하려고 선택한 경우
                                                    if isOnlyEditMode {
                                                        sentenceListUpdate(activedIndex: index)
                                                    }
                                                    // 추가하기 버튼 클릭해서 키보드 올라온 경우
                                                    else {
                                                        /**
                                                         * [중요한 포인트]
                                                         * 키보드 올라오기 전에 아래와 같이 초기화 설정하면, 이전 카드의 TextField가 한 번 깜빡이는 문제가 있음.
                                                         * 그래서 키보드 올라오고 나서 초기화 해주는게 맞음.
                                                         */
                                                        currentKoreanTxt = ""
                                                        currentEnglishTxt = ""
                                                    }
                                                    
                                                    currentCardIndex = index
                                                }
                                            },
                                            forceKeyboardUpIndex: forceKeyboardUpIndex,
                                            isItemDelete: { isSuccess, itemIndex in
                                                if isSuccess && sentenceList.count>0 {
                                                    
                                                    self.sentenceListDelete(deleteRequestIndex: itemIndex)
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
                        
                        footerView
                        
                        if isShowToast {
                            ToastView(text: toastMessage)
                                .shadow(radius: 2)
                                .padding(.bottom, 60)
                        }
                    }
                }
                .toolbar {
                    
                    // 취소버튼
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            if checkMinimalData() {
                                CommonAlertView(title: {
                                    Text("se_b_post_write_back".localized)
                                        .foregroundColor(Color.gray870)
                                        .font(.buttons1420Medium)
                                        .multilineTextAlignment(.center)
                                },buttons: ["a_no".localized,"a_yes".localized]) { buttonIndex in
                                    if buttonIndex == 1 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                                .present {
                                    showWriteCancel.toggle()
                                }
                            }
                            else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Image("icon_outline_cancel")
                                .resizable()
                                .frame(width: sizeInfo.toolBarCancelButtonSize, height: sizeInfo.toolBarCancelButtonSize)
                        })
                    }
                    
                    // 등록버튼
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            Text(type == .Write ? "d_registration".localized : "s_modifying".localized)
                                .foregroundColor(checkPostData() ? Color.stateActivePrimaryDefault : Color.stateEnableGray400)
                                .font(.body21420Regular)
                        })
                    }
                }
            }
            .task {
                sentenceList.insert(
                    [
                        sizeInfo.koreanKey: "",
                        sizeInfo.englishKey: ""
                    ]
                    , at: currentCardIndex
                )
            }
        }
        // Main Category List BottomSheet
        .bottomSheet(
            isPresented: $isShowMainCategoryListView,
            height: getMainCategoryBottomSheetHeight(),
            content: {
                EditorCategoryView(
                    viewType: EditorCategoryViewType.MainCategory,
                    mainCategoryList: viewModel.type2CategoryList,
                    isShow: $isShowMainCategoryListView,
                    selectedCategoryName: $selectedMainCategoryName
                )
                .onChange(of: selectedMainCategoryName) {
                    fLog("idpil::: 선택된 main category : \(selectedMainCategoryName)")
                    
                    fLog("idpil::: 보여줄 subCategoryList : \(viewModel.getSubCategoryList(selectedMainCategoryName: selectedMainCategoryName))")
                }
            }
        )
        // Sub Category List BottomSheet
        .bottomSheet(
            isPresented: $isShowSubCategoryListView,
            height: getSubCategoryBottomSheetHeight(),
            content: {
                EditorCategoryView(
                    viewType: EditorCategoryViewType.SubCategory,
                    subCategoryList: viewModel.getSubCategoryList(selectedMainCategoryName: selectedMainCategoryName),
                    isShow: $isShowSubCategoryListView,
                    selectedCategoryName: $selectedSubCategoryName
                )
                .onChange(of: selectedSubCategoryName) {
                    fLog("idpil::: 선택된 sub category : \(selectedSubCategoryName)")
                }
            }
        )
    }
    
    var categorySelectView: some View {
        HStack(spacing: 0) {
            Button(action: {
                isShowMainCategoryListView.toggle()
            }, label: {
                HStack(spacing: 0) {
                    Text(selectedMainCategoryName.count > 0 ? selectedMainCategoryName : "k_select_to_main_category".localized)
                        .font(.body21420Regular)
                        .foregroundColor(type == .Modify ? .gray200 : .gray900)
                    
                    Image("icon_outline_dropdown")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 12, height: 12)
                        .foregroundColor(.stateEnableGray400)
                        .padding(.leading, 8)
                }
            })
            .disabled(type == .Modify)
            
            if viewModel.getSubCategoryList(selectedMainCategoryName: selectedMainCategoryName).count > 0 {
                Button(action: {
                    isShowSubCategoryListView.toggle()
                }, label: {
                    HStack(spacing: 0) {
                        Text(selectedSubCategoryName.count > 0 ? selectedSubCategoryName : "k_select_to_sub_category".localized)
                            .font(.body21420Regular)
                            .foregroundColor(.gray900)
                        
                        Image("icon_outline_dropdown")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                            .foregroundColor(.stateEnableGray400)
                            .padding(.leading, 8)
                    }
                })
                .padding(.leading, 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var footerView: some View {
        Button {
            
            isPressPlusButton = true
            
            // 데이터 가공, 목표 형태
            // [
            //  {"korean_txt": "", "english_txt": ""},
            //  {"korean_txt": "", "english_txt": ""},
            //  ...
            // ]
            
            sentenceList.insert(
                [
                    sizeInfo.koreanKey: currentKoreanTxt,
                    sizeInfo.englishKey: currentEnglishTxt
                ],
                at: currentCardIndex
            )
            

            fLog("idpil::: sentenceList : \(sentenceList)")
            
            // "문장 추가하기 버튼" 클릭시,마지막 카드의 한국어 textfield 키보드 올림
            forceKeyboardUpIndex = sentenceList.count-1
            
//            currentKoreanTxt = ""
//            currentEnglishTxt = ""
            
        } label: {
            Image(systemName: "plus")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.gray25)
                .padding(10)
                .background(Circle().fill(Color.primaryDefault))
                .frame(width: 40, height: 40)
                .padding(10) // 클릭 영역 확장
        }
        .frame(maxWidth: .infinity)
        
    }
    
}

extension EditorPage {
    
    func sentenceListUpdate(activedIndex: Int) {
        // sentenceList : 이전 카드 인덱스
        // activedIndex : 클릭한 카드 인덱스
        
        // 키보드 활성 상태혔던 카드가 아닌, 다른 카드를 수정하려고 선택한 경우
        if currentCardIndex != activedIndex {
            if sentenceList.count > 0 {
                
                /**
                 * [중요]
                 * "입력 중이던 카드를 삭제한 경우"  바로 직후에는,
                 * 당연히 "이전 카드"가 없어진 것이기 때문에 아래 기능이 적용되면 안 됨.
                 */
                if currentCardIndex != -1 {
                    // 이전 카드 <- 이전 입력 중인 내용 입력
                    sentenceList[currentCardIndex][sizeInfo.koreanKey] = currentKoreanTxt
                    
                    sentenceList[currentCardIndex][sizeInfo.englishKey] = currentEnglishTxt
                }
                
                // 현재 입력 중인 내용 <- 클릭한 카드에 저장되어 있던 내용 (이어서 수정해야 하니까)
                currentKoreanTxt = sentenceList[activedIndex][sizeInfo.koreanKey] ?? ""
                currentEnglishTxt = sentenceList[activedIndex][sizeInfo.englishKey] ?? ""
                
                // 초기화
                //isPressPlusButton = false
            }
        }
    }
    
    func sentenceListDelete(deleteRequestIndex: Int) {
        
        // 1. 배열에서 아이템 삭제
        sentenceList.remove(at: deleteRequestIndex)
        
        // 2. 현재 입력 중인 카드에서 삭제 요청인지 검사
        // 2-1. 수정 중이던 카드 삭제 요청인 경우
        if currentCardIndex == deleteRequestIndex {
            
            // 입력 중이던 카드를 삭제했으니 관련 변수 초기화
            currentKoreanTxt = ""
            currentEnglishTxt = ""
            // [중요 포인트]
            // currentCardIndex 가 가리키고 있는 카드가 삭제됐으니, 아무 카드도 선택되지 않도록 -1 값으로 저장한다.
            // 그래서 "입력 중이던 카드를 삭제한 경우"를 구분하는 기준이 "currentCardIndex = -1"인 것이다.
            // 이게 왜 중요하냐면, 입력 중이던 카드를 삭제한 ""바로 직후에"" 생성되어 있는 특정 카드를 수정하려고 클릭한 경우, 키보드가 올라오고 self.sentenceListUpdate() 함수가 호출되는데, 당연히 "이전 카드"가 없어진 것이기 때문에 "클릭했던 이전 카드에 입력 중이던 내용을 입력"하는 기능이 호출되면 안 된다. 그래서 "입력 중이던 카드를 삭제한 경우"에만 피하는 용도로 쓰인다.
            currentCardIndex = -1
        }
        // 2-2. 수정 중이던 카드 이외의 카드 삭제 요청인 경우
        else if currentCardIndex != deleteRequestIndex {
            
            // 배열 아이템 하나를 삭제했으니,
            // 현재 카드를 가리키고 있는 인덱스에서 1을 빼준다.
            currentCardIndex -= 1
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
        return !currentKoreanTxt.isEmpty || !currentEnglishTxt.isEmpty
    }
    
    // 등록버튼 클릭시 검사
    func checkPostData() -> Bool {
        if !currentKoreanTxt.isEmpty &&
            !currentEnglishTxt.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    
    func getMainCategoryBottomSheetHeight() -> CGFloat {
        if viewModel.type2CategoryList.count > 0 {
            switch viewModel.type2CategoryList.count {
            case 1...3:
                return 190.0
            case 4...6:
                return 320.0
            case 7...9:
                return 440.0
            case 10..<14:
                return 610.0
            default:
                return .infinity
            }
        } else {
            return 0.0
        }
    }
    
    func getSubCategoryBottomSheetHeight() -> CGFloat {
        let subCategoryList = viewModel.getSubCategoryList(selectedMainCategoryName: selectedMainCategoryName)
        
        if subCategoryList.count > 0 {
            switch subCategoryList.count {
            case 1...3:
                return 190.0
            case 4...6:
                return 320.0
            case 7...9:
                return 440.0
            case 10..<14:
                return 610.0
            default:
                return .infinity
            }
        } else {
            return 0.0
        }
    }
}

//#Preview {
//    EditorPage()
//}
