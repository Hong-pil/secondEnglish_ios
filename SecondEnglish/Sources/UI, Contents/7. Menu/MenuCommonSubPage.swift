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
                popularTop10WeekView
                    .task {
                        fLog("idpil::: 6")
                        naviTitle = "top10_card_week".localized
                        viewModel.getPopularCardTop10(isWeek: true)
                    }
            case .PopularTop10Month:
                // 월간 인기글
                popularTop10MonthView
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
                    
                    MenuSubPageCellBasicView(item: item.target_nickname ?? "")
                }
            }
        }
    }
    
    var popularTop10WeekView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array((viewModel.popularCardTop10Data ?? []).enumerated()), id: \.offset) { index, item in
                    
                    MenuSubPageCellFlipView(
                        item: item,
                        isDoItemDelete: false
                    )
                }
            }
        }
    }
    
    var popularTop10MonthView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array((viewModel.popularCardTop10Data ?? []).enumerated()), id: \.offset) { index, item in
                    
                    MenuSubPageCellFlipView(
                        item: item,
                        isDoItemDelete: false
                    )
                }
            }
        }
    }
}

//#Preview {
//    MenuCommonSubPage()
//}
