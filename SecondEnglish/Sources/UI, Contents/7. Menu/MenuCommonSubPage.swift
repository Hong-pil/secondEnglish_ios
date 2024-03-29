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
}

extension MenuCommonSubPage: View {
    var body: some View {
        VStack(spacing: 0) {
            switch type {
            case .Sentence:
                // 작성한 글
                sentenceView
                    .task {
                        fLog("idpil::: 1")
                        naviTitle = "j_wrote_post".localized
                        viewModel.getMySentence()
                    }
            case .PostLike:
                // 누른 좋아요
                postLikeView
                    .task {
                        fLog("idpil::: 2")
                        naviTitle = "l_like_do".localized
                        viewModel.getMyPostLike()
                    }
            case .GetLike:
                // 받은 좋아요
                getLikeView
                    .task {
                        fLog("idpil::: 3")
                        naviTitle = "l_like_get".localized
                        viewModel.getMyGetLike()
                    }
            case .CardBlock:
                // 차단한 글
                cardBlockView
                    .task {
                        fLog("idpil::: 4")
                        naviTitle = "b_block_post".localized
                        viewModel.getMyCardBlock()
                    }
            case .UserBlock:
                // 차단한 사용자
                userBlockView
                    .task {
                        fLog("idpil::: 5")
                        naviTitle = "b_block_user".localized
                        viewModel.getMyUserBlock()
                    }
            case .PopularTop10Week:
                // 주간 인기글
                popularTop10View
                    .task {
                        fLog("idpil::: 6")
                        naviTitle = "top10_card_week".localized
                        viewModel.getPopularCardTop10(isWeek: true)
                    }
            case .PopularTop10Month:
                // 월간 인기글
                popularTop10View
                    .task {
                        fLog("idpil::: 7")
                        naviTitle = "top10_card_month".localized
                        viewModel.getPopularCardTop10(isWeek: false)
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
        }
    }
    
    var sentenceView: some View {
        VStack(spacing: 0) {
            Text("작성한 글")
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
            LazyVStack(spacing: 0) {
                ForEach(Array((viewModel.cardBlockData?.sentence_list ?? []).enumerated()), id: \.offset) { index, item in
                    
                    MenuSubPageCellFlipView(
                        item: item,
                        isDoItemDelete: true
                    )
                }
            }
        }
    }
    
    var userBlockView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array((viewModel.userBlockData ?? []).enumerated()), id: \.offset) { index, item in
                    
                    MenuSubPageCellBasicView(
                        target_nickname: item.target_nickname ?? "",
                        target_uid: item.target_uid ?? ""
                    )
                }
            }
        }
    }
    
    var popularTop10View: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array((viewModel.popularCardTop10Data ?? []).enumerated()), id: \.offset) { index, item in
                    
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

//#Preview {
//    MenuCommonSubPage()
//}
