//
//  TabHomePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct TabHomePage {
    @StateObject var viewModel = TabHomeViewModel.shared
    @StateObject var swipeTabViewModel = SwipeCardViewModel.shared
    @StateObject var userManager = UserManager.shared
    
    // 상단 탭뷰
    var tabtype: TabMainType
    var tabs: [TabMain]
    @Binding var moveToTopIndicator: Bool
    @Binding var isShowEditorView: Bool
    @State private var selectedTab: Int = 0
    
    @State private var myLikeTabHeaderIndex: Int = 0
    @State private var myLikeCardIndex: Int = 0
    @State private var myLikeIsAutoPlay: Bool = false
    
    @State private var myPostTabHeaderIndex: Int = 0
    @State private var myPostCardIndex: Int = 0
    @State private var myPostIsAutoPlay: Bool = false
    
    @State private var isReadyToShowMyPostList: Bool = false
    @State private var isReadyToShowMyLikeList: Bool = false
    
    // Pull To Refresh
    @Environment(\.refresh) private var refresh
    @State private var isCurrentlyRefreshing = false
    let amountToPullBeforeRefreshing: CGFloat = 180
    
    private struct sizeInfo {
        static let CarouselViewHeight: CGFloat = 300
    }
    
    init(tabtype: TabMainType, tabs: [TabMain], moveToTopIndicator: Binding<Bool>, isShowEditorView: Binding<Bool>) {
        self.tabtype = tabtype
        self.tabs = tabs
        self._moveToTopIndicator = moveToTopIndicator
        self._isShowEditorView = isShowEditorView
    }
}

