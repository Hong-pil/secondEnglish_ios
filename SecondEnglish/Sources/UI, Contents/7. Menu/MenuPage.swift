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
    @State private var isShowAlarmPage = false
    
    private struct sizeInfo {
        static let listSpacing: CGFloat = 12.0
    }
}

extension MenuPage: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
                MenuAlarmView(alimList: viewModel.alimList,
                              unreadCount: viewModel.alimUnread?.count ?? 0) { alimId in
                    
//                    vm.alimRead(id: alimId) {
//                        vm.getAlimUnreadList()
//                    }
                    
                } onShow: {
                    isShowAlarmPage = true
                }
                
                profileView
                    .padding(.bottom, sizeInfo.listSpacing)
                
                MenuInfoView()
                    .modifier(CornerRadiusListModifier())
                
                Text("MY")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: sizeInfo.listSpacing, leading: DefineSize.Contents.HorizontalPadding + 20, bottom: sizeInfo.listSpacing, trailing: 0))
                
                VStack(spacing: 0) {
                    MenuLinkView(text: "b_block_post".localized, position: .Top, showLine: true, onPress: {
                        if userManager.isLogin {
                            //showMyClubPage = true
                        }
                        else {
                            AlertManager().showLoginAlert()
                        }
                        
                    })
                    
                    MenuLinkView(text: "b_block_user".localized, position: .Top, showLine: true, onPress: {
                        if userManager.isLogin {
                            //showMyMinutePage = true
                        }
                        else {
                            AlertManager().showLoginAlert()
                        }
                        
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
        .background(Color.bgLightGray50)
        .navigationDestination(isPresented: $isShowSettingPage) {
            SettingPage()
        }
        .navigationDestination(isPresented: $isShowAlarmPage) {
            AlertPage()
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
    MenuPage()
}
