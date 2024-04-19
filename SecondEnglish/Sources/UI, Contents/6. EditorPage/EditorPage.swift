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
    @StateObject var homeTabViewModel = TabHomeViewModel.shared
    
    // 호출하는 곳에서 받아야 함
    var completion: ((Bool, String) -> Void)
    
    // ToolbarItem 버튼 클릭 유무
    @State var showWriteCancelView = false
    
    @State var selectedMainCategoryName: String = ""
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
    @State private var isPressPlusButton: Bool = false
    
    // 데이터 가공, 목표 형태
    // [
    //  {"korean_txt": "", "english_txt": ""},
    //  {"korean_txt": "", "english_txt": ""},
    //  ...
    // ]
    @State private var sentenceList: [Dictionary<String, String>] = []
    
    // 스크롤 맨 아래로 이동
    @State private var isScrollToBottom = false
    private let scrollToBottom = "SCROLL_TO_Bottom"
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
        static let koreanKey: String = "korean_txt"
        static let englishKey: String = "english_txt"
    }
}

extension EditorPage: View {
    var body: some View {
        NavigationView {
            LoadingViewContainer {
                // footerView 키보드 바로 위에 붙을 수 있도록 해줌
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        
                        if !viewModel.isEditMode {
                            categorySelectView
                        }
                        
                        ScrollViewReader { proxyReader in
                            
                            // 리스트 맨 아래로 이동시키기 위해,스크롤뷰 위치 감지
                            gotoScrollBottom(proxyReader: proxyReader)
                            
                            ScrollView(showsIndicators: false) {
                                
                                VStack(alignment: .leading, spacing: 0) {
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
                                                        
                                                        
                                                        // 키보드가 완전히 다 올라오고 나서 아래 코드를 적용시켜야 된다.
                                                        // 키보드가 올라오고 있는 도중에 아래 코드 적용하면 소용없음.
                                                        isScrollToBottom = true
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    currentCardIndex = index
                                                    
                                                    // 키보드 바로 위에 붙어 있는 View가 있기 때문에,
                                                    // 리스트 아래쪽에 있는 TextField 클릭한 경우에는 붙어 있는 View에 가려서 안 보이는 문제가 있음.
                                                    // 그래서 리스트 마지막 아이템 아래쪽에 '크기만 차지하는 Rectangle() 뷰'를 추가하고, 이 뷰로 이동시키도록 해서 해결했음.
                                                    //isScrollToBottom = true
                                                }
                                            },
                                            forceKeyboardUpIndex: forceKeyboardUpIndex,
                                            isItemDelete: { isSuccess, itemIndex in
                                                if isSuccess && sentenceList.count>0 {
                                                    
                                                    self.sentenceListDelete(deleteRequestIndex: itemIndex)
                                                }
                                            },
                                            isDisableDelete: sentenceList.count==1 ? true : false // 리스트가 하나 남아 있을 땐, 삭제할 수 없도록 좌측으로 Swipe 되지 않음
                                        )
                                        .padding(.top, index==0 ? 20 : 10)
                                        .padding(.bottom, index==(sentenceList.count-1) ? 20 : 0)
                                        
                                        // 키보드 바로 위에 붙어 있는 뷰때문에, 리스트 마지막 아이템은 가려져서 안 보이는 문제가 있음. 그래서 공간 확보함.
                                        if index == sentenceList.count-1 {
                                            Rectangle()
                                                .fill(Color.gray25)
                                                .frame(width: 100, height: 100)
                                                .id(scrollToBottom)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                            }
                        }
//                        .onAppear {
//                            // TabHomePage 에서 ScrollView bounces false로 설정했기 때문에, 여기서 다시 true로 설정해줘야 됨
//                            UIScrollView.appearance().bounces = true
//                        }
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
                            showWriteCancelView = true
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
                
                // 등록/수정 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if viewModel.isEditMode {
                            if let item = viewModel.editModeItem {
                                
                                // 키보드 내리기
                                UIApplication.shared.endEditing()
                                
                                StatusManager.shared.loadingStatus = .ShowWithTouchable
                                
                                viewModel.editCard(
                                    idx: item.idx ?? -1,
                                    korean: currentKoreanTxt,
                                    english: currentEnglishTxt
                                ) {
                                    // 로딩되는거 보여주려고 딜레이시킴
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        StatusManager.shared.loadingStatus = .Close
                                        
                                        presentationMode.wrappedValue.dismiss()
                                        
                                        let dataDic: [String: Any] = ["idx": item.idx ?? -1, "korean": currentKoreanTxt, "english" : currentEnglishTxt]
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            NotificationCenter.default.post(
                                                name: Notification.Name(DefineNotification.cardEditSuccess),
                                                object: nil,
                                                userInfo: [DefineKey.cardEditDone : dataDic] as [String : Any]
                                            )
                                        }
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                        else {
                            switch checkPostData() {
                            case .IsCategoryEmpty:
                                toastMessage = "se_j_write_category".localized
                                showToast()
                            case .IsThereEmptySentence:
                                toastMessage = "se_j_write_sentence".localized
                                showToast()
                            case .CheckOK:
                                
                                // 키보드 내리기
                                UIApplication.shared.endEditing()
                                
                                StatusManager.shared.loadingStatus = .ShowWithTouchable
                                
                                viewModel.addCardList(
                                    type1: "Basic",
                                    type2: selectedMainCategoryName,
                                    type3: selectedSubCategoryName,
                                    sentence_list: sentenceList
                                ) { isComplete in
                                    if isComplete {
                                        // 로딩되는거 보여주려고 딜레이시킴
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            StatusManager.shared.loadingStatus = .Close
                                            presentationMode.wrappedValue.dismiss()
                                            
                                            // 등록한 카테고리의 index 값을 가져온다.
                                            if let subCategoryIndex = self.getSubCategoryIndex(item: selectedSubCategoryName) {
                                                
                                                // Swipe Tab으로 이동 후, 등록한 카테고리의 내용을 갱신해서 보여준다.
                                                self.moveToSwipeTab(
                                                    subCategoryIdx: subCategoryIndex,
                                                    subCategoryName: selectedSubCategoryName,
                                                    mainCategoryName: selectedMainCategoryName
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }, label: {
                        Text(viewModel.isEditMode ? "s_modifying".localized : "d_registration".localized)
                            .foregroundColor(Color.stateEnableGray900)
                            .font(.title41824Medium)
                    })
                }
            }
        }
        .task {
            viewModel.requestMainCategory()
            
            sentenceList.insert(
                [
                    sizeInfo.koreanKey: "",
                    sizeInfo.englishKey: ""
                ]
                , at: currentCardIndex
            )
        }
        // TabSwipeCardPage.swift에서 데이터 설정을 위해 0.2초 후에 NotificationCenter를 호출하기 때문에 onChange()에서 받아야 됨.
        .onChange(of: viewModel.isEditMode) {
            if viewModel.isEditMode {
                if let item = viewModel.editModeItem {
                    
                    currentKoreanTxt = item.korean ?? ""
                    currentEnglishTxt = item.english ?? ""
                    
                    sentenceList = []
                    sentenceList.insert(
                        [
                            sizeInfo.koreanKey: currentKoreanTxt,
                            sizeInfo.englishKey: currentEnglishTxt
                        ]
                        , at: currentCardIndex
                    )
                }
            }
        }
        // Main Category List BottomSheet
        .bottomSheet(
            isPresented: $isShowMainCategoryListView,
            height: BottomSheetManager.shared.getBottomSheetHeight(list: viewModel.mainCategoryList),
            content: {
                EditorCategoryView(
                    viewType: EditorCategoryViewType.MainCategory,
                    mainCategoryList: viewModel.mainCategoryList,
                    isShow: $isShowMainCategoryListView,
                    selectedCategoryName: $selectedMainCategoryName
                )
                .onChange(of: selectedMainCategoryName) {
                    if viewModel.mainCategoryList.count > 0 {
                        viewModel.requestCategory(category: self.selectedMainCategoryName)
                    }
                }
            }
        )
        // Sub Category List BottomSheet
        .bottomSheet(
            isPresented: $isShowSubCategoryListView,
            height: BottomSheetManager.shared.getBottomSheetHeight(list: viewModel.subCategoryList),
            content: {
                EditorCategoryView(
                    viewType: EditorCategoryViewType.SubCategory,
                    subCategoryList: viewModel.subCategoryList,
                    isShow: $isShowSubCategoryListView,
                    selectedCategoryName: $selectedSubCategoryName
                )
                .onChange(of: selectedSubCategoryName) {
                    //fLog("idpil::: 선택된 sub category : \(selectedSubCategoryName)")
                }
            }
        )
        
        //MARK: - 팝업 (bottomsheet 로 올린 팝업 위에서 또다른 팝업을 보여주기 때문에 여기서 따로 설정함)
        // (.popup 클릭 -> PopupParameters 클릭)하면 설정할 수 있는 옵션 값들 있음
        .popup(isPresented: $showWriteCancelView) {
            alertWriteCancel
        } customize: {
            $0
                //.type(.floater())
                .position(.center)
                .animation(Animation.easeOut(duration: 0.15))
                //.closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
        
    }
    
    var categorySelectView: some View {
        HStack(spacing: 0) {
            Button(action: {
                // 키보드 내리기 (키보드 올라가 있을 땐 팝업 안 보임)
                UIApplication.shared.endEditing()
                
                isShowMainCategoryListView.toggle()
            }, label: {
                HStack(spacing: 0) {
                    Text(selectedMainCategoryName.count > 0 ? selectedMainCategoryName : "k_select_to_main_category".localized)
                        .font(.body21420Regular)
                        .foregroundColor(.gray900)
                    
                    Image("icon_outline_dropdown")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 12, height: 12)
                        .foregroundColor(.stateEnableGray400)
                        .padding(.leading, 8)
                }
                .onChange(of: selectedMainCategoryName, initial: false) { oldValue, newValue in
                    // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
                    
                    // 메인 카테고리 변경한 경우 -> 서브 카테고리 초기화
                    if oldValue != newValue {
                        self.selectedSubCategoryName = ""
                    }
                }
            })
            
            if viewModel.subCategoryList.count > 0 {
                Button(action: {
                    // 키보드 내리기 (키보드 올라가 있을 땐 팝업 안 보임)
                    UIApplication.shared.endEditing()
                    
                    isShowSubCategoryListView.toggle()
                }, label: {
                    HStack(spacing: 0) {
                        Text(selectedSubCategoryName.count > 0 ? selectedSubCategoryName : "k_select_to_sub_category".localized)
                            .font(.body21420Regular)
                            .foregroundColor(.gray900)
                            .lineLimit(1)
                        
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
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
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
                    //fLog("idpil::: sentenceList : \(sentenceList)")
                    
                    
                    // 리스트 마지막 카드의 한국어 textfield 키보드 올림
                    // 이거 설정 안 하면 키보드 안 올라감
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
                        .aspectRatio(contentMode: .fit).frame(height: 40) // 높이에 맞춰 비율 유지함
                        .padding(10) // 클릭 영역 확장
                }
                .opacity(viewModel.isEditMode ? 0.0 : 1.0) // 공간은 차지하기 위해 opacity로 설정함
                
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
            .background(Color.gray25)
        }
    }
    
    //MARK: - 작성 취소 얼럿
    var alertWriteCancel: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("se_b_post_write_back".localized)
                .foregroundColor(Color.gray870)
                .font(.buttons1420Medium)
                .multilineTextAlignment(.center)
            
            HStack {
                CommonButton2(title: "a_no".localized, type: .defaults(), disabled: .constant(true))
                    .padding(.trailing, 2)
                    .onTapGesture {
                        showWriteCancelView.toggle()
                    }
                
                CommonButton(title: "a_yes".localized, bgColor: Color.blue)
                    .padding(.leading, 2)
                    .onTapGesture {
                        showWriteCancelView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
            .padding(.top, 24)
        }
        .padding(EdgeInsets(top: 37, leading: 32, bottom: 40, trailing: 32))
        .background(Color.gray25.cornerRadius(24))
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
        .padding(.horizontal, 50)
    }
    
    func gotoScrollBottom(proxyReader: ScrollViewProxy) -> some View {
        if isScrollToBottom {
            withAnimation {
                DispatchQueue.main.async {
                    // '문장추가 버튼' 클릭시, 리스트 마지막 아이템 위치로 이동
                    proxyReader.scrollTo(scrollToBottom, anchor: .bottom)
                    
                    isScrollToBottom = false
                }
            }
        }
        
        return EmptyView()
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
        return selectedMainCategoryName.count>0 ||
                selectedSubCategoryName.count>0 ||
            (
                // view load될 때 sentenceList에 빈 문자 저장함
                sentenceList.count>1 ?
                    sentenceList.count>1 :
                    (currentKoreanTxt.count>0 || currentEnglishTxt.count>0)
            )
        
    }
    
    // 등록버튼 클릭시 검사
    func checkPostData() -> EditorPostCheckType {
        
        // 1. 입력 중이던 카드 내용 업데이트
        sentenceList[currentCardIndex][sizeInfo.koreanKey] = currentKoreanTxt
        sentenceList[currentCardIndex][sizeInfo.englishKey] = currentEnglishTxt
        
        // 2. 선택 안 된 카테고리가 있는지 검사
        if selectedMainCategoryName.isEmpty || selectedSubCategoryName.isEmpty {
            return .IsCategoryEmpty
        }
        
        // 3. 빈 문장 있는지 검사
        for item in sentenceList {
            //fLog("koreanKey : \(item[sizeInfo.koreanKey] ?? "")")
            //fLog("englishKey : \(item[sizeInfo.englishKey] ?? "")")
            if (item[sizeInfo.koreanKey] ?? "").isEmpty ||
                (item[sizeInfo.englishKey] ?? "").isEmpty {
                
                return .IsThereEmptySentence
            }
        }
        
        // 3. 검사 통과
        return .CheckOK
    }
    
    private func getSubCategoryIndex(item: String) -> Int? {
        var categoryIndex: Int?
        if let index = viewModel.subCategoryList.firstIndex(of: item) {
            categoryIndex = index
        }
        return categoryIndex
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
//    EditorPage()
//}
