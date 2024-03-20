//
//  TabSwipeCardPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import AVFoundation
import AVKit

struct TabSwipeCardPage {
    @StateObject var viewModel = SwipeCardViewModel.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    @State private var isShowMainCategoryButtonAnimation = false
    @State private var isShowMainCategoryListView = false
    @State private var isShowGrammarInfo: Bool = false
    @State private var currentCardIndex: Int = 0
    @State private var curPercent: Double = 0.0
    @AppStorage(DefineKey.mainCategoryName) var selectedMainCategoryItem: String = ""
    
    /**
     * [주의사항]
     * 자식뷰에서 변수 선언하면 기능 작동은 하는데, 로딩시간이 엄청 길어지는 문제가 있음.
     * 그리고 'Unable to list voice folder'라는 경고 문구가 뜸.
     * 그래서 전역변수 하나만 생성해서, 자식뷰로 넘겨주는 방식으로 해결했음.
     */
    let speechSynthesizer = AVSpeechSynthesizer() // TTS
    
    
    
    
    /**
     * [랜덤 카드 관련 사이즈]
     */
    // 각 직사각형 뷰에 사용할 색상 배열
    private let randomCardColors: [Color] = [.red, .green, .blue, .black]
    // 각 뷰의 회전 상태를 관리한다
    @State private var randomCardRotationDegrees = [0.0, 0.0, 0.0, 0.0]
    // 각 뷰의 위치 이동 상태를 관리한다
    @State private var randomCardOffsets = [sizeInfo.index0RandomCardOffset, sizeInfo.index1RandomCardOffset, sizeInfo.index2RandomCardOffset, sizeInfo.index3RandomCardOffset]
    @State private var isShowRandomCardShuffle: Bool = false
    @State private var randomCardList: [SwipeDataList] = []
    
    
    private struct sizeInfo {
        static let grammarTextFont_title: Font = Font.title32028Bold
        static let grammarTextFont_content: Font = Font.buttons1420Medium
        static let grammarTextFontColor_title: Color = Color.primaryDefault
        static let grammarTextFontColor_content: Color = Color.gray850
        static let grammarTextPaddingTop_title: CGFloat = 20.0
        static let grammarTextPaddingTop_content: CGFloat = 10.0
        
        // 랜덤 카드 관련 사이즈
        static let index0RandomCardOffset: CGSize = CGSize.zero
        static let index1RandomCardOffset: CGSize = CGSize(width: 0, height: -10)
        static let index2RandomCardOffset: CGSize = CGSize(width: 0, height: -20)
        static let index3RandomCardOffset: CGSize = CGSize(width: 0, height: -30)
    }
}

extension TabSwipeCardPage: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                HStack(spacing: 10) {
                    mainCategoryButton
                    
                    Button(action: {
                        withAnimation {
                            self.isShowGrammarInfo = true
                        }
                    }, label: {
                        Image("icon_help")
                            .resizable()
                            .frame(width: 40, height: 40)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        bottomSheetManager.show.swipeCardCut = true
                    }, label: {
                        Image(systemName: "scissors")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(.primaryDefault)
                            .padding(7).background(Color.gray25) // 클릭 잘 되도록
                    })
                    
