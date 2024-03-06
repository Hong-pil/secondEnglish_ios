//
//  TabSwipeCardPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import AVFoundation

//struct User: Hashable, CustomStringConvertible {
//    var id: Int
//    
//    let firstName: String
//    let lastName: String
//    let age: Int
//    let mutualFriends: Int
//    let imageName: String
//    let occupation: String
//    
//    var description: String {
//        return "\(firstName), id: \(id)"
//    }
//}

struct TabSwipeCardPage {
    @StateObject var viewModel = SwipeCardViewModel.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    @State var currentCardIndex: Int = 0
    @State var curPercent: Double = 0.0
    /// List of users
    //@State var users: [User] = []
    
    /**
     * [주의사항]
     * 자식뷰에서 변수 선언하면 기능 작동은 하는데, 로딩시간이 엄청 길어지는 문제가 있음.
     * 그리고 'Unable to list voice folder'라는 경고 문구가 뜸.
     * 그래서 전역변수 하나만 생성해서, 자식뷰로 넘겨주는 방식으로 해결했음.
     */
    let speechSynthesizer = AVSpeechSynthesizer() // TTS
}

extension TabSwipeCardPage: View {
    var body: some View {
        VStack(spacing: 0) {
            
            mainCategoryButton
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
                        Group {
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
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .opacity(viewModel.swipeList.count>0 ? 1 : 0)
                }
            }
            
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
        .onAppear {
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
                            
                            bottomSheetManager.swipePageMainCategoryName = DefineBottomSheet.swipePageMainCategoryListItems[0]
                            
                            viewModel.requestCategory(
                                isInit: true,
                                category: DefineBottomSheet.swipePageMainCategoryListItems[0]
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
                
                // 다음 스탭으로 넘어감
                viewModel.categoryTabIndex += 1
                viewModel.moveCategoryTab = true
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
        .onChange(of: bottomSheetManager.swipePageMainCategoryName) {
            viewModel.requestCategory(
                isInit: true,
                category: bottomSheetManager.swipePageMainCategoryName
            ) { isSuccess in
                if isSuccess {
                    viewModel.moveCategoryTab = true
                }
            }
        }
    }

    var mainCategoryButton: some View {
        HStack(spacing: 0) {
            Text(bottomSheetManager.swipePageMainCategoryName)
                .font(.buttons1420Medium)
                .foregroundColor(.gray800)
            
            Image("icon_outline_dropdown")
                .resizable()
                .renderingMode(.template)
                .frame(width: 13, height: 13)
                .foregroundColor(.gray800)
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
            //self.isShowMainCategoryListView = true
            
            bottomSheetManager.show.swipePageMainCategory = true
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