extension TabHomePage: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                header
                
                ScrollViewReader { scrollviewReader in
                    ScrollView {
                        if isCurrentlyRefreshing {
                            ProgressView()
                                .padding(.vertical, 5)
                        }
                        
                        VStack(spacing: 0) {
                            
                            if tabtype == .vOne {
                                TabsV1(tabs: tabs, geoWidth: geometry.size.width, tabtype: tabtype, selectedTab: $selectedTab)
                                
                                if selectedTab == 0 {
                                    // 여기를 LazyVStack으로 감싸면, 스크롤 내렸다가 다시 올렸을 때 이전 위치 보장이 안 됨. 그래서 VStack으로 감싸야 됨.
                                    myPostCardList
                                }
                                else if selectedTab == 1 {
                                    // 여기를 LazyVStack으로 감싸면, 스크롤 내렸다가 다시 올렸을 때 이전 위치 보장이 안 됨. 그래서 VStack으로 감싸야 됨.
                                    myLikeCardList
                                }

                                // Views
    //                            TabView(selection: $selectedTab,
    //                                    content: {
    //                                SubHome(moveToTopIndicator: $moveToTopIndicator)
    //                                    .tag(0)
    //                                SubPopular(moveToTopIndicator: $moveToTopIndicator)
    //                                    .tag(1)
    //                            })
    //                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }
                            else if tabtype == .vTwo {
                                TabsV2(tabs: tabs, geoWidth: geometry.size.width, tabtype: tabtype, selectedTab: $selectedTab)

                                // Views
    //                            TabView(selection: $selectedTab,
    //                                    content: {
    //                                SubHome(moveToTopIndicator: $moveToTopIndicator)
    //                                    .tag(0)
    //                                SubPopular(moveToTopIndicator: $moveToTopIndicator)
    //                                    .tag(1)
    //                                SubCommunity()
    //                                    .tag(2)
    //                            })
    //                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }
                            
                            
                            
    //                        if viewModel.categoryList.count > 0 {
    //                            //tabBarView
    //
    //                            // 여기를 LazyVStack으로 감싸면, 스크롤 내렸다가 다시 올렸을 때 이전 위치 보장이 안 됨. 그래서 VStack으로 감싸야 됨.
    //                            myFavoriteCardList
    //                                .padding(.top, 20)
    //                                .padding(.bottom, 20)
    //                        } else {
    //                            emptyView
    //                        }
                            
                            
                            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                                ForEach(Array(viewModel.myLearningProgressList.enumerated()), id: \.offset) { index, item in
                                    
                                    Section {
                                        /**
                                         * [주의]
                                         * VStack 으로 감싸지 않으면 데이터가 모두다 로딩되지 않는 문제가 있음.
                                         */
                                        VStack(spacing: 0) {
                                            ForEach((Array(item.sub_category_list.enumerated())), id: \.offset) { subIndex, subItem in
                                                
                                                MyProgressCellView(
                                                    main_category_index: index,
                                                    sub_category_index: subIndex,
                                                    sub_category: subItem.sub_category,
                                                    main_category: item.main_category,
                                                    like_number: subItem.like_number,
                                                    today_new_count: subItem.today_new_count,
                                                    category_sentence_count: subItem.category_sentence_count
                                                )
                                            }
                                        }
                                        .background(Color.gray25)
                                        .clipShape(
                                            RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 5)
                                        )
                                        //.padding(.horizontal, 10)
                                        .padding(.bottom, index==viewModel.myLearningProgressList.count-1 ? 20 : 15)
                                    } header: {
                                        MyProgressHeaderView(
                                            isLike: item.isLike ?? false,
                                            main_category: item.main_category,
                                            index: index
                                        )
                                        .clipShape(
                                            RoundedCornersShape(corners: [.topLeft, .topRight], radius: 5)
                                        )
                                        //.padding(.horizontal, 10)
                                    }
                                    
                                }
                            }
                        }
                        // the geometry proxy allows us to detect how far on the list we have scrolled
                        // and will update the ViewOffsetKey once the "if" conditions are met
                        .overlay(GeometryReader { geo in
                            if userManager.isLogin {
                                let currentScrollViewPosition = -geo.frame(in: .global).origin.y
                                
                                if currentScrollViewPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                                    Color.clear.preference(key: HomePageViewOffsetKey.self, value: -geo.frame(in: .global).origin.y)
                                }
                            }
                        })
                    }
                    // onPreferenceChange :
                    // 'Pull To Refresh Method' 실행할 시기를 알기 위해, ViewOffsetKey 변경 감지.
                    .onPreferenceChange(HomePageViewOffsetKey.self) { scrollPosition in
                        if scrollPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                            isCurrentlyRefreshing = true
                            Task {
                                // 로딩을 0.5초 동안 보여줌
                                //await refreshData()
                                
                                await MainActor.run {
                                    // 카테고리별 진도확인 리스트 조회
                                    viewModel.requestMyCategoryProgress()
                                    
                                    if selectedTab == 0 {
                                        viewModel.requestMyPostCardList(isSuccess: { success in
                                            isCurrentlyRefreshing = false
                                            isReadyToShowMyPostList = true
                                        })
                                    }
                                    else if selectedTab == 1 {
                                        viewModel.requestMyLikeCardList() {
                                            isCurrentlyRefreshing = false
                                            isReadyToShowMyLikeList = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
    //            .onAppear(perform: {
    //                //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
    //                /**
    //                 * ScrollView bounce 비활성하는 이유 : 스크롤뷰 bounce되면 좋아요한 배너 리스트 넘길 때, 잘 안 넘겨짐.
    //                 */
    //                UIScrollView.appearance().bounces = false
    //            })
                
            }
        }
        .background(Color.bgLightGray50)
        .onAppear {
            // 앱 실행 후 처음 한 번 만 호출함
            if !viewModel.isFirst {
                viewModel.isFirst = true
                if userManager.isLogin {
                    viewModel.requestMyCategoryProgress()
                }
            }
        }
        .onChange(of: userManager.isLogin) {
            // [홈탭 -> 로그인뷰 띄움 -> 로그인 성공(로그인뷰 닫음)]
            if userManager.isLogin {
                if selectedTab == 0 {
                    viewModel.requestMyPostCardList(isSuccess: { success in
                        isReadyToShowMyPostList = true
                    })
                }
                else if selectedTab == 1 {
                    viewModel.requestMyLikeCardList() {
                        isReadyToShowMyLikeList = true
                    }
                }
                viewModel.requestMyCategoryProgress()
            }
        }
        .onChange(of: userManager.isLookAround) {
            // [홈탭 -> 로그인뷰 띄움 -> 둘러보기 선택(로그인뷰 닫음)]
            if userManager.isLookAround {
                viewModel.requestGuestCategoryProgress()
            }
        }
        
    }
    
    var header: some View {
        HStack(spacing: 0) {
            Image("text_logo")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit).frame(height: 20)
                .foregroundColor(.gray25)
                .frame(maxWidth: .infinity, alignment: .leading)
            
//            Button {
//                //NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
//            } label: {
//                Image("icon_outline_alarm new")
//                    .resizable()
//                    .renderingMode(.template)
//                    .frame(width: 27, height: 27)
//                    .foregroundColor(.gray25)
//            }
            
            Button {
                NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
            } label: {
                Image("icon_top_menu")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 27, height: 27)
                    .foregroundColor(.gray25)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(Color.stateActivePrimaryDefault)
        //.background(Color.gray25)
    }
    
    var myLikeCategoryListView: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.myLikeCardCategoryList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(spacing: 0) {
                            Text(element.type3 ?? "")
                                .font(myLikeTabHeaderIndex==index ? .title51622Medium : .caption11218Regular)
                                .foregroundColor(myLikeTabHeaderIndex==index ? Color.primaryDefault : Color.primaryDefault.opacity(0.5))
                                //.frame(minWidth: 70)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                                .onChange(of: myLikeCardIndex) {
                                    
                                    /**
                                     * "Index out of range"에러 방지
                                     * 에러 발생하는 경우 (무한 회전기능 예외처리를 안 해주면 발생함)
                                     * 1. cardBannerCurrentIndex 값이 -1로 오면 발생함
                                     * 2. 'viewModel.sentenceList.count-1'값이 24일 때, cardBannerCurrentIndex 값이 25로 오면 발생함
                                     */
                                    if myLikeCardIndex != -1 &&
                                        myLikeCardIndex != viewModel.myLikeCardList.count {
//                                        fLog("idpil::: viewModel.sentenceList.count : \(viewModel.sentenceList.count)")
//                                        fLog("idpil::: viewModel.sentenceList.count-1 : \(viewModel.sentenceList.count-1)")
//                                        fLog("idpil::: cardBannerCurrentIndex : \(cardBannerCurrentIndex)")
//                                        fLog("idpil::: index : \(index)")
                                        
//                                        fLog("idpil::: 카드 korean : \(viewModel.sentenceList[cardBannerCurrentIndex].korean ?? "")")
//                                        fLog("idpil::: type3 : \(viewModel.sentenceList[cardBannerCurrentIndex].type3 ?? "")")
//                                        fLog("idpil::: element : \(element)")
                                        
                                        /**
                                         * 서브카테고리(type3)는  중복되는 이름이 있기 때문에,
                                         * type3_sort_num 기준으로 매칭확인을 해야한다.
                                         */
                                        if (element.type3_sort_num ?? 0) == (viewModel.myLikeCardList[myLikeCardIndex].type3_sort_num ?? 0) {
                                            myLikeTabHeaderIndex = index
                                            withAnimation {
                                                scrollviewReader.scrollTo(index, anchor: .top)
                                            }
                                        }
                                    }
                                }
                                //.id(index)
                        }
                        .padding(EdgeInsets(
                            top: 10,
                            leading: index==0 ? 20 : 10,
                            bottom: 0,
                            trailing: (index==viewModel.myLikeCardCategoryList.count-1) ? 20 : 0
                        ))
                    }
                }
            }
            .scrollDisabled(true)

        }
    }
    
    var myPostCategoryListView: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.myPostCardCategoryList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(spacing: 0) {
                            Text(element.type3 ?? "")
                                .font(myPostTabHeaderIndex==index ? .title51622Medium : .caption11218Regular)
                                .foregroundColor(myPostTabHeaderIndex==index ? Color.primaryDefault : Color.primaryDefault.opacity(0.5))
                                //.frame(minWidth: 70)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                                .onChange(of: myPostCardIndex) {
                                    
                                    /**
                                     * "Index out of range"에러 방지
                                     * 에러 발생하는 경우 (무한 회전기능 예외처리를 안 해주면 발생함)
                                     * 1. cardBannerCurrentIndex 값이 -1로 오면 발생함
                                     * 2. 'viewModel.sentenceList.count-1'값이 24일 때, cardBannerCurrentIndex 값이 25로 오면 발생함
                                     */
                                    if myPostCardIndex != -1 &&
                                        myPostCardIndex != viewModel.myPostCardList.count {
//                                        fLog("idpil::: viewModel.sentenceList.count : \(viewModel.sentenceList.count)")
//                                        fLog("idpil::: viewModel.sentenceList.count-1 : \(viewModel.sentenceList.count-1)")
//                                        fLog("idpil::: cardBannerCurrentIndex : \(cardBannerCurrentIndex)")
//                                        fLog("idpil::: index : \(index)")
                                        
//                                        fLog("idpil::: 카드 korean : \(viewModel.sentenceList[cardBannerCurrentIndex].korean ?? "")")
//                                        fLog("idpil::: type3 : \(viewModel.sentenceList[cardBannerCurrentIndex].type3 ?? "")")
//                                        fLog("idpil::: element : \(element)")
                                        
                                        /**
                                         * 서브카테고리(type3)는  중복되는 이름이 있기 때문에,
                                         * type3_sort_num 기준으로 매칭확인을 해야한다.
                                         */
                                        if (element.type3_sort_num ?? 0) == (viewModel.myPostCardList[myPostCardIndex].type3_sort_num ?? 0) {
                                            myPostTabHeaderIndex = index
                                            withAnimation {
                                                scrollviewReader.scrollTo(index, anchor: .top)
                                            }
                                        }
                                    }
                                }
                                //.id(index)
                        }
                        .padding(EdgeInsets(
                            top: 10,
                            leading: index==0 ? 20 : 10,
                            bottom: 0,
                            trailing: (index==viewModel.myPostCardCategoryList.count-1) ? 20 : 0
                        ))
                    }
                }
            }
            .scrollDisabled(true)

        }
    }
    
    
    var myLikeEmptyView: some View {
        VStack(spacing: 0) {
            Image("like_empty")
                .resizable()
                .frame(width: 200, height: 200)
            
            
            Text("se_mylike_empty_title".localized)
                .font(.title32028Bold)
                .foregroundColor(.gray800)
                .padding(.top, 5)
            
            Text("se_mylike_empty_content".localized)
                .font(.caption11218Regular)
                .foregroundColor(.gray500)
                .padding(.top, 7)
            
            
            Button(action: {
                if userManager.isLogin {
                    // Swipe Tab 으로 이동
                    LandingManager.shared.showSwipePage = true
                }
                else {
                    userManager.showLoginAlert = true
                }
            }, label: {
                Text("se_mylike_empty_button".localized)
                    .font(.title5Roboto1622Medium)
                    .foregroundColor(Color.gray25)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Capsule().fill(Color.stateActivePrimaryDefault))
            })
            .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
            .padding(.vertical, 30)
        }
        .frame(maxWidth: .infinity)
        //.background(RoundedRectangle(cornerRadius: 20).fill(Color.gray25))
        .background(Color.bgLightGray50)
    }
    
    var myPostEmptyView: some View {
        VStack(spacing: 0) {
            Image("like_empty")
                .resizable()
                .frame(width: 200, height: 200)
            
            
            Text("se_mypost_empty_title".localized)
                .font(.title32028Bold)
                .foregroundColor(.gray800)
                .padding(.top, 5)
            
            Text("se_mypost_empty_content".localized)
                .font(.caption11218Regular)
                .foregroundColor(.gray500)
                .padding(.top, 7)
            
            
            Button(action: {
                if userManager.isLogin {
                    // Main.swift에서 EditorPage() 띄움
                    isShowEditorView = true
                }
                else {
                    userManager.showLoginAlert = true
                }
            }, label: {
                Text("se_mypost_empty_button".localized)
                    .font(.title5Roboto1622Medium)
                    .foregroundColor(Color.gray25)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Capsule().fill(Color.stateActivePrimaryDefault))
            })
            .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
            .padding(.vertical, 30)
        }
        .frame(maxWidth: .infinity)
        //.background(RoundedRectangle(cornerRadius: 20).fill(Color.gray25))
        .background(Color.bgLightGray50)
    }
    
    var myPostCardList: some View {
        VStack(spacing: 0) {
            if userManager.isLogin {
                if isReadyToShowMyPostList {
                    if viewModel.myPostCardCategoryList.count > 0 {
                        //tabBarView
                        ZStack {
                            InfiniteCarousel(
                                data: viewModel.myPostCardList,
                                height: sizeInfo.CarouselViewHeight,
                                cornerRadius: 0,
                                transition: .scale,
                                returnIndex: { index, isMoveFirst, isMoveLast in
                                    //fLog("idpil::: isMoveFirst : \(isMoveFirst) / isMoveLast : \(isMoveLast)")
                //                    if isMoveFirst {
                //                        fLog("idpil::: 무한루프 시작점")
                //                    }
                //                    else if isMoveLast {
                //                        fLog("idpil::: 무한루프 끝점")
                //                    }
                                    
                                    /**
                                     * InfiniteCarousel() 에서 '무한루프'를 위해 인덱스는 1부터 시작한다.
                                     * 그래서 -1을 해준 뒤 저장해준다.
                                     */
                                    self.myPostCardIndex = index-1
                                },
                                isAutoPlay: myPostIsAutoPlay,
                                content: { item in
                                    TabHomeCardView(
                                        item: item,
                                        cardWidth: .infinity,
                                        cardHeight: 150,
                                        isAutoPlay: myPostIsAutoPlay
                                    )
                                }
                            )
                            
                            
                            // 오토모드에서는 TabView 스크롤 제스처 안 되도록 막는다.
                            // TabView 스크롤 엄청 빨리 했을 때, categoryList 이랑 싱크 안 맞는 경우가 생긴다.
                            // 싱크 안 맞는 현상의 원인은 오토모드에서 TabView 전환할 때 0.3초 뒤에 관련 데이터가 설정되는데, 빨리 넘기면 당연히 싱크가 안 맞을 수 밖에 없음.
        //                    if isAutoPlay {
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .fill(Color.stateActivePrimaryDefault.opacity(0.1111111111111111111))
        //                            .frame(maxWidth: .infinity)
        //                            .frame(height: 150)
        //                            .padding(40)
        //                    }
                            
                            
                            myPostCategoryListView
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            
                            ZStack {
                                Text("\(myPostCardIndex+1) / \(viewModel.myPostCardList.count)")
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray500)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                HStack(spacing: 10) {
                                    if myPostIsAutoPlay {
                                        AnimatedImage(name: "auto_mode2.gif")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit).frame(height: 40)
                                    }
                                    
                                    Button(action: {
                                        myPostIsAutoPlay.toggle()
                                    }, label: {
                                        Image(systemName: myPostIsAutoPlay ? "autostartstop.slash" : "autostartstop")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.primaryDefault)
                                            .padding(5).background(Color.bgLightGray50) // 클릭 잘 되도록
                                    })
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 10)
                        }
                        .background(Color.bgLightGray50)
        //                .background(
        //                    Image("home_bg_02")
        //                        .resizable()
        //                        .frame(height: sizeInfo.CarouselViewHeight).aspectRatio(contentMode: .fill) // 높이 크기에 맞게 이미지 꽉 채움
        //                        //.overlay(Color.primaryDefault.opacity(0.6))
        //                )
                    } else {
                        myPostEmptyView
                    }
                }
            }
            else {
                myPostEmptyView
            }
        }
        .onAppear {
            if userManager.isLogin && viewModel.myPostCardCategoryList.isEmpty {
                viewModel.requestMyPostCardList(isSuccess: { success in
                    isReadyToShowMyPostList = true
                })
            }
        }
    }
    
    var myLikeCardList: some View {
        VStack(spacing: 0) {
            if userManager.isLogin {
                if isReadyToShowMyLikeList {
                    if viewModel.myLikeCardCategoryList.count > 0 {
                        //tabBarView
                        ZStack {
                            InfiniteCarousel(
                                data: viewModel.myLikeCardList,
                                height: sizeInfo.CarouselViewHeight,
                                cornerRadius: 0,
                                transition: .scale,
                                returnIndex: { index, isMoveFirst, isMoveLast in
                                    //fLog("idpil::: isMoveFirst : \(isMoveFirst) / isMoveLast : \(isMoveLast)")
                //                    if isMoveFirst {
                //                        fLog("idpil::: 무한루프 시작점")
                //                    }
                //                    else if isMoveLast {
                //                        fLog("idpil::: 무한루프 끝점")
                //                    }
                                    
                                    /**
                                     * InfiniteCarousel() 에서 '무한루프'를 위해 인덱스는 1부터 시작한다.
                                     * 그래서 -1을 해준 뒤 저장해준다.
                                     */
                                    self.myLikeCardIndex = index-1
                                },
                                isAutoPlay: myLikeIsAutoPlay,
                                content: { item in
                                    TabHomeCardView(
                                        item: item,
                                        cardWidth: .infinity,
                                        cardHeight: 150,
                                        isAutoPlay: myLikeIsAutoPlay
                                    )
                                }
                            )
                            
                            
                            // 오토모드에서는 TabView 스크롤 제스처 안 되도록 막는다.
                            // TabView 스크롤 엄청 빨리 했을 때, categoryList 이랑 싱크 안 맞는 경우가 생긴다.
                            // 싱크 안 맞는 현상의 원인은 오토모드에서 TabView 전환할 때 0.3초 뒤에 관련 데이터가 설정되는데, 빨리 넘기면 당연히 싱크가 안 맞을 수 밖에 없음.
        //                    if isAutoPlay {
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .fill(Color.stateActivePrimaryDefault.opacity(0.1111111111111111111))
        //                            .frame(maxWidth: .infinity)
        //                            .frame(height: 150)
        //                            .padding(40)
        //                    }
                            
                            
                            myLikeCategoryListView
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            
                            ZStack {
                                Text("\(myLikeCardIndex+1) / \(viewModel.myLikeCardList.count)")
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray500)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                HStack(spacing: 10) {
                                    if myLikeIsAutoPlay {
                                        AnimatedImage(name: "auto_mode2.gif")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit).frame(height: 40)
                                    }
                                    
                                    Button(action: {
                                        myLikeIsAutoPlay.toggle()
                                    }, label: {
                                        Image(systemName: myLikeIsAutoPlay ? "autostartstop.slash" : "autostartstop")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.primaryDefault)
                                            .padding(5).background(Color.bgLightGray50) // 클릭 잘 되도록
                                    })
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                                
                                
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 10)
                        }
                        .background(Color.bgLightGray50)
        //                .background(
        //                    Image("home_bg_02")
        //                        .resizable()
        //                        .frame(height: sizeInfo.CarouselViewHeight).aspectRatio(contentMode: .fill) // 높이 크기에 맞게 이미지 꽉 채움
        //                        //.overlay(Color.primaryDefault.opacity(0.6))
        //                )
                    } else {
                        myLikeEmptyView
                    }
                }
            }
            else {
                myLikeEmptyView
            }
        }
        .onAppear {
            if userManager.isLogin && viewModel.myLikeCardCategoryList.isEmpty {
                viewModel.requestMyLikeCardList() {
                    isReadyToShowMyLikeList = true
                }
            }
        }
    }
}

extension TabHomePage {
    // Pull To Refresh
    func refreshData() async {
        // do work to asyncronously refresh your data here
        //try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
    }
}

#Preview {
    TabHomePage(
        tabtype: TabMainType.vOne,
        tabs: [
            .init(title: "h_home".localized),
            .init(title: "Popular")
        ],
        moveToTopIndicator: .constant(false),
        isShowEditorView: .constant(false)
    )
}