                    Button(action: {
                        
                        if viewModel.swipeList.count < 4 {
                            UserManager.shared.showCardShuffleError = true
                        }
                        
                        if !self.isShowRandomCardShuffle && viewModel.swipeList.count > 3 {
                            
                            // 랜덤카드 데이터 세팅
                            self.setRandomCardList() {
                                
                                self.isShowRandomCardShuffle = true
                                
                                viewModel.shuffleSwipeList()
                                
                                self.doShuffleRandomCard()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.doShuffleRandomCard()
                                    
                                    // 카드 섞는 애니메이션 duration이 0.3초 이기 때문에, 0.3초 뒤에 뷰를 안 보이게 한다.
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        self.isShowRandomCardShuffle = false
                                    }
                                }
                                
                            }
                        }
                    }, label: {
                        Image(systemName: "shuffle")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.primaryDefault)
                            .frame(height: 20)
                            .padding(7).background(Color.gray25) // 클릭 잘 되도록
                    })
                    .padding(.leading, 5)
                    .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                subCategoryTabView
                
    //            ZStack {
    //                VStack(spacing: 0) {
    //                    mainCategoryButton
    //
    //                    categoryTabView
    //                }
    //                .padding(.top, 20)
    //
    //                if self.selectedMainCategoryName.isEmpty {
    //                    emptyBubbleShapeView
    //                }
    //            }
                
                
                ZStack {
                    GeometryReader { geometry in
                        DoneView {
                            withAnimation {
                                //self.users = self.setList()
                                viewModel.requestSwipeList(sortType: .Latest) { success in
                                    if success {
                                        //
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        
                        
                        ForEach(Array(viewModel.swipeList.enumerated()), id: \.offset) { index, card in
                            
                            // Range Operator
                            if (self.maxID - 3)...self.maxID ~= (card.customId ?? 0) {
                                //let _ = fLog("로그확인::: maxID : \(maxID)")
                                //let _ = fLog("로그확인::: minID : \(minID)")
                                //let _ = fLog("로그확인::: index : \(index)")
                                //let _ = fLog("로그확인::: item : \(viewModel.swipeList[index].KOREAN ?? "Empty")")
                                
                                SwipeView(
                                    card: card,
                                    speechSynthesizer: speechSynthesizer,
                                    onRemove: { likeType in
                                        withAnimation { removeProfile(card)
                                        }
                                        
                                        onLike(card, type: likeType)
                                    },
                                    isTapLikeBtn: { cardIdx, isLike in
                                        //fLog("idpil::: 좋아요클릭 cardIdx:\(cardIdx), isLike:\(isLike)")
                                        
                                        // 좋아요 취소 요청 -> false -> 0
                                        // 좋아요 요청 -> true -> 1
                                        viewModel.likeCard(
                                            cardIdx: cardIdx,
                                            isLike: isLike ? 1 : 0,
                                            clickIndex: index,
                                            isSuccess: { isSuccess in
                                                if isSuccess {
                                                    //fLog("idpil::: 좋아요 성공!!!")
                                                } else {
                                                    //fLog("idpil::: 좋아요 실패!!!")
                                                }
                                                
                                            })
                                    },
                                    isTapMoreBtn: {
                                        DefineBottomSheet.commonMore(
                                            type: CommonMore.SwipeCardMore(isUserBlock: (card.isUserBlock ?? false), isCardBlock: (card.isCardBlock ?? false))
                                        )
                                        
                                        bottomSheetManager.show.swipeCardMore = true
                                    },
                                    isLastCard: index==(maxID-1) ? true : false
                                )
                                //MARK: 책 쌓아놓은 것 같은 효과
                                //.animation(.spring())
                                .frame(
                                    width: self.getCardWidth(geometry, id: (card.customId ?? 0)) - 50, // 50: 좌-우 여백
                                    height: geometry.size.height * 0.7
                                )
                                .offset(
                                    x: 0,
                                    y: self.getCardOffset(geometry, id: (card.customId ?? 0))
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .opacity(self.isShowRandomCardShuffle ? 0 : 1)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
//                        randomCardShuffleView
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                            //.opacity(self.isShowRandomCardShuffle ? 1 : 0)
                        
                        
                        ForEach(Array(self.randomCardList.enumerated()), id: \.offset) { index, card in
                            SwipeView(
                                card: card,
                                speechSynthesizer: speechSynthesizer,
                                onRemove: { _ in},
                                isTapLikeBtn: { _, _ in},
                                isTapMoreBtn: {},
                                isLastCard: false
                            )
                            .frame(
                                height: geometry.size.height * 0.7
                            )
                            .padding(.horizontal, self.randomCardPadding(index: index))
                            //                                        .offset(
                            //                                            x: 0,
                            //                                            y: self.getCardOffset(geometry, id: (card.customId ?? 0))
                            //                                        )
                            .rotationEffect(.degrees(randomCardRotationDegrees[index]))
                            .offset(randomCardOffsets[index])
                            .animation(.easeInOut(duration: 0.3), value: randomCardRotationDegrees[index])
                            .animation(.easeInOut(duration: 0.3), value: randomCardOffsets[index])
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                        .opacity(self.isShowRandomCardShuffle ? 1 : 0)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                }
                .opacity(viewModel.swipeList.count>0 ? 1 : 0)
                
                HStack(spacing: 15) {
                    Text("\(maxID) / \(Int(viewModel.countOfSwipeList))")
                        .font(.buttons1420Medium)
                        .foregroundColor(Color.gray850)
                    
                    CircleProgressBarView(
                        width: 50,
                        height: 50,
                        color1: Color.blue,
                        color2: Color.blue.opacity(0.3),
                        percent: $curPercent
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 20)
                .padding(.trailing, 20)
            }
            
            if self.isShowGrammarInfo {
                grammarInfoView
            }
            
            if self.isShowMainCategoryListView {
                mainCategoryListView
            }
        }
        .task {
            if viewModel.mainCategoryList.count>0 && viewModel.subCategoryList.count>0 {
                // 카테고리별 영어문장 조회
                viewModel.requestSwipeListByCategory(
                    category: viewModel.subCategoryList[viewModel.categoryTabIndex], // 첫 카테고리로 시작
                    sortType: .Latest,
                    isSuccess: { success in
                        //
                    }
                )
            } else {
                viewModel.requestMainCategory() { isSuccess in
                    if isSuccess {
                        if viewModel.mainCategoryList.count > 0 {
                            
                            if self.selectedMainCategoryItem.isEmpty {
                                self.selectedMainCategoryItem = viewModel.mainCategoryList[0]
                            }
                            
                            viewModel.requestCategory(
                                isInit: true,
                                category: self.selectedMainCategoryItem
                            ) { isSuccess in
                                if isSuccess {
                                    //
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .onChange(of: maxID) {
            //fLog("idpil::: currentID : \(currentID)")
            //fLog("idpil::: 현재:\(viewModel.swipeList[currentID-1].korean ?? "")")
            
            // currentID == 0 -> 카드를 모두 넘긴 경우.
            if maxID == 0 {
                curPercent = 100.0
                
                // [예외처리] 서브 카테고리 마지막인 경우, 더이상 넘어갈 스텝이 없음
                if viewModel.categoryTabIndex != viewModel.subCategoryList.count-1 {
                    // 다음 스탭으로 넘어감
                    viewModel.categoryTabIndex += 1
                    viewModel.moveCategoryTab = true
                }
            }
            // currentID > 0 -> 카드를 넘기고 있는 경우
            else {
                currentCardIndex = getCurrentIndexOfList(_maxID: maxID)
                
                curPercent = calculatePercentage(
                    value: Double(currentCardIndex),
                    percentageVal: viewModel.countOfSwipeList
                )
                
                //let _ = fLog("idpil::: 백분율 : \(getCurrentIndexOfList(_maxID: currentID))")
                //let _ = fLog("idpil::: 퍼센트 : \(curPercent)")
            }
        }
        .onChange(of: bottomSheetManager.pressedCardMorType) {
            
            switch bottomSheetManager.pressedCardMorType {
            case .Report:
                // 한 번 호출했으면 더 이상 가져오지 않음
                if DefineBottomSheet.reportListItems.count > 0 {
                    bottomSheetManager.show.swipeCardReport = true
                }
                else if DefineBottomSheet.reportListItems.count == 0 {
                    viewModel.requestReportList(isSuccess: { list, isSuccess in
                        if isSuccess {
                            DefineBottomSheet.reportListItems = list
                            
                            bottomSheetManager.show.swipeCardReport = true
                        }
                    })
                }
            case .BoardBlock:
                viewModel.blockCard(cardIdx: 5, isBlock: 1) { isSuccess in
                    if isSuccess {
                        fLog("idpil::: 카드차단 성공 :)")
                    }
                }
            case .UserBlock:
                viewModel.blockUser(targetUid: "ppppppp", isBlock: 1) { isSuccess in
                    if isSuccess {
                        fLog("idpil::: 유저차단 성공 :)")
                    }
                }
            default:
                fLog("")
            }
            
            // 다른 카드에서 같은 아이템 클릭할 수 있으니 초기화시킴
            bottomSheetManager.pressedCardMorType = .None
        }
        .onChange(of: bottomSheetManager.pressedCardReportCode) {
            if bottomSheetManager.pressedCardReportCode != -1 {
                //fLog("idpil::: 신고하기 누른 코드값 : \(bottomSheetManager.pressedCardReportCode)")
                
                viewModel.reportCard(
                    targetUid: "qqqqqqq",
                    targetCardIdx: 100,
                    reportCode: bottomSheetManager.pressedCardReportCode
                ) { isSuccess in
                    if isSuccess {
                        //
                    }
                }
            }
            
            // 다른 카드에서 같은 아이템 클릭할 수 있으니 초기화시킴
            bottomSheetManager.pressedCardReportCode = -1
        }
        .onChange(of: viewModel.noti_selectedMainCategoryName) {
            self.selectedMainCategoryItem = viewModel.noti_selectedMainCategoryName
        }
        .onChange(of: self.selectedMainCategoryItem) {
            viewModel.requestCategory(
                isInit: true,
                category: self.selectedMainCategoryItem
            ) { isSuccess in
                if isSuccess {
                    viewModel.moveCategoryTab = true
                    
                    viewModel.isNotificationCenter = false // 초기화
                }
            }
        }
        .onChange(of: bottomSheetManager.pressedCardCutPercent) {
            let tmpArr = viewModel.swipeList
            if viewModel.sliceArray(tmpArr, by: bottomSheetManager.pressedCardCutPercent).isEmpty {
                UserManager.shared.showCardCutError = true
            } else {
                StatusManager.shared.loadingStatus = .ShowWithTouchable
                
                // 로딩되는거 보여주려고 딜레이시킴
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.cutSwipeList(percent: bottomSheetManager.pressedCardCutPercent)
                    StatusManager.shared.loadingStatus = .Close
                }
            }
        }
    }

    var mainCategoryButton: some View {
        HStack(spacing: 0) {
            Text(self.selectedMainCategoryItem)
                .font(.buttons1420Medium)
                .foregroundColor(.gray800)
            
            Image("icon_outline_dropdown")
                .resizable()
                .renderingMode(.template)
                .frame(width: 13, height: 13)
                .foregroundColor(.gray800)
                .rotationEffect(.degrees(self.isShowMainCategoryButtonAnimation ? 360 : 270), anchor: .center)
                .padding(.leading, 5)
        }
        //.frame(minWidth: 70)
        .frame(height: 40)
        .padding(.horizontal, 15)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray850.opacity(1), lineWidth: 1))
        .background(Capsule().fill(Color.gray25))
        .padding(.vertical, 10)
        .padding(.leading, 20)
        .padding(.trailing, 5)
        .onTapGesture {
            self.isShowMainCategoryListView.toggle()
            withAnimation {
                self.isShowMainCategoryButtonAnimation.toggle()
            }
        }
    }
    
    var subCategoryTabView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    
                    if viewModel.subCategoryList.count > 0 {
                        ForEach(Array(viewModel.subCategoryList.enumerated()), id: \.offset) { index, element in
                            let isSelected = viewModel.categoryTabIndex == index
                            
                            VStack(spacing: 0) {
                                Text(element)
                                    .font(viewModel.categoryTabIndex==index ? .buttons1420Medium : .body21420Regular)
                                    .foregroundColor(viewModel.categoryTabIndex==index ? Color.gray25 : Color.gray850)
                                    .frame(minWidth: 70)
                                    .frame(height: 40)
                                    .padding(.horizontal, 15)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(isSelected
                                                                                      ? Color.gray850
                                                                                      : Color.gray199.opacity(1), lineWidth: 1))
                                    .background(Capsule().fill(isSelected
                                                                                       ? Color.gray850
                                                                                       : Color.gray25))
                                    .padding(.vertical, 10)
                                    //.shadow(color: Color.shadowColor, radius: 3, x: 0, y: 1)
                                    // (주의!).onTapGesture 호출하는 위치에 따라서 클릭 감도 차이남
                                    .onTapGesture {
                                        
                                        /**
                                         * 카테고리 버튼 클릭했을 때,
                                         * 왜 -1 을 해줘야 제대로 동작하는거지?????
                                         *
                                         */
                                        viewModel.categoryTabIndex = index
                                        
                                        scrollToElement(with: proxy)
//                                        withAnimation {
//                                            proxy.scrollTo(index, anchor: .top)
//                                        }
                                        
                                        
                                            viewModel.requestSwipeListByCategory(
                                            category: element,
                                            sortType: .Latest,
                                            isSuccess: { success in
                                                //
                                            }
                                        )
                                        
                                        
                                        
        //                                    scrollToTopAimated.toggle()
        //                                    moveToTopIndicator.toggle()
        //                                    callRemoteData()
                                        
                                        
                                        
                                        //viewModel.resetSwipeList(category: element)
                                        
                                    }
                                    .onChange(of: viewModel.moveCategoryTab) {
                                        if viewModel.moveCategoryTab {
                                            
                                            scrollToElement(with: proxy)
                                            
//                                            withAnimation {
//                                                proxy.scrollTo(viewModel.categoryTabIndex, anchor: .top)
//                                            }
                                            
                                            //viewModel.resetSwipeList(category: viewModel.topTabBarList[clickedSubTabIndex])
                                            
                                            
                                            viewModel.requestSwipeListByCategory(
                                                category: viewModel.subCategoryList[viewModel.categoryTabIndex],
                                                sortType: .Latest,
                                                isSuccess: { success in
                                                }
                                            )
                                            
                                            viewModel.moveCategoryTab = false // 초기화
                                        }
                                        
                                        
                                    }
                                    .id(index)
                            }
                            .padding(.leading, index==0 ? 20 : 10)
                            .padding(.trailing, (index==viewModel.subCategoryList.count-1) ? 20 : 0)
                            
                        }
                    }
                }
            }
        }
    }
    
    var grammarInfoView: some View {
        VStack(spacing: 0) {
            Button(action: {
                self.isShowGrammarInfo = false
            }, label: {
                Image(systemName: "xmark")
                    .padding(5).background(Color.gray25) // 클릭 영역 확장
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 5))
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 첫 번째만 (padding 값이 다름)
                    Group {
                        if let title = viewModel.grammarInfo?.step1_title,
                           let content = viewModel.grammarInfo?.step1_content {
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, 20)
                            
                            /**
                             * 카테고리 글자에서 잘바꿈 하려고 중간에 개행문자(\n)를 입력해 놨다.
                             * 문제는 값을 가져오면 \\n로 내려온다. 그래서 아래와 같이 변경해준다.
                             * 원인) DB에서는 \n 을 \\n 으로 저장한다고 함.
                             */
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray850)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                    }
                    .textSelection(.enabled)
                    
                    Group {
                        if let title = viewModel.grammarInfo?.step2_title,
                           let content = viewModel.grammarInfo?.step2_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step3_title,
                           let content = viewModel.grammarInfo?.step3_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step4_title,
                           let content = viewModel.grammarInfo?.step4_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step5_title,
                           let content = viewModel.grammarInfo?.step5_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step6_title,
                           let content = viewModel.grammarInfo?.step6_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step7_title,
                           let content = viewModel.grammarInfo?.step7_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step8_title,
                           let content = viewModel.grammarInfo?.step8_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step9_title,
                           let content = viewModel.grammarInfo?.step9_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step10_title,
                           let content = viewModel.grammarInfo?.step10_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step11_title,
                           let content = viewModel.grammarInfo?.step11_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step12_title,
                           let content = viewModel.grammarInfo?.step12_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step13_title,
                           let content = viewModel.grammarInfo?.step13_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step14_title,
                           let content = viewModel.grammarInfo?.step14_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step15_title,
                           let content = viewModel.grammarInfo?.step15_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step16_title,
                           let content = viewModel.grammarInfo?.step16_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step17_title,
                           let content = viewModel.grammarInfo?.step17_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step18_title,
                           let content = viewModel.grammarInfo?.step18_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step19_title,
                           let content = viewModel.grammarInfo?.step19_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                        
                        if let title = viewModel.grammarInfo?.step20_title,
                           let content = viewModel.grammarInfo?.step20_content{
                            Text(title)
                                .font(sizeInfo.grammarTextFont_title)
                                .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                            
                            Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                            .font(sizeInfo.grammarTextFont_content)
                            .foregroundColor(sizeInfo.grammarTextFontColor_content)
                            .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                        }
                    }
                    .textSelection(.enabled)
                }
            }
            .onAppear {
                // TabHomePage 에서 ScrollView bounces false로 설정했기 때문에, 여기서 다시 true로 설정해줘야 됨
                UIScrollView.appearance().bounces = true
            }
            .padding(.horizontal, 10)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20).fill(Color.gray25)
                    //.padding(5)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
            )
        }
        .padding(20)
        .background(Color.gray25.opacity(0.1111111111111111)) // 배경 클릭 안 되게 하기 위해 설정 (화면에는 안 보임)
    }
    
    var emptyBubbleShapeView: some View {
        CustomBubbleShape(
            tailWidth: 10,
            tailHeight: 5,
            tailPosition: 0.2,
            tailDirection: .up,
            tailOffset: 0
        )
        .fill(Color.red)
        .frame(width: 195, height: 35)
        .overlay(
            HStack(spacing: 5) {
                Group {
                    Text("지금 다른 주제도 확인해보세요!")
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
                .font(.caption11218Regular)
                .foregroundColor(.gray25)
            }
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 15, y: 50)
    }
    
    var mainCategoryListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(viewModel.mainCategoryList.enumerated()), id: \.offset) { index, element in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 10, height: 10)
                            .foregroundColor(.primaryDefault)
                            .opacity(element == self.selectedMainCategoryItem ? 1 : 0)
                        
                        Text(element)
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray700)
                    }
                    .frame(maxWidth: 150, alignment: .leading)
                    .background(Color.gray25) // 빈 공간 클릭 가능하게 함
                    .padding(.top, (index == 0) ? 20 : 10)
                    .padding(.bottom, (index == viewModel.mainCategoryList.count-1) ? 20 : 0)
                    .padding(.leading, 20)
                    .onTapGesture {
                        self.selectedMainCategoryItem = element
                        
                        self.isShowMainCategoryListView.toggle()
                        withAnimation {
                            self.isShowMainCategoryButtonAnimation.toggle()
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20).fill(Color.gray25)
                    .padding(5)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
            )
            //.padding(EdgeInsets(top: 60, leading: 20, bottom: 0, trailing: 0))
            
            
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        //.background(Color.green.opacity(0.3))
        .background(Color.gray25.opacity(0.1111111111111111)) // 배경 클릭을 위해 설정 (화면에는 안 보임)
        .onTapGesture {
            self.isShowMainCategoryListView.toggle()
            withAnimation {
                self.isShowMainCategoryButtonAnimation.toggle()
            }
        }
        .offset(x: 13, y: 55) // 위 padding으로 뷰 간격 조정하면 안 됨 .background(Color.green.opacity(0.3)) 주석 해제해서 확인해보면, 여전히 화면 공간을 모두 차지하고 있기 때문에, mainCategoryButton 뷰 클릭이 되지 않음. 그래서 offset 으로 뷰 위치를 이동시킨 것.
    }
    
    var randomCardShuffleView: some View {
        ZStack {
            ForEach(0..<4) { index in
                Rectangle()
                    .fill(randomCardColors[index])
                    .stroke(Color.yellow, lineWidth: 2.0)
                    .padding(100)
                    //.frame(width: 200, height: 300)
                // 회전과 위치 이동을 적용합니다.
                    .rotationEffect(.degrees(randomCardRotationDegrees[index]))
                    .offset(randomCardOffsets[index])
                    .animation(.easeInOut(duration: 0.5), value: randomCardRotationDegrees[index])
                    .animation(.easeInOut(duration: 0.5), value: randomCardOffsets[index])
            }
        }
    }
    
    /**
     * ScrollViewReader proxy 값을 받아서, ScrollView 특정 위치로 이동하는 함수
     * ViewModel에서도 사용하기 때문에 함수로 묶었다.
     * 구현한 방법은 ChatGPT 한테 물어봤음. 짱임.
     * "Tell me how to accept a scrollviewreader as a parameter value for a function in swiftui."
     */
    func scrollToElement(with proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(viewModel.categoryTabIndex, anchor: .top)
        }
    }
    
}

