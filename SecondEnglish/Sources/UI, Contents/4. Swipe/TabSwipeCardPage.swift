//
//  TabSwipeCardPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import AVFoundation
import AVKit
import Combine
import SDWebImageSwiftUI

struct TabSwipeCardPage {
    @StateObject var viewModel = SwipeCardViewModel.shared
    @StateObject var userManager = UserManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject private var speechManager = SpeechSynthesizerManager()
    
    @State private var isShowMainCategoryButtonAnimation = false
    @State private var isShowMainCategoryListView = false
    @State private var currentCardIndex: Int = 0
    @State private var curPercent: Double = 0.0
    @State private var clickCardItem: SwipeDataList?
    @State private var isShowDoneView: Bool = false
    @AppStorage(DefineKey.mainCategoryName) var selectedMainCategoryItem: String = ""
    
    // TTS
    @State var isFrontSpeaking: Bool = false
    @State var isBackSpeaking: Bool = false
    
    
    // 자동 모드
    @State private var isAutoPlay: Bool = false
    @State private var isTopViewSwipe: Bool = false
    // 자동 모드 타이머
    @Environment(\.scenePhase) var scenePhase
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    private let seconds: Double = 3.0
    @State private var topCard: SwipeDataList? = nil
    @State var isRootViewFlipped: Bool = false
    @State private var isForceSwipe: Bool = false // 자동모드 중에 강제로 카드 넘긴 경우
    
    
    
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
    
    // Main.swift에서 자동모드 중지시킴
    @Binding var isAutoModeStop: Bool
    
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
    
    init(isAutoModeStop: Binding<Bool>) {
        // 자동 모드일 때, 3초 마다 카드 넘김
        self._timer = .init(initialValue: Timer.publish(every: seconds, on: .main, in: .common))
        self._isAutoModeStop = isAutoModeStop
    }
}

