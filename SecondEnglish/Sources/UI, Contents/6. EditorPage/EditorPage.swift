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
                                                    
                                                    // 작성했던 카드를 수정하려고 선택한 경우
                                                    if isOnlyEditMode {
                                                        sentenceListUpdate(activedIndex: index)
                                                    }
                                                    currentCardIndex = index
                                                }
                                            },
                                            forceKeyboardUpIndex: forceKeyboardUpIndex
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
            
            currentKoreanTxt = ""
            currentEnglishTxt = ""
            
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
        // 키보드 활성 상태혔던 카드가 아닌, 다른 카드를 수정하려고 선택한 경우
        if currentCardIndex != activedIndex {
            if sentenceList.count > 0 {
                
                fLog("idpil::: here!!!")
                
                sentenceList[currentCardIndex][sizeInfo.koreanKey] = currentKoreanTxt
                
                sentenceList[currentCardIndex][sizeInfo.englishKey] = currentEnglishTxt
                
                
                
                currentKoreanTxt = sentenceList[activedIndex][sizeInfo.koreanKey] ?? ""
                currentEnglishTxt = sentenceList[activedIndex][sizeInfo.englishKey] ?? ""
                
                // 초기화
                //isPressPlusButton = false
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
