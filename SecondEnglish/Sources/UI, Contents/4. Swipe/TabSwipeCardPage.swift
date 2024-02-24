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
    
    
    
    // Sentence Card
    @State var isTapLikeBtn: Bool = false
    
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
            categoryTabView
            
            ZStack {
                GeometryReader { geometry in
    //                LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1)), Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
    //                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
    //                    .background(Color.blue)
    //                    .clipShape(Circle())
    //                    .offset(x: -geometry.size.width / 4, y: -geometry.size.height / 2)
                    
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
                    //.background(Color.green.opacity(0.7))
                    
                    ForEach(Array(viewModel.swipeList.enumerated()), id: \.offset) { index, card in
                        Group {
                            // Range Operator
                            if (self.maxID - 3)...self.maxID ~= (card.customId ?? 0) {
//                                let _ = fLog("로그확인::: maxID : \(maxID)")
//                                let _ = fLog("로그확인::: minID : \(minID)")
//                                let _ = fLog("로그확인::: index : \(index)")
//                                let _ = fLog("로그확인::: item : \(viewModel.swipeList[index].KOREAN ?? "Empty")")
                                
                                
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
                                    })
                                //MARK: 책 쌓아놓은 것 같은 효과
                                //.animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: (card.customId ?? 0)), height: geometry.size.height * 0.7)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: (card.customId ?? 0)))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    //.background(Color.yellow.opacity(0.7))
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
        }
        .padding(30)
        .onAppear {
//            viewModel.requestSwipeList(sortType: .Latest) { success in
//                if success {
//                    
//                    // 내 좋아요 내역 조회
//                    viewModel.requestMyLikeCardList(uid: UserManager.shared.uid, isSuccess: { success in
//                        //
//                        
//                    })
//                }
//            }
            
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
                viewModel.blockCard() { isSuccess in
                    if isSuccess {
                        //
                    }
                }
            case .UserBlock:
                viewModel.blockUser() { isSuccess in
                    if isSuccess {
                        //
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
                fLog("idpil::: 신고하기 누른 코드값 : \(bottomSheetManager.pressedCardReportCode)")
                
                viewModel.reportCard() { isSuccess in
                    if isSuccess {
                        //
                    }
                }
            }
            
            // 다른 카드에서 같은 아이템 클릭할 수 있으니 초기화시킴
            bottomSheetManager.pressedCardReportCode = -1
        }
    }

    var categoryTabView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    if viewModel.categoryList.count > 0 {
                        ForEach(Array(viewModel.categoryList.enumerated()), id: \.offset) { index, element in
                            let isSelected = viewModel.categoryTabIndex == index
                            
                            VStack(spacing: 0) {
                                Text(element)
                                    .font(viewModel.categoryTabIndex==index ? .buttons1420Medium : .body21420Regular)
                                    .foregroundColor(viewModel.categoryTabIndex==index ? Color.gray25 : Color.gray850)
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
                                                category: viewModel.categoryList[viewModel.categoryTabIndex],
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
                            .padding(.trailing, (index==viewModel.categoryList.count-1) ? 20 : 0)
                            
                        }
                        
                    }
                }
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
        let offset: CGFloat = CGFloat(viewModel.swipeList.count - 1 - id) * 10
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
