//
//  TabHomePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct TabHomePage {
    @StateObject var viewModel = TabHomeViewModel.shared
    @StateObject var swipeTabViewModel = SwipeCardViewModel.shared
    
    // 상단 탭뷰
    var tabtype: TabMainType
    var tabs: [TabMain]
    @Binding var moveToTopIndicator: Bool
    @State private var selectedTab: Int = 0
    
    @State private var headerTabIndex: Int = 0
    @State private var cardBannerCurrentIndex: Int = 0
    @State private var isMoveFirstHeader: Bool = false
    @State private var isMoveLastHeader: Bool = false
    @State private var isNotMainCategoryButtonClick: Bool = false
    @State private var isAutoPlay: Bool = false
    
    // Pull To Refresh
    @Environment(\.refresh) private var refresh
    @State private var isCurrentlyRefreshing = false
    let amountToPullBeforeRefreshing: CGFloat = 180
    
    private struct sizeInfo {
        static let CarouselViewHeight: CGFloat = 300
    }
    
    init(tabtype: TabMainType, tabs: [TabMain], moveToTopIndicator: Binding<Bool>) {
        self.tabtype = tabtype
        self.tabs = tabs
        self._moveToTopIndicator = moveToTopIndicator
    }
}

extension TabHomePage: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                header
                
                //MARK: - 내가 좋아요한 문장들
    //            if viewModel.categoryList.count>0 {
    //                //tabBarView
    //
    //                myFavoriteCardList
    //            }
                
                ScrollViewReader { scrollviewReader in
                    ScrollView {
                        if isCurrentlyRefreshing {
                            ProgressView()
                        }
                        
                        VStack(spacing: 0) {
                            
                            if tabtype == .vOne {
                                TabsV1(tabs: tabs, geoWidth: geometry.size.width, tabtype: tabtype, selectedTab: $selectedTab)
                                
                                if selectedTab == 0 {
                                    // 여기를 LazyVStack으로 감싸면, 스크롤 내렸다가 다시 올렸을 때 이전 위치 보장이 안 됨. 그래서 VStack으로 감싸야 됨.
                                    myFavoriteCardList
                                }
                                else if selectedTab == 1 {
                                    emptyView
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
                            let currentScrollViewPosition = -geo.frame(in: .global).origin.y
                            
                            if currentScrollViewPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                                Color.clear.preference(key: HomePageViewOffsetKey.self, value: -geo.frame(in: .global).origin.y)
                            }
                        })
                    }
                    // onPreferenceChange :
                    // 'Pull To Refresh Method' 실행할 시기를 알기 위해, ViewOffsetKey 변경 감지.
                    .onPreferenceChange(HomePageViewOffsetKey.self) { scrollPosition in
                        if scrollPosition < -amountToPullBeforeRefreshing && !isCurrentlyRefreshing {
                            isCurrentlyRefreshing = true
                            Task {
                                await refreshData()
                                await MainActor.run {
                                    isCurrentlyRefreshing = false
                                }
                            }
                        }
                    }
                    
                }
                .padding(.top, viewModel.categoryList.count==0 ? 20 : 0)
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
            if !viewModel.isFirst {
                viewModel.isFirst = true
                
                viewModel.requestMyCardList(isSuccess: { success in
                    //
                })
                
                viewModel.requestMyCategoryProgress()
            }
        }
        .onChange(of: UserManager.shared.isLogin) {
            fLog("idpil::: UserManager.shared.isLogin : \(UserManager.shared.isLogin)")
            // 여기 뷰 띄워놓고 로그인뷰를 팝업으로 띄운 다음 로그인 진행을 하기 때문에, 로그인 성공한 경우 데이터 다시 요청
            if UserManager.shared.isLogin {
                viewModel.requestMyCardList(isSuccess: { success in
                    //
                })
                
                viewModel.requestMyCategoryProgress()
            }
        }
    }
    
    var header: some View {
        HStack(spacing: 0) {
            Image("text_logo")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)
                .foregroundColor(.gray25)
            
            Spacer()
            
            Button {
                //NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
            } label: {
                Image("icon_outline_alarm new")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 27, height: 27)
                    .foregroundColor(.gray25)
            }
            
            Button {
                NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
            } label: {
                Image("icon_top_menu")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 27, height: 27)
                    .foregroundColor(.gray25)
                    .padding(.leading, 20)
            }
        }
        .padding(.horizontal, 20)
        .background(Color.stateActivePrimaryDefault)
    }
    
    var categoryListView: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.categoryList.enumerated()), id: \.offset) { index, element in
                        
                        VStack(spacing: 0) {
                            Text(element)
                                .font(headerTabIndex==index ? .title51622Medium : .caption11218Regular)
                                .foregroundColor(headerTabIndex==index ? Color.primaryDefault : Color.primaryDefault.opacity(0.5))
                                //.frame(minWidth: 70)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                            // sub 카테고리 배너가 움직일 때, 시작점 또는 끝점에서 main 카테고리 버튼 움직이게 만듬
                                .onChange(of: cardBannerCurrentIndex, initial: false) { oldValue, newValue in
                                    // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
                            
                                    // 아래 기능은 '메인 카테고리 버튼'을 움직이는 기능이기 때문에,
                                    // '메인 카테고리 버튼 클릭했을 때' 호출되면 안 됨.
                                    if isNotMainCategoryButtonClick {
                                        //fLog("idpil::: isMoveFirstHeader : \(isMoveFirstHeader)")
                                        //fLog("idpil::: isMoveLastHeader : \(isMoveLastHeader)")
                                        
                                        // 마지막 번째 카드에서, 우측으로 넘겨서 첫 번째 카드로 이동하는 경우
                                        if isMoveFirstHeader {
                                            headerTabIndex = 0
                                        }
                                        // 첫 번째 카드에서, 좌측으로 넘겨서 마지막 번째 카드로 이동하는 경우
                                        else if isMoveLastHeader {
                                            headerTabIndex = viewModel.categoryList.count-1
                                        }
                                        else {
                                            // 카드배너 왼족으로 이동
                                            if oldValue > newValue {
                                                // 앱 죽으면 안 되니까 필수!
                                                if let _ = viewModel.sentenceList[newValue].isEndPointCategory {
                                                    fLog("에러로그::: \(viewModel.sentenceList[newValue].korean ?? "")")
                                                    if viewModel.sentenceList[newValue].isEndPointCategory ?? false {
                                                        headerTabIndex -= 1
                                                    }
                                                }
                                            }
                                            // 카드배너 오른쪽으로 이동
                                            else if oldValue < newValue {
                                                // 앱 죽으면 안 되니까 필수!
                                                if let _ = viewModel.sentenceList[newValue].isStartPointCategory {
                                                    fLog("에러로그::: \(viewModel.sentenceList[newValue].korean ?? "")")
                                                    if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
                                                        
                                                        headerTabIndex += 1
                                                    }
                                                }
                                            }
                                        }
                                        
                                        withAnimation {
                                            scrollviewReader.scrollTo(headerTabIndex, anchor: .top)
                                        }
                                        
                                        isNotMainCategoryButtonClick = false // 초기화
                                    }
                                }
                                //.id(index)
                        }
                        .padding(EdgeInsets(
                            top: 10,
                            leading: index==0 ? 20 : 10,
                            bottom: 0,
                            trailing: (index==viewModel.categoryList.count-1) ? 20 : 0
                        ))
                    }
                }
            }
            .scrollDisabled(true)

        }
    }
    
    // 사용 안 함
    var tabBarView: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                if viewModel.categoryList.count>0 {
                    HStack(spacing: 0) {
                        ForEach(Array(viewModel.categoryList.enumerated()), id: \.offset) { index, element in
                            let isSelected = headerTabIndex == index
                            
                            VStack(spacing: 0) {
                                Text(element)
                                    .font(headerTabIndex==index ? .buttons1420Medium : .body21420Regular)
                                    .foregroundColor(headerTabIndex==index ? Color.gray25 : Color.gray850)
                                    .frame(minWidth: 70)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected
                                                                                      ? Color.gray850
                                                                                      : Color.gray199.opacity(1), lineWidth: 1))
                                    .background(RoundedRectangle(cornerRadius: 8).fill(isSelected
                                                                                       ? Color.gray850
                                                                                       : Color.gray25))
                                    .shadow(color: Color.shadowColor, radius: 3, x: 0, y: 1)
                                    .onTapGesture {
                                        
                                        // 카테고리 리스트 이동
                                        headerTabIndex = index
                                        withAnimation {
                                            scrollviewReader.scrollTo(index, anchor: .top)
                                        }
                                        
                                        
                                        // 클릭한 헤더 버튼의 카드 위치로 이동
                                        for (sentenceIndex, sentenceItem) in viewModel.sentenceList.enumerated() {
                                            
                                            if viewModel.categoryList[index] == (sentenceItem.type3 ?? "") {
                                                if sentenceItem.isStartPointCategory ?? false {
                                                    withAnimation {
                                                        cardBannerCurrentIndex = sentenceIndex
                                                    }
                                                }
                                            }
                                        }
                                    }
                                // sub 카테고리 배너가 움직일 때, 시작점 또는 끝점에서 main 카테고리 버튼 움직이게 만듬
                                    .onChange(of: cardBannerCurrentIndex, initial: false) { oldValue, newValue in
                                        // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
                                
                                        // 아래 기능은 '메인 카테고리 버튼'을 움직이는 기능이기 때문에,
                                        // '메인 카테고리 버튼 클릭했을 때' 호출되면 안 됨.
                                        if isNotMainCategoryButtonClick {
                                            //fLog("idpil::: isMoveFirstHeader : \(isMoveFirstHeader)")
                                            //fLog("idpil::: isMoveLastHeader : \(isMoveLastHeader)")
                                            
                                            if isMoveFirstHeader {
                                                //fLog("idpil::: 헤더 첫번째")
                                                headerTabIndex = 0
                                            }
                                            else if isMoveLastHeader {
                                                //fLog("idpil::: 헤더 마지막번째")
                                                headerTabIndex = viewModel.categoryList.count-1
                                            }
                                            else {
                                                // 카드배너 왼족으로 이동
                                                if oldValue > newValue {
                                                    if viewModel.sentenceList[newValue].isEndPointCategory ?? false {
                                                        headerTabIndex -= 1
                                                    }
                                                }
                                                // 카드배너 오른쪽으로 이동
                                                else if oldValue < newValue {
                                                    if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
                                                        
                                                        headerTabIndex += 1
                                                    }
                                                }
                                            }
                                            
                                            withAnimation {
                                                scrollviewReader.scrollTo(headerTabIndex, anchor: .top)
                                            }
                                            
                                            isNotMainCategoryButtonClick = false // 초기화
                                        }
                                    }
                                    //.id(index)
                            }
                            .padding(EdgeInsets(
                                top: 15, 
                                leading: index==0 ? 20 : 10,
                                bottom: 10,
                                trailing: (index==viewModel.categoryList.count-1) ? 20 : 0
                            ))
                        }
                    }
                }
            }
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image("like_empty")
                .resizable()
                .frame(width: 200, height: 200)
            
            
            Text("학습한 이력이 없습니다.")
                .font(.title32028Bold)
                .foregroundColor(.gray800)
                .padding(.top, 5)
            
            Text("하트를 눌러 나만의 공간을 만들어보세요 :)")
                .font(.caption11218Regular)
                .foregroundColor(.gray500)
                .padding(.top, 7)
            
            
            Button(action: {
                // Swipe Tab 으로 이동
                LandingManager.shared.showSwipePage = true
            }, label: {
                Text("학습하러 가기")
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
        .background(Color.gray25)
        .padding(.bottom, 15)
    }
    
    var myFavoriteCardList: some View {
        VStack(spacing: 0) {
            if viewModel.categoryList.count > 0 {
                //tabBarView
                ZStack {
                    InfiniteCarousel(
                        data: viewModel.sentenceList,
                        height: sizeInfo.CarouselViewHeight,
                        cornerRadius: 0,
                        transition: .scale,
                        returnIndex: { index, isMoveFirst, isMoveLast in
                            //fLog("idpil::: isMoveFirst : \(isMoveFirst) / isMoveLast : \(isMoveLast)")
                            self.isMoveFirstHeader = isMoveFirst
                            self.isMoveLastHeader = isMoveLast
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
                            self.cardBannerCurrentIndex = index-1
                            
                            isNotMainCategoryButtonClick = true
                            
                        },
                        isAutoPlay: isAutoPlay,
                        content: { item in
                            TabHomeCardView(
                                item: item,
                                cardWidth: .infinity,
                                cardHeight: 150,
                                isAutoPlay: isAutoPlay
                            )
                        }
                    )
                    
                    
                    // 오토모드에서는 TabView 스크롤 제스처 안 되도록 막는다.
                    // TabView 스크롤 엄청 빨리 했을 때, categoryList 이랑 싱크 안 맞는 경우가 생긴다.
                    // 싱크 안 맞는 현상의 원인은 오토모드에서 TabView 전환할 때 0.3초 뒤에 관련 데이터가 설정되는데, 빨리 넘기면 당연히 싱크가 안 맞을 수 밖에 없음.
                    if isAutoPlay {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray25.opacity(0.1111111111111111111))
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .padding(40)
                    }
                    
                    
                    categoryListView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                    ZStack {
                        Text("\(cardBannerCurrentIndex+1) / \(viewModel.sentenceList.count)")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            self.isAutoPlay.toggle()
                        }, label: {
                            Image(systemName: self.isAutoPlay ? "autostartstop.slash" : "autostartstop")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.primaryDefault)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 25)
                        })
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                }
                .background(Color.gray25)
//                .background(
//                    Image("home_bg_02")
//                        .resizable()
//                        .frame(height: sizeInfo.CarouselViewHeight).aspectRatio(contentMode: .fill) // 높이 크기에 맞게 이미지 꽉 채움
//                        //.overlay(Color.primaryDefault.opacity(0.6))
//                )
                .padding(.bottom, 20)
            } else {
                emptyView
            }
        }
    }
}

extension TabHomePage {
    // Pull To Refresh
    func refreshData() async {
        // do work to asyncronously refresh your data here
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

#Preview {
    TabHomePage(
        tabtype: TabMainType.vOne,
        tabs: [
            .init(title: "h_home".localized),
            .init(title: "Popular")
        ],
        moveToTopIndicator: .constant(false)
    )
}