extension TabSwipeCardPage {
    //MARK: 뷰 레이아웃 효과
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat((viewModel.swipeList.count-1) - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(viewModel.swipeList.count - 1 - id) * 10
    }
    
    private var maxID: Int {
        //return viewModel.swipeList.map { $0.id }.max() ?? 0
        return viewModel.swipeList.map { ($0.customId ?? 0) }.max() ?? 0
    }
    
    private var minID: Int {
        return viewModel.swipeList.map { ($0.customId ?? 0) }.min() ?? 0
    }
    
    func onLike(_ card: SwipeDataList, type likeType: LikeType) {
        switch likeType {
        case .like:
            print("You liked \(card.korean)")
        case .dislike:
            print("You disliked \(card.korean)")
        case .superlike:
            print("You super-liked \(card.korean)")
        }
    }
    
    //Calucate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        // 300의 4는 몇 %?  == (100 * 4) / 300
        let val = 100.0 * value
        return val / percentageVal
    }
    
    public func getCurrentIndexOfList(_maxID: Int) -> Int {
        //fLog("idpil::: 111 : \(viewModel.fixedSwipeList.count)")
        //fLog("idpil::: 1111 : \(viewModel.swipeList.count)")
        
        // 처음(fixedSwipeList.count == swipeList.count) 한 번만,
        // 퍼센트 계산용 배열(cardPercentArr)에 초기화로 저장
        // swipeList는 카드 넘기면서 하나씩 제거됨. 그래서 사용하면 안 됨.
        if viewModel.percentCountSwipeList.count == viewModel.swipeList.count {
            viewModel.cardPercentArr = viewModel.swipeList
        }
        
        var copyArr = viewModel.percentCountSwipeList
        copyArr = copyArr.reversed()
        
        let resultArr = viewModel.cardPercentArr
            .enumerated() // 배열의 인덱스 가져오기 위해 사용
            .map { (index, element) -> Bool in
                //fLog("idpil::: 여기\(index), \(element)")
                // 참고) _maxID > 0 이여야 됨.
                return element.korean == copyArr[_maxID-1].korean
            }
        //fLog("idpil::: resultArr : \(resultArr)")
        //fLog("idpil::: 현재 인덱스:\(resultArr.firstIndex(of: true) ?? -1)")
        return resultArr.firstIndex(of: true) ?? -1
    }
    
    func removeProfile(_ card: SwipeDataList) {
        guard let index = viewModel.swipeList.firstIndex(of: card) else { return }

        viewModel.swipeList.remove(at: index)
    }
    
    
    
    
    // 네 개의 Rectangle 뷰가 각기 다른 방향으로 이동하고 회전하는 애니메이션 기능
    private func doShuffleRandomCard() {
        // 버튼을 누를 때마다 각 뷰의 회전 방향과 위치를 업데이트합니다.
        for index in randomCardRotationDegrees.indices {
            randomCardRotationDegrees[index] += index % 2 == 0 ? 180 : -180
            // 위치 이동을 결정합니다. 각 뷰가 사방으로 100만큼 이동합니다.
            switch index {
            case 0:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index0RandomCardOffset ? CGSize(width: 0, height: -200) : sizeInfo.index0RandomCardOffset
            case 1:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index1RandomCardOffset ? CGSize(width: 0, height: 200) : sizeInfo.index1RandomCardOffset
            case 2:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index2RandomCardOffset ? CGSize(width: -200, height: 0) : sizeInfo.index2RandomCardOffset
            case 3:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index3RandomCardOffset ? CGSize(width: 200, height: 0) : sizeInfo.index3RandomCardOffset
            default:
                break
            }
        }
    }
    
    private func randomCardPadding(index: Int) -> CGFloat {
        switch index {
        case 0:
            return 15.0
        case 1:
            return 10.0
        case 2:
            return 5.0
        case 3:
            return 0.0
        default:
            return 0.0
        }
    }
    
    private func setRandomCardList(result: @escaping(() -> Void)) {
        //fLog("idpil::: \(viewModel.swipeList[viewModel.swipeList.count-1].korean ?? "")")
        
        self.randomCardList = []
        let tmpList = viewModel.swipeList
        
        // 맨 위에서 보이는 카드가 리스트의 마지막 아이템이다.
        // 그래서 랜덤카드 리스트의 마지막과 원래카드 리스트의 마지막을 맞춘다.
        // 서로 맞추는 이유는 '랜덤 애니메이션 시작 시' 맨 위에서 보이는 카드가 움직이는 것 처럼 보이기 위해.
        self.randomCardList.append(tmpList[tmpList.count-4])
        self.randomCardList.append(tmpList[tmpList.count-3])
        self.randomCardList.append(tmpList[tmpList.count-2])
        self.randomCardList.append(tmpList[tmpList.count-1])
        
        // 0.1초 동안 멈추는 이유 :
        // result 클로저를 이용해서 randomCardList 배열이 완전히 데이터 세팅이 된 이후에 애니메이션 실행하도록 했는데도 최초 실행시 뷰가 이상하게 보이는 문제가 발생했다. (swipe 한 뒤 이전 텍스트가 보임)
        // 0.1초 뒤에 애니메이션 실행하면 이 문제가 없어졌기 때문에 넣은 것. 정확한 이유는 모르겠음.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            result()
        }
    }
}

private struct DoneView: View {
    let reload: () -> Void
    var body: some View {
        VStack {
            Text("You've filled in all the cards!")

            Button("Refresh") {
                reload()
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    TabSwipeCardPage()
}