extension TabSwipeCardPage: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    header
                    
                    subCategoryTabView
                }
                .background(Color.primaryDefault)
                .onTapGesture {
                    if isShowMainCategoryListView {
                        isShowMainCategoryListView = false
                        withAnimation {
                            isShowMainCategoryButtonAnimation = false
                        }
                    }
                }
                
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
                
                VStack(spacing: 0) {
                    ZStack {
                        GeometryReader { geometry in
                            
                            // 각 메인 카테고리 끝가지 학습한 경우, 결과 View 보여주기
                            if isShowDoneView {
                                DoneView {
                                    withAnimation {
                                        //self.users = self.setList()
//                                        viewModel.requestSwipeList(sortType: .Latest) { success in
//                                            if success {
//                                                //
//                                            }
//                                        }
                                    }
                                }
                            }
                            
                            
                            if viewModel.swipeList.count > 0 {
                                ForEach(Array(viewModel.swipeList.enumerated()), id: \.offset) { index, card in
                                    
                                    self.setTopCard(index: index, card: card)
                                    
                                    // Range Operator
                                    if (self.maxID - 3)...self.maxID ~= (card.customId ?? 0) {
                                        //let _ = fLog("로그확인::: maxID : \(maxID)")
                                        //let _ = fLog("로그확인::: minID : \(minID)")
                                        //let _ = fLog("로그확인::: index : \(index)")
                                        //let _ = fLog("로그확인::: item : \(viewModel.swipeList[index].KOREAN ?? "Empty")")
                                        
                                        
                                        
                                        // 자동모드에서 offset 설정해야 하는데, SwipeView()에서 이미 offset 설정을 하고 있기 때문에 VStack으로 감싸준다.
                                        VStack(spacing: 0) {
                                            SwipeView(
                                                card: card,
                                                onRemove: { likeType in
                                                    
                                                    
                                                    /// isRootViewFlipped : 카드 뒤집는 변수
                                                    ///
                                                    /// '한글 카드'에서 Swipe하면, 다음 카드도 한글을 보여줘야 하기 때문에 isRootViewFlipped 값을 변경할 필요가 없다.
                                                    /// 하지만 '영어 카드'에서 Swipe하면, 다음 카드는 한글이 보여야 하기 때문에 isRootViewFlipped 값을 한글이 보이게 false로 만들어줘야 됨.
                                                    isRootViewFlipped = false
                                                    
                                                    // 자동모드 TTS 재생 중에 강제로 카드 넘김
                                                    if isAutoPlay {
                                                        fLog("idpil::: 카드 강제로 넘김")
                                                        fLog("idpil::: speechManager.isSpeaking : \(speechManager.isSpeaking)")
                                                        
                                                        if speechManager.isSpeaking {
                                                            speechManager.stopSpeaking()
                                                        }
                                                        isForceSwipe = true
                                                    }
                                                    
                                                    withAnimation {
                                                        removeProfile(card)
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
                                                    
                                                    self.clickCardItem = card
                                                },
                                                isLastCard: index==(maxID-1) ? true : false,
                                                isTapFrontSpeakBtn: {
                                                    if !isAutoPlay {
                                                        if !speechManager.isSpeaking {
                                                            if let card = self.topCard {
                                                                speechManager.speak(card.korean ?? "")
                                                            }
                                                        }
                                                    }
                                                },
                                                isTapBackSpeakBtn: {
                                                    if !isAutoPlay {
                                                        if !speechManager.isSpeaking {
                                                            if let card = self.topCard {
                                                                speechManager.speak(card.english ?? "")
                                                            }
                                                        }
                                                    }
                                                },
                                                isTapCard: {
                                                    withAnimation(.easeIn(duration: 0.2)) {
                                                        isRootViewFlipped.toggle()
                                                    }
                                                },
                                                isFrontSpeaking: isFrontSpeaking,
                                                isBackSpeaking: isBackSpeaking,
                                                isAutoPlay: isAutoPlay,
                                                isRootViewFlipped: $isRootViewFlipped
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
                                        .rotationEffect(
                                            isTopViewSwipe
                                            ?
                                            (
                                                // 맨 위 카드만 적용
                                                index==(maxID-1)
                                                ?
                                                .degrees(-180)
                                                :
                                                .degrees(0)
                                            )
                                            :
                                            .degrees(0)
                                        )
                                        .offset(
                                            isTopViewSwipe
                                            ?
                                            (
                                                // 맨 위 카드만 적용
                                                index==(maxID-1)
                                                ?
                                                CGSize(width: -DefineSize.Screen.Width, height: 100)
                                                :
                                                CGSize(width: 0, height: 0)
                                            )
                                            :
                                            CGSize(width: 0, height: 0)
                                        )
                                        .animation(
                                            .easeInOut(duration: 0.3),
                                            value:
                                                isTopViewSwipe
                                                ?
                                                (
                                                    // 맨 위 카드만 적용
                                                    index==(maxID-1)
                                                    ?
                                                    -180
                                                    :
                                                    0
                                                )
                                                :
                                                0
                                        )
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .opacity(self.isShowRandomCardShuffle ? 0 : 1)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                //MARK: - 카드 랜덤 섞기 뷰
        //                        randomCardShuffleView
        //                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        //                            //.opacity(self.isShowRandomCardShuffle ? 1 : 0)
                                ForEach(Array(self.randomCardList.enumerated()), id: \.offset) { index, card in
                                    SwipeView(
                                        card: card,
                                        onRemove: { _ in},
                                        isTapLikeBtn: { _, _ in},
                                        isTapMoreBtn: {},
                                        isLastCard: false,
                                        isTapFrontSpeakBtn: {
                                            //
                                        },
                                        isTapBackSpeakBtn: {
                                            //
                                        },
                                        isTapCard: {
                                            //
                                        },
                                        isFrontSpeaking: false,
                                        isBackSpeaking: false,
                                        isAutoPlay: false,
                                        isRootViewFlipped: .constant(false)
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
                    }
                    
                    //MARK: - 하단 뷰 모음
                    // 각 메인 카테고리 끝가지 학습한 경우, 더이상 카드가 없기 때문에 보여지지 않음
                    if !isShowDoneView {
                        HStack(spacing: 15) {
                            if !isAutoPlay {
                                Button(action: {
                                    bottomSheetManager.show.swipeCardCut = true
                                }, label: {
                                    Image(systemName: "scissors")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .foregroundColor(Color.primaryDefault)
                                        .padding(7).background(Color.gray25) // 클릭 잘 되도록
                                })
                                
                                Button(action: {
                                    if viewModel.swipeList.count < 4 {
                                        userManager.showCardShuffleError = true
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
                                        .foregroundColor(Color.primaryDefault)
                                        .frame(height: 20)
                                        .padding(7).background(Color.gray25) // 클릭 잘 되도록
                                })
                                
                                Button(action: {
                                    // 카드를 하나라도 넘긴 경우에만 호출함
                                    if viewModel.swipeList.count < viewModel.fixedSwipeList_0.count {
                                        StatusManager.shared.loadingStatus = .ShowWithTouchable
                                        
                                        self.resetPage() {
                                            StatusManager.shared.loadingStatus = .Close
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color.primaryDefault)
                                        .frame(height: 20)
                                        .padding(7).background(Color.gray25) // 클릭 잘 되도록
                                })
                            }
                            
                            Spacer()
                            
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
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                    }
                }
                .overlay(Color.gray25.opacity(isShowMainCategoryListView ? 0.111111111111111111111111111 : 0.0))
                .onTapGesture {
                    if isShowMainCategoryListView {
                        isShowMainCategoryListView = false
                        withAnimation {
                            isShowMainCategoryButtonAnimation = false
                        }
                    }
                }
            }
            
            if self.isShowMainCategoryListView {
                mainCategoryListView
            }
        }
        .onAppear {
            if !viewModel.isFirst {
                viewModel.isFirst = true
                
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
                                    
                                    // 카테고리별 영어문장 데이터
                                    if viewModel.subCategoryList.count > 0 {
                                        // 카테고리별 영어문장 조회
                                        viewModel.requestSwipeListByCategory(
                                            main_category: self.selectedMainCategoryItem,
                                            sub_category: viewModel.subCategoryList[viewModel.categoryTabIndex],
                                            sortType: .Latest,
                                            isSuccess: { success in
                                                //
                                            }
                                        )
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .onDisappear {
            if isAutoPlay {
                //stopTimer()
                stopAutoMode()
                isAutoPlay = false
            }
        }
        .onChange(of: isAutoModeStop) {
            if isAutoModeStop {
                if isAutoPlay {
                    //stopTimer()
                    stopAutoMode()
                    isAutoPlay = false
                }
                
                isAutoModeStop = false // 초기화
            }
        }
        .onChange(of: maxID) {
//            fLog("idpil::: maxID : \(maxID)")
//            fLog("idpil::: 현재:\(topCard?.korean ?? "")")
            
            // currentID == 0 -> 카드를 모두 넘긴 경우.
            if maxID == 0 {
                curPercent = 100.0
                
                // [예외처리] 서브 카테고리 마지막인 경우, 더이상 넘어갈 스텝이 없음
                if viewModel.categoryTabIndex != viewModel.subCategoryList.count-1 {
                    // 다음 스탭으로 넘어감
                    isShowDoneView = false
                    viewModel.categoryTabIndex += 1
                    viewModel.moveCategoryTab = true
                }
                // 서브 카테고리 다 넘겼음
                else if viewModel.categoryTabIndex == viewModel.subCategoryList.count-1 {
                    withAnimation {
                        isShowDoneView = true
                    }
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
                if let item = self.clickCardItem {
                    viewModel.blockUser(
                        targetUid: item.uid ?? "",
                        targetNickname: item.user_name ?? "",
                        isBlock: item.isUserBlock ?? false
                    ) { isSuccess in
                        if isSuccess {
                            fLog("idpil::: 유저차단 성공 :)")
                        }
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
            
            // DoneView 보이고 있으면 숨김
            self.hideDoneView()
            
            viewModel.requestCategory(
                isInit: true,
                category: self.selectedMainCategoryItem
            ) { isSuccess in
                if isSuccess {
                    
                    // 카테고리별 영어문장 데이터
                    if viewModel.subCategoryList.count > 0 {
                        // 카테고리별 영어문장 조회
                        viewModel.requestSwipeListByCategory(
                            main_category: self.selectedMainCategoryItem,
                            sub_category: viewModel.subCategoryList[viewModel.categoryTabIndex],
                            sortType: .Latest,
                            isSuccess: { success in
                                viewModel.moveCategoryTab = true
                                
                                viewModel.isNotificationCenter = false // 초기화
                            }
                        )
                    }
                }
            }
        }
        .onChange(of: bottomSheetManager.pressedCardCutItem) {
            let tmpArr = viewModel.swipeList
            var percent: CGFloat = 0.0
            var sortType: SwipeCardCutSortType = .None
            
            if bottomSheetManager.pressedCardCutItem != .None {
                switch bottomSheetManager.pressedCardCutItem {
                case SwipeCardCutType.Front_30:
                    // 30% 앞에서부터 자르기
                    percent = 0.7
                    sortType = .FrontCut
                case SwipeCardCutType.Front_50:
                    // 50% 앞에서부터 자르기
                    percent = 0.5
                    sortType = .FrontCut
                case SwipeCardCutType.Front_70:
                    // 70% 앞에서부터 자르기
                    percent = 0.3
                    sortType = .FrontCut
                case SwipeCardCutType.Back_30:
                    // 30% 뒤에서부터 자르기
                    percent = 0.7
                    sortType = .BackCut
                case SwipeCardCutType.Back_50:
                    // 50% 뒤에서부터 자르기
                    percent = 0.5
                    sortType = .BackCut
                case SwipeCardCutType.Back_70:
                    // 70% 뒤에서부터 자르기
                    percent = 0.3
                    sortType = .BackCut
                case SwipeCardCutType.Random_30:
                    // 30% 랜덤 자르기
                    percent = 0.7
                    sortType = .RandomCut
                case SwipeCardCutType.Random_50:
                    // 50% 랜덤 자르기
                    percent = 0.5
                    sortType = .RandomCut
                case SwipeCardCutType.Random_70:
                    // 70% 랜덤 자르기
                    percent = 0.3
                    sortType = .RandomCut
                default:
                    fLog("")
                }
                
                if viewModel.sliceArray(tmpArr, by: percent, sortType: sortType).isEmpty {
                    userManager.showCardCutError = true
                }
                else {
                    StatusManager.shared.loadingStatus = .ShowWithTouchable
                    
                    // 로딩되는거 보여주려고 딜레이시킴
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.cutSwipeList(percent: percent, sortType: sortType)
                        StatusManager.shared.loadingStatus = .Close
                        
                        bottomSheetManager.pressedCardCutItem = .None // 동일한 아이템 클릭될 수 있도록 초기화
                    }
                }
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                if isAutoPlay {
                    startTimer()
                }
            case .background, .inactive:
                stopTimer()
            default:
                break
            }
        }
        // 자동 모드
        .onChange(of: isAutoPlay) {
            
            /**
             * 자동 모드 후보 1 (타이머 작동시켜 3초 간격으로 넘어가게 하는 방식)
             */
//            if isAutoPlay {
//                startTimer()
//            } else {
//                stopTimer()
//            }
            
            
            /**
             * 자동 모드 후보 2
             */
            if isAutoPlay {
                startAutoMode()
            } else {
                stopAutoMode()
            }
        }
        .onReceive(timer) { _ in
            //fLog("idpil::: timer 호출")
            
            if isAutoPlay {
                if let card = self.topCard {
                    isTopViewSwipe = true
                    
                    // 애니메이션 0.3초 동안 진행되기 때문에, 0.3초 후에 실행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // 맨 위에 있는 카드 제거
                        removeProfile(card) { isDone in
                            if isDone {
                                isTopViewSwipe = false
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: speechManager.isSpeaking) {
            
            // TTS 재생 중
            if speechManager.isSpeaking {
                // 한글 카드가 보이고 있는 상태 (한글 문장 읽어 주기 완료)
                if !isRootViewFlipped {
                    isFrontSpeaking = true
                }
                // 영어 카드가 보이고 있는 상태 (영어 문장 읽어 주기 완료)
                else {
                    isBackSpeaking = true
                }
            }
            // TTS 재생 완료
            else {
                if isAutoPlay {
                    /// 자동모드 음성 재생 중에, 강제로 카드를 넘긴 경우
                    /// 1. 다음 카드는 한글이 보여지니 isRootViewFlipped 값은 무조건 false 이다.
                    /// 2. isForceSwipe 값이 true 이다.
                    /// 3. 한글 음성 재생한다.
                    
                    // 한글 카드가 보이고 있는 상태 (한글 문장 읽어 주기 완료)
                    if !isRootViewFlipped {
                        if isForceSwipe {
                            // 한글 문장 읽어주기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if !speechManager.isSpeaking {
                                    if let card = self.topCard {
                                        speechManager.speak(card.korean ?? "")
                                    }
                                }
                            }
                            isFrontSpeaking = true
                            
                            
                            
                           isForceSwipe = false // 초기화
                        }
                        else {
                            isFrontSpeaking = false
                            
                            // 카드 뒤집어서 영어 문장 보여주기
                            withAnimation(.easeIn(duration: 0.2)) {
                                isRootViewFlipped = true
                            }
                            
                            // 영어 문장 읽어주기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if !speechManager.isSpeaking {
                                    if let card = self.topCard {
                                        speechManager.speak(card.english ?? "")
                                    }
                                }
                            }
                        }
                    }
                    // 영어 카드가 보이고 있는 상태 (영어 문장 읽어 주기 완료)
                    else {
                        isBackSpeaking = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.swipeTopCard() {
                                // 카드 넘겨짐 -> 자동모드인 경우 반복 실행
                                if isAutoPlay {
                                    startAutoMode()
                                }
                            }
                        }
                    }
                }
                // !isAutoPlay 이면
                // 1. 자동모드 아닌 상태에서 카드 TTS 재생 완료한 경우
                // 2. 자동모드를 중간에 멈춘 경우.
                else {
                    // 한글 카드가 보이고 있는 상태 (한글 문장 읽어 주기 완료)
                    if !isRootViewFlipped {
                        isFrontSpeaking = false
                    }
                    // 영어 카드가 보이고 있는 상태 (영어 문장 읽어 주기 완료)
                    else {
                        isBackSpeaking = false
                    }
                }
            }
        }
        
    }

    var header: some View {
        HStack(spacing: 10) {
            mainCategoryButton
            
            if !isAutoPlay {
                Button(action: {
                    // 메인 카테고리 리스트 뷰가 띄워져 있으면 닫는다.
                    if isMainCategoryListViewClose() {
                        withAnimation {
                            bottomSheetManager.show.grammarInfo = true
                        }
                    }
                }, label: {
                    Image("icon_help")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray25)
                        .overlay(
                            Text("Help")
                                .font(.caption31013Regular).fontWeight(.semibold)
                                .foregroundColor(.primaryDefault)
                                .padding(.bottom, 5)
                        )
                })
            }
            
            Spacer()
            
            if isAutoPlay {
                AnimatedImage(name: "auto_mode.gif")
                    .resizable()
                    .aspectRatio(contentMode: .fit).frame(height: 40)
            }
            
            Button(action: {
                isAutoPlay.toggle()
            }, label: {
                Image(systemName: isAutoPlay ? "autostartstop.slash" : "autostartstop")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit).frame(height: 25)
                    .foregroundColor(.gray25)
                    .padding(7).background(Color.primaryDefault) // 클릭 잘 되도록
                    .padding(.trailing, 20)
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var mainCategoryButton: some View {
        HStack(spacing: 0) {
            Text(self.selectedMainCategoryItem)
                .font(.buttons1420Medium)
                .foregroundColor(.gray25)
            
            Image("icon_outline_dropdown")
                .resizable()
                .renderingMode(.template)
                .frame(width: 13, height: 13)
                .foregroundColor(.gray25)
                .rotationEffect(.degrees(self.isShowMainCategoryButtonAnimation ? 360 : 270), anchor: .center)
                .padding(.leading, 5)
        }
        //.frame(minWidth: 70)
        .frame(height: 40)
        .padding(.horizontal, 15)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray25.opacity(1), lineWidth: 1))
        .background(Capsule().fill(Color.primaryDefault))
        .padding(.vertical, 10)
        .padding(.leading, 20)
        .padding(.trailing, 5)
        .onTapGesture {
            if isAutoPlay {
                userManager.showCardAutoModeError = true
            }
            else {
                self.isShowMainCategoryListView.toggle()
                withAnimation {
                    self.isShowMainCategoryButtonAnimation.toggle()
                }
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
                                    .font(.title5Roboto1622Medium).fontWeight(.semibold)
                                    .foregroundColor(viewModel.categoryTabIndex==index ? Color.gray25 : Color.gray300)
//                                    .background(
//                                        VStack(spacing: 0) {
//                                            Spacer()
//                                            Rectangle()
//                                                .offset(y: 10) // 텍스트 세로 길이 맨 아래에서, 10만큼 더 내려가서 보이기 위해 설정.
//                                                .fill(Color.gray25)
//                                                .frame(height: 3)
//                                                .opacity(isSelected ? 1.0 : 0.0)
//                                        }
//                                    )
                                    .padding(EdgeInsets(top: 20, leading: 5, bottom: 15, trailing: 5)).background(Color.primaryDefault) // 클릭 감도 올림
                                    .onTapGesture {
                                        // DoneView 보이고 있으면 숨김
                                        self.hideDoneView()
                                        
                                        // 메인 카테고리 리스트 뷰가 띄워져 있으면 닫는다.
                                        if isMainCategoryListViewClose() {
                                            
                                            viewModel.categoryTabIndex = index
                                            
                                            scrollToElement(with: proxy)
    //                                        withAnimation {
    //                                            proxy.scrollTo(index, anchor: .top)
    //                                        }
                                            
                                            viewModel.requestSwipeListByCategory(
                                                main_category: self.selectedMainCategoryItem,
                                                sub_category: element,
                                                sortType: .Latest,
                                                isSuccess: { success in
                                                    
                                                    if isAutoPlay {
                                                        /// isRootViewFlipped : 카드 뒤집는 변수
                                                        ///
                                                        /// 만약 '영어 카드'가 보이고 있는 상태에서 카테고리 탭 누른 경우, 한글 카드가 보여야 하기 때문에 isRootViewFlipped 값을 한글이 보이게 false로 만들어줘야 됨.
                                                        isRootViewFlipped = false
                                                        
                                                        if speechManager.isSpeaking {
                                                            speechManager.stopSpeaking()
                                                        }
                                                        
                                                        isForceSwipe = true
                                                    }
                                                    
                                                }
                                            )
                                            
            //                                    scrollToTopAimated.toggle()
            //                                    moveToTopIndicator.toggle()
            //                                    callRemoteData()
                                            
                                            
                                            
                                            //viewModel.resetSwipeList(category: element)
                                        }
                                    }
                                    .onChange(of: viewModel.moveCategoryTab) {
                                        if viewModel.moveCategoryTab {
                                            
                                            scrollToElement(with: proxy)
                                            
//                                            withAnimation {
//                                                proxy.scrollTo(viewModel.categoryTabIndex, anchor: .top)
//                                            }
                                            
                                            //viewModel.resetSwipeList(category: viewModel.topTabBarList[clickedSubTabIndex])
                                            
                                            
                                            viewModel.requestSwipeListByCategory(
                                                main_category: self.selectedMainCategoryItem,
                                                sub_category: viewModel.subCategoryList[viewModel.categoryTabIndex],
                                                sortType: .Latest,
                                                isSuccess: { success in
                                                }
                                            )
                                            
                                            viewModel.moveCategoryTab = false // 초기화
                                        }
                                        
                                        
                                    }
                                    .id(index)
                                
                                Rectangle()
                                    //.offset(y: 10) // 텍스트 세로 길이 맨 아래에서, 10만큼 더 내려가서 보이기 위해 설정.
                                    .fill(Color.gray25)
                                    .frame(height: 3)
                                    .opacity(isSelected ? 1.0 : 0.0)
                            }
                            .padding(.leading, index==0 ? 20 : 15)
                            .padding(.trailing, (index==viewModel.subCategoryList.count-1) ? 20 : 0)
                            
                        }
                    }
                }
            }
        }
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
                    .frame(width: 150, alignment: .leading)
                    .background(Color.gray25) // 빈 공간 클릭 가능하게 함
                    .padding(.top, (index == 0) ? 20 : 10)
                    .padding(.bottom, (index == viewModel.mainCategoryList.count-1) ? 20 : 0)
                    .padding(.leading, 10)
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
                    .shadow(color: .gray500.opacity(0.5), radius: 3, x: 0, y: 0)
            )
            .padding(5) // 배경 그림자 잘리기 않도록 패딩값 설정
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, alignment: .topLeading)
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
    
    private func setTopCard(index: Int, card: SwipeDataList) -> some View {
        if index==(maxID-1) {
            //fLog("idpil::: topCard : \(card.korean ?? "")")
            self.topCard = card
        }
        
        return EmptyView()
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
    
    private func onLike(_ card: SwipeDataList, type likeType: LikeType) {
        switch likeType {
        case .like:
            fLog("You liked \(card.korean ?? "")")
        case .dislike:
            fLog("You disliked \(card.korean ?? "")")
        case .superlike:
            fLog("You super-liked \(card.korean ?? "")")
        }
    }
    
    //Calucate percentage based on given values
    private func calculatePercentage(value:Double,percentageVal:Double)->Double{
        // 300의 4는 몇 %?  == (100 * 4) / 300
        let val = 100.0 * value
        return val / percentageVal
    }
    
    private func getCurrentIndexOfList(_maxID: Int) -> Int {
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
    
    private func removeProfile(_ card: SwipeDataList, isDone: (Bool)->Void = {_ in}) {
        guard let index = viewModel.swipeList.firstIndex(of: card) else { return }
        
        viewModel.swipeList.remove(at: index)
        
        isDone(true)
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
    
    private func resetPage(isDone: @escaping() -> Void = {}) {
        
        // 변수 초기화
        currentCardIndex = 0
        curPercent = 0.0
        
        
        // api call
        viewModel.requestMainCategory() { isSuccess in
            if isSuccess {
                if viewModel.mainCategoryList.count > 0 {
                    
                    if self.selectedMainCategoryItem.isEmpty {
                        self.selectedMainCategoryItem = viewModel.mainCategoryList[0]
                    }
                    
                    viewModel.requestCategory(
                        isInit: false,
                        category: self.selectedMainCategoryItem
                    ) { isSuccess in
                        if isSuccess {
                            
                            // 카테고리별 영어문장 데이터
                            if viewModel.subCategoryList.count > 0 {
                                // 카테고리별 영어문장 조회
                                viewModel.requestSwipeListByCategory(
                                    main_category: self.selectedMainCategoryItem,
                                    sub_category: viewModel.subCategoryList[viewModel.categoryTabIndex],
                                    sortType: .Latest,
                                    isSuccess: { success in
                                        if success {
                                            isDone()
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    // 메인 카테고리 리스트 뷰가 띄워져 있으면 닫는다.
    private func isMainCategoryListViewClose() -> Bool {
        if isShowMainCategoryListView {
            
            isShowMainCategoryListView = false
            withAnimation {
                isShowMainCategoryButtonAnimation = false
            }
            
            return false
        } else {
            
            return true
        }
    }
    
    private func startTimer() {
        guard cancellable == nil else {
            return
        }
        timer = Timer.publish(every: seconds, on: .main, in: .common)
        cancellable = timer.connect()
    }
    
    private func stopTimer() {
        guard cancellable != nil else {
            return
        }
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func startAutoMode() {
        // 영어 카드가 보이고 있는 상태
        // 1. 영어 문장 읽어주기
        // 2. 카드 넘김
        if isRootViewFlipped {
            // 영어 문장 읽어주기
            if !speechManager.isSpeaking {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let card = self.topCard {
                        speechManager.speak(card.english ?? "")
                    }
                }
            }
        }
        // 한글 카드가 보이고 있는 상태
        // 1. 한글 문장 읽어주기
        // 2. 카드 뒤집어서 영어 문장 보여주기
        // 3. 영어 문장 읽어주기
        // 4. 카드 넘김
        else {
            // 한글 문장 읽어주기
            if !speechManager.isSpeaking {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let card = self.topCard {
                        speechManager.speak(card.korean ?? "")
                    }
                }
            }
        }
    }
    
    private func stopAutoMode() {
        speechManager.stopSpeaking()
    }
    
    private func swipeTopCard(isFinish: @escaping()->Void={}) {
        if let card = self.topCard {
            // Swipe 왼쪽으로 애니메이션 시작
            isTopViewSwipe = true
            
            // Swipe 애니메이션 시작과 동시에 맨 위에 있는 카드를 뒤집어야,
            // 아래 맨 위에 있는 카드를 제거했을 때 보이는 다음 카드가 한글로 보임.
            isRootViewFlipped = false
            
            // 애니메이션 0.3초 동안 진행되기 때문에, 0.3초 후에 실행
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // 맨 위에 있는 카드 제거
                removeProfile(card) { isDone in
                    if isDone {
                        isTopViewSwipe = false
                        
                        isFinish()
                    }
                }
            }
        }
    }
    
    // DoneView 보이고 있으면 숨김
    private func hideDoneView() {
        if isShowDoneView {
            isShowDoneView = false
        }
    }
}
