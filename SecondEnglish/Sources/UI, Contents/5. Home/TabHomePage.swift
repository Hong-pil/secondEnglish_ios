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
    
    @State var spacing: CGFloat = 10
    @State var headspace: CGFloat = 10
    @State var sidesScaling: CGFloat = 0.8
    @State var isWrap: Bool = false
    @State var autoScroll: Bool = false
    @State var time: TimeInterval = 1
    @State var currentIndex: Int = 0
    
    @State var isFlipped: Bool = false
    @State var isDisabled: Bool = false
    
    
    // Header
    @State private var clickedSubTabIndex: Int = 0
    
    // Card Banner
    private let cardBannerWidth: CGFloat = UIScreen.main.bounds.size.width - 130 // UIScreen.main.bounds.size.width 가 디바이스 가로 폭인데 실제 적용하면 화면 가로영역을 벗어나기 때문에 -130 정도를 적용한 것.
    private let cardBannerDistance: CGFloat = 20 // 카드 간의 간격
    @State private var cardBannerCurrentIndex: Int = 0
    @State private var isNotMainCategoryButtonClick: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
}

extension TabHomePage: View {
    var body: some View {
        VStack(spacing: 0) {
            
            header
            
            //MARK: - 내가 좋아요한 문장들
            if viewModel.categoryList.count>0 {
                tabBarView
                
                myList
            } else {
                emptyView
            }
            
            ScrollViewReader { scrollviewReader in
                ScrollView {
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
                                            category_sentence_count: subItem.category_sentence_count
                                        )
                                    }
                                }
                                .padding(.bottom, index==viewModel.myLearningProgressList.count-1 ? 20 : 0)
                            } header: {
                                MyProgressHeaderView(
                                    isLike: item.isLike ?? false,
                                    main_category: item.main_category,
                                    index: index
                                )
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
                /**
                 * ScrollView bounce 비활성하는 이유 : 스크롤뷰 bounce되면 좋아요한 배너 리스트 넘길 때, 잘 안 넘겨짐.
                 */
                UIScrollView.appearance().bounces = false
            })
        }
        .background(Color.bgLightGray50)
        .onAppear {
            viewModel.requestMyCardList(isSuccess: { success in
                //
            })
            
            viewModel.requestMyCategoryProgress()
        }
        .onChange(of: UserManager.shared.isLogin) {
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
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)
            
            Spacer()
            
            Button {
                //NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
            } label: {
                Image("icon_outline_alarm new")
                    .resizable()
                    .frame(width: 25, height: 25)
//                    .renderingMode(.template)
//                    .foregroundColor(.gray900)
            }
            
            Button {
                NavigationBarActionManager.shared.buttonActionSubject.send(("", .Menu))
            } label: {
                Image("icon_top_menu")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray900)
                    .padding(.leading, 15)
            }
        }
        .padding(.horizontal, 20)
    }
    
    var tabBarView: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                if viewModel.categoryList.count>0 {
                    HStack(spacing: 0) {
                        ForEach(Array(viewModel.categoryList.enumerated()), id: \.offset) { index, element in
                            let isSelected = clickedSubTabIndex == index
                            
                            VStack(spacing: 0) {
                                Text(element)
                                    .font(clickedSubTabIndex==index ? .buttons1420Medium : .body21420Regular)
                                    .foregroundColor(clickedSubTabIndex==index ? Color.gray25 : Color.gray850)
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
                                        clickedSubTabIndex = index
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
    //                                        // 카드배너 왼족으로 이동
                                            if oldValue > newValue {
                                                if viewModel.sentenceList[newValue].isEndPointCategory ?? false {
                                                    clickedSubTabIndex -= 1
                                                }
                                            }
                                            // 카드배너 오른쪽으로 이동
                                            else if oldValue < newValue {
                                                if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
                                                    
                                                    clickedSubTabIndex += 1
                                                }
                                            }
                                            
                                            withAnimation {
                                                scrollviewReader.scrollTo(clickedSubTabIndex, anchor: .top)
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
                .padding(.top, 10)
            
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
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray25))
        .padding(20)
    }
    
    var myList: some View {
        ZStack {
            Image("home_bg_02")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(Color.primaryDefault.opacity(0.6))
            
            VStack(spacing: 0) {
                //MARK: - 좋아요한 배너 리스트 (검색어 : Carousel Slider)
                // [Ref] https://www.youtube.com/watch?v=DgTPWYM5Hm4
                if viewModel.sentenceList.count > 0 {
                    ZStack {
                        ForEach(Array(viewModel.sentenceList.enumerated()), id: \.offset) { index, item in
                            
                            TabHomeCardView(item: item, cardWidth: cardBannerWidth)
                                .padding(.top, 30)
                                .opacity(cardBannerCurrentIndex == index ? 1.0 : 0.5)
                                .scaleEffect(cardBannerCurrentIndex == index ? 1.2 : 0.8)
                                .offset(
                                    x: CGFloat(index - cardBannerCurrentIndex) * (cardBannerWidth+cardBannerDistance) + dragOffset,
                                    y: 0
                                )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .gesture(
                        DragGesture()
                            .onEnded({ gesture in
                                
                                /**
                                 * [민감도 기준]
                                 * threshold 값을 낮출 수록 민감도 기준이 낮아지기 때문에 잘 넘어감.
                                 */
                                let threshold: CGFloat = 30
                                
                                //fLog("idpil::: gesture.translation.width: \(gesture.translation.width)")
                                
                                // 손가락으로 좌-우 Swipe한 길이
                                if gesture.translation.width > threshold {
                                    withAnimation {
                                        cardBannerCurrentIndex = max(0, cardBannerCurrentIndex-1)
                                    }
                                }
                                else if gesture.translation.width < -threshold {
                                    withAnimation {
                                        cardBannerCurrentIndex = min(viewModel.sentenceList.count-1, cardBannerCurrentIndex+1
                                        )
                                    }
                                }
                                
                                isNotMainCategoryButtonClick = true
                            })
                    )
                    
                    ZStack {
                        Text("\(cardBannerCurrentIndex+1) / \(viewModel.sentenceList.count)")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray100)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack(spacing: 15) {
                            Group {
                                Button(action: {
                                    withAnimation {
                                        cardBannerCurrentIndex = max(0, cardBannerCurrentIndex-1)
                                    }
                                    isNotMainCategoryButtonClick = true
                                }, label: {
                                    Image(systemName: "chevron.left.square.fill")
                                        .resizable()
                                        .renderingMode(.template)
                                })
                                
                                Button(action: {
                                    withAnimation {
                                        cardBannerCurrentIndex = min(viewModel.sentenceList.count-1, cardBannerCurrentIndex+1
                                        )
                                    }
                                    isNotMainCategoryButtonClick = true
                                }, label: {
                                    Image(systemName: "chevron.right.square.fill")
                                        .resizable()
                                        .renderingMode(.template)
                                })
                            }
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray25)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 40)
                }
            }
        }
    }
}

#Preview {
    TabHomePage()
}
