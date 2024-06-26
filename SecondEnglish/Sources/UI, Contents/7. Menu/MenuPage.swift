//
//  MenuPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct MenuPage {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MenuViewModel()
    @StateObject var userManager = UserManager.shared
    
    @State private var isShowSettingPage: Bool = false
    @State private var isShowMySentencePage: Bool = false
    @State private var isShowPostLikePage: Bool = false
    @State private var isShowGetLikePage: Bool = false
    @State private var isShowCardBlockPage: Bool = false
    @State private var isShowUserBlockPage: Bool = false
    @State private var isShowPopularCardTop10Page_Week: Bool = false
    @State private var isShowPopularCardTop10Page_Month: Bool = false
    @State private var isShowAlarmPage = false
    
    @Binding var goBackMainPage: Bool
    
    private struct sizeInfo {
        static let listSpacing: CGFloat = 12.0
    }
}

extension MenuPage: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
//                MenuAlarmView(alimList: [],
//                              unreadCount: 0) { alimId in
//                    
////                    vm.alimRead(id: alimId) {
////                        vm.getAlimUnreadList()
////                    }
//                    
//                } onShow: {
//                    isShowAlarmPage = true
//                }
                
                profileView
                    .padding(.top, sizeInfo.listSpacing)
                    .padding(.bottom, sizeInfo.listSpacing)
                
                MenuInfoView(
                    mySentenceNum: viewModel.mySentenceList.count,
                    myPostLikeNum: viewModel.myPostLikeList.count,
                    myGetLikeNum: viewModel.myGetLikeList.count,
                    onPress: { buttonType in
                        if !userManager.isLogin {
                            userManager.showLoginAlert = true
                        }
                        else {
                            if buttonType == .Sentence {
                                isShowMySentencePage = true
                            }
                            else if buttonType == .PostLike {
                                isShowPostLikePage = true
                            }
                            else if buttonType == .GetLike {
                                isShowGetLikePage = true
                            }
                        }
                    }
                )
                .modifier(CornerRadiusListModifier())
                
                Text("MY")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: sizeInfo.listSpacing, leading: DefineSize.Contents.HorizontalPadding + 20, bottom: sizeInfo.listSpacing, trailing: 0))
                
                VStack(spacing: 0) {
                    MenuLinkView(text: "se_block_post".localized, position: .Top, showLine: true, onPress: {
                        if userManager.isLogin {
                            isShowCardBlockPage = true
                        }
                        else {
                            userManager.showLoginAlert = true
                        }
                    })
                    
                    MenuLinkView(text: "se_block_user".localized, position: .Top, showLine: true, onPress: {
                        if userManager.isLogin {
                            isShowUserBlockPage = true
                        }
                        else {
                            userManager.showLoginAlert = true
                        }
                        
                    })
                }
                .modifier(CornerRadiusListModifier())
                
                Text("SERVICE")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: sizeInfo.listSpacing, leading: DefineSize.Contents.HorizontalPadding + 20, bottom: sizeInfo.listSpacing, trailing: 0))
                
                VStack(spacing: 0) {
                    MenuLinkView(text: "se_top10_card_week".localized, position: .Top, showLine: true, onPress: {
                        isShowPopularCardTop10Page_Week = true
                    })
                    
                    MenuLinkView(text: "se_top10_card_month".localized, position: .Top, showLine: true, onPress: {
                        isShowPopularCardTop10Page_Month = true
                    })
                }
                .modifier(CornerRadiusListModifier())
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowSettingPage = true
                }, label: {
                    Image("outlineIconOutlineSetting")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
        }
        .task {
            viewModel.getMySentence()
            viewModel.getMyPostLike()
            viewModel.getMyGetLike()
        }
        .background(Color.bgLightGray50)
        .navigationDestination(isPresented: $isShowSettingPage) {
            SettingPage(goBackMainPage: $goBackMainPage)
        }
        .navigationDestination(isPresented: $isShowAlarmPage) {
            AlertPage()
        }
        .navigationDestination(isPresented: $isShowMySentencePage) {
            MenuCommonSubPage(type: .Sentence)
        }
        .navigationDestination(isPresented: $isShowPostLikePage) {
            MenuCommonSubPage(type: .PostLike)
        }
        .navigationDestination(isPresented: $isShowGetLikePage) {
            MenuCommonSubPage(type: .GetLike)
        }
        .navigationDestination(isPresented: $isShowCardBlockPage) {
            MenuCommonSubPage(type: .CardBlock)
        }
        .navigationDestination(isPresented: $isShowUserBlockPage) {
            MenuCommonSubPage(type: .UserBlock)
        }
        .navigationDestination(isPresented: $isShowPopularCardTop10Page_Week) {
            MenuCommonSubPage(type: .PopularTop10Week)
        }
        .navigationDestination(isPresented: $isShowPopularCardTop10Page_Month) {
            MenuCommonSubPage(type: .PopularTop10Month)
        }
    }
    
    var profileView: some View {
        HStack(spacing: 0) {
            Image(CommonFunction.getRandomDefaultImage(UserUniqueId: UserManager.shared.uid))
                .resizable()
                .scaledToFill()
                .frame(width: DefineSize.Size.ProfileThumbnailM.width, height: DefineSize.Size.ProfileThumbnailM.height, alignment: .leading)
                .clipped()
                .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailM)
            
            Text("\(UserManager.shared.userNick)")
                .font(Font.title51622Medium)
                .foregroundColor(Color.gray870)
                .padding([.trailing], 8)
                .fixedSize(horizontal: true, vertical: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.leading, 10)
        }
        .padding(20)
        .modifier(CornerRadiusListModifier())
    }
    
}

#Preview {
    MenuPage(goBackMainPage: .constant(false))
}
