//
//  MenuCommonSubPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/21/24.
//

import SwiftUI

struct MenuCommonSubPage {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MenuViewModel()
    
    let type: MenuButtonType
    
    @State var naviTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var isReadyToShow: Bool = false
    @State private var isShowEditPage: Bool = false
}

extension MenuCommonSubPage: View {
    var body: some View {
        VStack(spacing: 0) {
            switch type {
            case .Sentence:
                // 작성한 글
                sentenceView
                    .task {
                        naviTitle = "j_wrote_post".localized
                        viewModel.getMySentence() {
                            isReadyToShow = true
                        }
                    }
            case .PostLike:
                // 누른 좋아요
                postLikeView
                    .task {
                        naviTitle = "l_like_do".localized
                        viewModel.getMyPostLike()
                    }
            case .GetLike:
                // 받은 좋아요
                getLikeView
                    .task {
                        naviTitle = "l_like_get".localized
                        viewModel.getMyGetLike()
                    }
            case .CardBlock:
                // 차단한 글
                cardBlockView
                    .task {
                        naviTitle = "b_block_post".localized
                        viewModel.getMyCardBlock() {
                            isReadyToShow = true
                        }
                    }
            case .UserBlock:
                // 차단한 사용자
                userBlockView
                    .task {
                        naviTitle = "b_block_user".localized
                        viewModel.getMyUserBlock() {
                            isReadyToShow = true
                        }
                    }
            case .PopularTop10Week:
                // 주간 인기글
                popularTop10View
                    .task {
                        naviTitle = "top10_card_week".localized
                        viewModel.getPopularCardTop10(isWeek: true) {
                            isReadyToShow = true
                        }
                    }
            case .PopularTop10Month:
                // 월간 인기글
                popularTop10View
                    .task {
                        naviTitle = "top10_card_month".localized
                        viewModel.getPopularCardTop10(isWeek: false) {
                            isReadyToShow = true
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack(spacing: 20) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .renderingMode(.template)
                                .foregroundColor(.black)
                        })
                        
                        Text(naviTitle)
                            .font(.title51622Medium)
                            .foregroundColor(.black)
                    }
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowEditPage = true
                }, label: {
                    Text("s_modifying".localized)
                        .font(.title51622Medium)
                        .foregroundColor(.primaryDefault)
                })
                .opacity(type == .Sentence ? 1.0 : 0.0)
            }
        }
        .popup(isPresenting: $showAlert,
               cornerRadius: 5,
               locationType: .bottom,
               autoDismiss: .after(2),
               popup:
                CommonPopupView(text: viewModel.popupMessage)
        )
        .navigationDestination(isPresented: $isShowEditPage) {
            MySentenceEditPage(sentenceList: viewModel.mySentenceList) { saved, category in
//                if saved {
//                    RefreshManager.shared.postChangeDataSubject.send(PostChanged(state: .Create(code: category)))
//                }
            }
        }
    }
    
    var sentenceView: some View {
        ScrollView {
            if isReadyToShow {
                if viewModel.mySentenceList.count > 0 {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.mySentenceList.enumerated()), id: \.offset) { index, item in
                            
                            MenuSubPageCellFlipView(
                                item: item,
                                type: type,
                                isDoItemDelete: true,
                                isItemDelete: {
                                    viewModel.deleteCard(
                                        idx: item.idx ?? -1
                                    ) { isSuccess in
                                        if isSuccess {
                                            self.showAlert = true
                                            viewModel.removeDeletedCard(cardIndex: index)
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
                else {
                    emptyView
                }
            }
        }
    }
    
    var postLikeView: some View {
        VStack(spacing: 0) {
            Text("누른 좋아요")
        }
    }
    
    var getLikeView: some View {
        VStack(spacing: 0) {
            Text("받은 좋아요")
        }
    }
    
    var cardBlockView: some View {
        ScrollView {
            if isReadyToShow {
                if (viewModel.cardBlockData?.sentence_list.count ?? 0) > 0 {
                    LazyVStack(spacing: 0) {
                        ForEach(Array((viewModel.cardBlockData?.sentence_list ?? []).enumerated()), id: \.offset) { index, item in
                            
                            MenuSubPageCellFlipView(
                                item: item,
                                type: type,
                                isDoItemDelete: true,
                                isBlockCancel: {
                                    // isBlock == false 이면 차단해제 요청
                                    // isBlock == true 이면 차단 요청
                                    viewModel.blockCard(
                                        cardIdx: item.idx ?? -1,
                                        isBlock: "false"
                                    ) {
                                        self.showAlert = true
                                        viewModel.cancelBlockCard(cardIndex: index)
                                    }
                                }
                            )
                        }
                    }
                } else {
                    emptyView
                }
            }
        }
    }
    
    var userBlockView: some View {
        ScrollView {
            if isReadyToShow {
                if (viewModel.userBlockData?.count ?? 0) > 0 {
                    LazyVStack(spacing: 0) {
                        ForEach(Array((viewModel.userBlockData ?? []).enumerated()), id: \.offset) { index, item in
                            
                            MenuSubPageCellBasicView(
                                target_nickname: item.target_nickname ?? "",
                                target_uid: item.target_uid ?? "",
                                isBlockCancel: {
                                    // isBlock == false 이면 차단해제 요청
                                    // isBlock == true 이면 차단 요청
                                    viewModel.blockUser(
                                        targetUid: item.target_uid ?? "",
                                        targetNickname: item.target_nickname ?? "",
                                        isBlock: "false",
                                        isDone: {
                                            self.showAlert = true
                                            viewModel.cancelBlockUser(userIndex: index)
                                        }
                                    )
                                }
                            )
                        }
                    }
                } else {
                    emptyView
                }
            }
        }
    }
    
    var popularTop10View: some View {
        ScrollView {
            if isReadyToShow {
                LazyVStack(spacing: 0) {
                    
                    if let startDay = viewModel.StringToDate(timeString: viewModel.popularCardTop10Data?.startDay ?? ""),
                       let endDay = viewModel.StringToDate(timeString: viewModel.popularCardTop10Data?.endDay ?? "") {
                        Text("\(startDay) ~ \(endDay)")
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray300)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 20))
                    }
                    
                    ForEach(Array((viewModel.popularCardTop10Data?.list ?? []).enumerated()), id: \.offset) { index, item in
                        
                        ZStack {
                            MenuSubPageCellFlipPopularView(
                                item: item,
                                isDoItemDelete: false
                            )
                            
                            ZStack {
                                Image("top10_bookmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 40) // 높이에 맞춰 비율 유지함(.aspectRatio 다음에 위치해야 됨)
                                    .foregroundColor(
                                        Color.primaryDefault
                                            .opacity((index < 3) ? 1.0 : 0.3)
                                    )
                                
                                Text("\(index + 1)")
                                    .font(.title51622Medium.weight(.bold))
                                    .foregroundColor(
                                        (index < 3) ? Color.gray25 : Color.primaryDefault
                                    )
                                    .padding(.bottom, 10)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(.trailing, 10)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        //.fixedSize(horizontal: true, vertical: true)
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
            
            Text(type == .Sentence ? "작성한 글이 없습니다." : "차단한 이력이 없습니다.")
                .font(.title51622Medium)
                .foregroundColor(.gray800)
                .padding(.top, 5)
        }
        .padding(.top, 100)
    }
    
}

//#Preview {
//    MenuCommonSubPage()
//}
