//
//  TabHomePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct TabHomePage {
    @StateObject var viewModel = TabHomeViewModel()
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
    @State private var showPreviousStep: Bool = false // 왼족으로 이동
    @State private var showNextStep: Bool = false // 오른쪽으로 이동
    
    // Card Banner
    private let cardBannerWidth: CGFloat = UIScreen.main.bounds.size.width - 130 // UIScreen.main.bounds.size.width 가 디바이스 가로 폭인데 실제 적용하면 화면 가로영역을 벗어나기 때문에 -130 정도를 적용한 것.
    private let cardBannerDistance: CGFloat = 20 // 카드 간의 간격
    @State private var cardBannerCurrentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
}

extension TabHomePage: View {
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollViewReader { scrollviewReader in
                ScrollView {
                    
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
                                .onEnded({ value in
                                    let threshold: CGFloat = 50
                                    if value.translation.width > threshold {
                                        withAnimation {
                                            cardBannerCurrentIndex = max(0, cardBannerCurrentIndex-1)
                                        }
                                    }
                                    else if value.translation.width < -threshold {
                                        withAnimation {
                                            cardBannerCurrentIndex = min(viewModel.sentenceList.count-1, cardBannerCurrentIndex+1
                                            )
                                        }
                                    }
                                })
                        )
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                withAnimation {
                                    cardBannerCurrentIndex = max(0, cardBannerCurrentIndex-1)
                                }
                            }, label: {
                                Text("<")
                                    .font(.title13240Bold)
                            })
                            
                            Button(action: {
                                withAnimation {
                                    cardBannerCurrentIndex = min(viewModel.sentenceList.count-1, cardBannerCurrentIndex+1
                                    )
                                }
                            }, label: {
                                Text(">")
                                    .font(.title13240Bold)
                            })
                        }
                        .padding(.vertical, 30)
                    }
                    
                    
                    
                    
                    //MARK: - 내 학습 진도
                    ForEach(Array(viewModel.myLearningProgressList.enumerated()), id: \.offset) { index, item in
                        
                        /**
                         * 카테고리 글자에서 잘바꿈 하려고 중간에 개행문자(\n)를 입력해 놨다.
                         * 문제는 값을 가져오면 \\n로 내려온다. 그래서 아래와 같이 변경해준다.
                         * 원인) DB에서는 \n 을 \\n 으로 저장한다고 함.
                         */
                        TabHomeMyLearningView(
                            category: (item.category ?? "").replacingOccurrences(of: "\\n", with: "\n"),
                            categorySetenceCount: item.category_setence_count ?? 0,
                            likeNumber: item.like_number ?? 0,
                            itemIndex: index
                        )
                    }
                }
                .onChange(of: cardBannerCurrentIndex, initial: false) { oldValue, newValue in
                    // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
                    
                    
                    // 카드배너 왼족으로 이동
                    if oldValue > newValue {
                        if viewModel.sentenceList[newValue].isEndPointCategory ?? false {
                            
                            showPreviousStep = true
                        }
                    }
                    // 카드배너 오른쪽으로 이동
                    else if oldValue < newValue {
                        if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
                            
                            showNextStep = true
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
        .task {
            viewModel.requestMyCardList(uid: UserManager.shared.uid, isSuccess: { success in
                //
            })
            
            viewModel.requestMyCategoryProgress()
        }
    }
    
    var header: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    if viewModel.categoryList.count > 0 {
                        ForEach(Array(viewModel.categoryList.enumerated()), id: \.offset) { index, element in
                            let isSelected = clickedSubTabIndex == index
                            
                            VStack(spacing: 0) {
                                Text(element)
                                    .font(clickedSubTabIndex==index ? .buttons1420Medium : .body21420Regular)
                                    .foregroundColor(clickedSubTabIndex==index ? Color.gray25 : Color.gray850)
                                    .frame(minWidth: 70)
                                    .frame(height: 40)
                                    .padding(.horizontal, 15)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected
                                                                                      ? Color.gray850
                                                                                      : Color.gray199.opacity(1), lineWidth: 1))
                                    .background(RoundedRectangle(cornerRadius: 8).fill(isSelected
                                                                                       ? Color.gray850
                                                                                       : Color.gray25))
                                    .padding(.vertical, 10)
                                    .shadow(color: Color.shadowColor, radius: 3, x: 0, y: 1)
                                    // (주의!).onTapGesture 호출하는 위치에 따라서 클릭 감도 차이남
                                    .onTapGesture {
                                        
                                        /**
                                         * 카테고리 리스트 이동
                                         */
                                        clickedSubTabIndex = index
                                        withAnimation {
                                            scrollviewReader.scrollTo(index, anchor: .top)
                                        }
                                        
                                        
                                        // 카테고리 버튼 클릭시, 해당 카테고리의 카드배너 리스트로 이동
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
                                    .onChange(of: cardBannerCurrentIndex, initial: false) { oldValue, newValue in
                                        // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
                                        
                                        // 카테고리 버튼 이동 유무
                                        if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
                                            
                                            // 카드배너 왼족으로 이동
                                            if oldValue > newValue {
                                                //showPreviousStep = true
                                                
                                            }
                                            // 카드배너 오른쪽으로 이동
                                            else if oldValue < newValue {
                                                showNextStep = true
                                            }
                                        }
                                    }
                                    .onChange(of: showPreviousStep) {
                                        if showPreviousStep {
                                            
                                            clickedSubTabIndex -= 1
                                            withAnimation {
                                                scrollviewReader.scrollTo(clickedSubTabIndex, anchor: .top)
                                            }
                                            
                                            showPreviousStep = false // 초기화
                                        }
                                    }
                                    .onChange(of: showNextStep) {
                                        if showNextStep {
                                            
                                            clickedSubTabIndex += 1
                                            withAnimation {
                                                scrollviewReader.scrollTo(clickedSubTabIndex, anchor: .top)
                                            }
                                            
                                            
                                            showNextStep = false // 초기화
                                        }
                                    }
                                    //.id(index)
                            }
                            .padding(.leading, index==0 ? 20 : 10)
                            .padding(.trailing, (index==viewModel.categoryList.count-1) ? 20 : 0)
                            
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    TabHomePage()
}
