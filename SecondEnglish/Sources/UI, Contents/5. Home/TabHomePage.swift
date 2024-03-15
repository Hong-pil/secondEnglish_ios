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
    @State private var showPreviousStep: Bool = false // 왼족으로 이동
    @State private var showNextStep: Bool = false // 오른쪽으로 이동
    
    // Card Banner
    private let cardBannerWidth: CGFloat = UIScreen.main.bounds.size.width - 130 // UIScreen.main.bounds.size.width 가 디바이스 가로 폭인데 실제 적용하면 화면 가로영역을 벗어나기 때문에 -130 정도를 적용한 것.
    private let cardBannerDistance: CGFloat = 20 // 카드 간의 간격
    @State private var cardBannerCurrentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    
    
    
    
    
    
    
    // 각 직사각형 뷰에 사용할 색상 배열
    private let randomCardColors: [Color] = [.red, .green, .blue, .black]
    // 각 뷰의 회전 상태를 관리한다
    @State private var randomCardRotationDegrees = [0.0, 0.0, 0.0, 0.0]
    // 각 뷰의 위치 이동 상태를 관리한다
    @State private var randomCardOffsets = [sizeInfo.index0RandomCardOffset, sizeInfo.index1RandomCardOffset, sizeInfo.index2RandomCardOffset, sizeInfo.index3RandomCardOffset]
    
    private struct sizeInfo {
        static let index0RandomCardOffset: CGSize = CGSize.zero
        static let index1RandomCardOffset: CGSize = CGSize(width: 0, height: -10)
        static let index2RandomCardOffset: CGSize = CGSize(width: 0, height: -20)
        static let index3RandomCardOffset: CGSize = CGSize(width: 0, height: -30)
    }
    
}

extension TabHomePage: View {
    
    /**
     * [ChatGTP]
     * SwiftUI에서 직사각형 rectangle 뷰가 쌓여있고, 버튼을 누르면 각각의 뷰들이 각자 다른 방향으로 회전하면서 펼쳐 졌다가 다시 원래대로 돌아오는 기능을 알려줘.
     * 고마워. 그런데 뷰가 펼쳐질 때, 각각의 뷰가 사방으로 거리가 100만큼 이동했다가 다시 돌아와야 해. 다시 알려줘.
     *
     *
     * 각각의 Rectangle 뷰가 버튼을 누를 때 사방으로 거리가 100만큼 이동했다가 다시 원래 위치로 돌아오도록 하기 위해서는, 회전 애니메이션과 함께 위치 이동 애니메이션도 적용해야 합니다. 이를 위해 @State 프로퍼티를 사용하여 각 뷰의 x 및 y 좌표에 대한 이동 상태를 관리할 수 있습니다.
     * 이 예제에서는 각 Rectangle 뷰가 서로 다른 방향으로 이동하도록 설정합니다. 예를 들어, 첫 번째 뷰는 위로, 두 번째 뷰는 아래로, 세 번째 뷰는 왼쪽으로 이동하도록 설정할 수 있습니다. 이러한 이동 후, 모든 뷰가 다시 원래 위치로 돌아오도록 설정합니다.
     * 아래의 코드 예제는 각 뷰가 회전과 함께 이동하도록 구현하는 방법을 보여줍니다:
     *
     * 이 코드에서 offsets 배열은 각 Rectangle 뷰의 x 및 y 축 이동을 관리합니다. Button의 액션에서는 이 배열의 각 원소를 업데이트하여 뷰들이 특정 방향으로 이동하도록 합니다. 이 예제에서는 간단히 첫 번째 뷰가 위로, 두 번째 뷰가 아래로, 세 번째 뷰가 왼쪽으로 이동하도록 설정했습니다. 각각의 뷰에 대해 offset을 조정하여 다른 방향과 거리로 이동시킬 수 있으며, 이를 통해 다양한 애니메이션 효과를 만들 수 있습니다.
     *
     *
     * [코드를 자세히 설명해줘]
     * 물론이에요. 제가 제공한 코드는 SwiftUI를 사용하여 네 개의 Rectangle 뷰가 각기 다른 방향으로 이동하고 회전하는 애니메이션을 구현합니다. 여기에 포함된 주요 구성 요소와 작동 원리를 자세히 설명하겠습니다.
     *
     * 상태 변수들
     * 회전 상태 (randomCardRotationDegrees): 이 @State 배열은 각 Rectangle 뷰의 현재 회전 각도를 저장합니다. 배열의 각 요소는 해당 뷰의 회전 각도를 나타냅니다. 사용자가 버튼을 누를 때마다 이 값이 업데이트되어 뷰가 회전합니다.
     * 위치 이동 상태 (offsets): 이 @State 배열은 각 Rectangle 뷰의 현재 위치 이동(offset)을 CGSize로 저장합니다. CGSize의 width와 height 값은 각각 x축과 y축으로의 이동 거리를 나타냅니다. 사용자가 버튼을 누를 때마다 이 값이 업데이트되어 뷰가 지정된 방향으로 이동합니다.
     * 뷰 구성
     * Rectangle 뷰들: 세 개의 Rectangle 뷰가 ForEach 루프를 통해 생성됩니다. 각각은 고유한 색상을 가지며, frame 모디파이어로 크기를 설정합니다.
     * 회전 및 이동 적용: .rotationEffect와 .offset 모디파이어를 사용하여 각 뷰에 회전과 이동 애니메이션을 적용합니다. randomCardRotationDegrees와 offsets 배열의 해당 인덱스 값을 사용하여 각 뷰의 회전 각도와 이동 거리를 지정합니다.

       애니메이션: .animation(_:value:) 모디파이어를 사용하여 회전과 이동에 부드러운 애니메이션 효과를 적용합니다. value 파라미터에 각 상태 변수를 지정하여, 이 변수들의 값이 변경될 때 애니메이션이 실행되도록 합니다.

       버튼 액션
       "Toggle" 버튼: 사용자가 이 버튼을 누를 때마다 각 Rectangle 뷰의 회전 각도와 이동 거리가 업데이트됩니다.

       회전: randomCardRotationDegrees 배열의 각 요소에 180도(또는 -180도)를 더하거나 빼서 뷰를 회전시킵니다. 이는 뷰가 앞뒤로 회전하도록 합니다.

       이동: offsets 배열의 각 요소를 업데이트하여 뷰를 특정 방향으로 이동시킵니다. 예를 들어, 첫 번째 뷰는 위로, 두 번째 뷰는 아래로, 세 번째 뷰는 왼쪽으로 이동합니다. 이는 .zero 값과 비교하여 토글되어, 뷰가 원래 위치로 돌아오거나 지정된 거리만큼 이동합니다.

       이 코드는 SwiftUI의 @State 관리, 조건부 뷰 변형, 그리고 사용자 입력에 반응하는 인터랙티브한 UI 구성의 기본을 보여줍니다. 뷰의 상태가 변경될 때 SwiftUI가 자동으로 뷰를 업데이트하는 선언적 UI 접근 방식을 잘 활용하고 있습니다.
     */
    /**
     * 기능 : 네 개의 Rectangle 뷰가 각기 다른 방향으로 이동하고 회전하는 애니메이션
     */
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<4) { index in
                    Rectangle()
                        .fill(randomCardColors[index])
                        .stroke(Color.yellow, lineWidth: 2.0)
                        .frame(width: 200, height: 300)
                    // 회전과 위치 이동을 적용합니다.
                        .rotationEffect(.degrees(randomCardRotationDegrees[index]))
                        .offset(randomCardOffsets[index])
                        .animation(.easeInOut(duration: 0.5), value: randomCardRotationDegrees[index])
                        .animation(.easeInOut(duration: 0.5), value: randomCardOffsets[index])
                }
            }
            .frame(height: 320) // ZStack의 높이를 설정합니다.
            
            Button(action: {
                self.doShuffleRandomCard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.doShuffleRandomCard()
                }
            }, label: {
                Text("Action :)")
                    .padding(10)
                    .background(Color.blue)
            })
            .padding(.top, 50)
        }
    }
    
    private func doShuffleRandomCard() {
        // 버튼을 누를 때마다 각 뷰의 회전 방향과 위치를 업데이트합니다.
        for index in randomCardRotationDegrees.indices {
            randomCardRotationDegrees[index] += index % 2 == 0 ? 180 : -180
            // 위치 이동을 결정합니다. 각 뷰가 사방으로 100만큼 이동합니다.
            switch index {
            case 0:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index0RandomCardOffset ? CGSize(width: 0, height: -100) : sizeInfo.index0RandomCardOffset
            case 1:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index1RandomCardOffset ? CGSize(width: 0, height: 100) : sizeInfo.index1RandomCardOffset
            case 2:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index2RandomCardOffset ? CGSize(width: -100, height: 0) : sizeInfo.index2RandomCardOffset
            case 3:
                randomCardOffsets[index] = randomCardOffsets[index] == sizeInfo.index3RandomCardOffset ? CGSize(width: 100, height: 0) : sizeInfo.index3RandomCardOffset
            default:
                break
            }
        }
    }
    
//    var body: some View {
//        VStack(spacing: 0) {
//            if viewModel.categoryList.count>0 {
//                header
//                
//                myList
//            } else {
//                emptyView
//            }
//            
//            //MARK: - 내 학습 진도
//            ScrollViewReader { scrollviewReader in
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ForEach(Array(viewModel.myLearningProgressList.enumerated()), id: \.offset) { index, item in
//                            
//                            /**
//                             * 카테고리 글자에서 잘바꿈 하려고 중간에 개행문자(\n)를 입력해 놨다.
//                             * 문제는 값을 가져오면 \\n로 내려온다. 그래서 아래와 같이 변경해준다.
//                             * 원인) DB에서는 \n 을 \\n 으로 저장한다고 함.
//                             */
//                            TabHomeMyLearningView(
//                                category: (item.category ?? "").replacingOccurrences(of: "\\n", with: "\n"),
//                                categorySetenceCount: item.category_setence_count ?? 0,
//                                likeNumber: item.like_number ?? 0,
//                                itemIndex: index
//                            )
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                        }
//                    }
//                }
//                .onChange(of: cardBannerCurrentIndex, initial: false) { oldValue, newValue in
//                    // 주의! initial true로 설정시, 값이 바뀌지 않았는데도 최초 한 번 호출됨.
//                    
//                    
//                    // 카드배너 왼족으로 이동
//                    if oldValue > newValue {
//                        if viewModel.sentenceList[newValue].isEndPointCategory ?? false {
//                            
//                            showPreviousStep = true
//                        }
//                    }
//                    // 카드배너 오른쪽으로 이동
//                    else if oldValue < newValue {
//                        if viewModel.sentenceList[newValue].isStartPointCategory ?? false {
//                            
//                            showNextStep = true
//                        }
//                    }
//                }
//            }
//            .onAppear(perform: {
//                //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
//                /**
//                 * ScrollView bounce 비활성하는 이유 : 스크롤뷰 bounce되면 좋아요한 배너 리스트 넘길 때, 잘 안 넘겨짐.
//                 */
//                UIScrollView.appearance().bounces = false
//            })
//        }
//        .background(Color.bgLightGray50)
//        .onAppear {
//            viewModel.requestMyCardList(isSuccess: { success in
//                //
//            })
//            
//            viewModel.requestMyCategoryProgress()
//        }
//        .onChange(of: UserManager.shared.isLogin) {
//            // 여기 뷰 띄워놓고 로그인뷰를 팝업으로 띄운 다음 로그인 진행을 하기 때문에, 로그인 성공한 경우 데이터 다시 요청
//            if UserManager.shared.isLogin {
//                viewModel.requestMyCardList(isSuccess: { success in
//                    //
//                })
//                
//                viewModel.requestMyCategoryProgress()
//            }
//        }
//    }
    
    var header: some View {
        ScrollViewReader { scrollviewReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
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
                            
                            fLog("idpil::: gesture.translation.width: \(gesture.translation.width)")
                            
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
        }
    }
}

#Preview {
    TabHomePage()
}
