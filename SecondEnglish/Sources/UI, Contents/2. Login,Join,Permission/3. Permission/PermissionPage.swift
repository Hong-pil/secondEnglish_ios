//
//  PermissionPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/26/24.
//

import SwiftUI

struct PermissionPage: View {
    private struct sizeInfo {
        static let padding20: CGFloat = 20.0
        
        static let topPadding: CGFloat = 44.0 + DefineSize.SafeArea.top
        static let bottomPadding: CGFloat = 20.0 + DefineSize.SafeArea.bottom
        
        static let textPadding: CGFloat = 12.0
        
        static let cornerRadius: CGFloat = 20.0
        
        static let spacerHeight: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 124.0, height: 30.0)
    }
    
    let vm = PermissionViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer().frame(height: sizeInfo.topPadding)
            
            Image("bi_secondEnglish")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.primaryDefault.opacity(0.9))
                .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                .padding(.bottom, sizeInfo.spacerHeight)
            
            Text("se_p_allow_access".localized)
                .font(Font.title51622Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, sizeInfo.spacerHeight)
            
            permissionView
            
            PermissionText(icon: "•", description: "se_h_request_acceess_use_service".localized)
            
            Spacer().frame(maxHeight: .infinity)
            
            Button {
                vm.requestPermission()
            } label: {
                CommonButton(title: "d_next".localized, bgColor: Color.primaryDefault)
                    .padding(.bottom, sizeInfo.bottomPadding)
                    .frame(maxWidth: .infinity, alignment: .bottom)
            }
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .background(Color.bgLightGray50)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.all)
    }
    
    var permissionView: some View {
        VStack {
            HStack(spacing: sizeInfo.padding20) {
                PermissionDetailView(icon: "icon_outline_camera", title: "k_camera_optional".localized, description: "p_write_profile_post".localized, bgColor: Color.clear)
            }.padding([.horizontal, .top], sizeInfo.padding20)
            
            Spacer().frame(height: sizeInfo.padding20)
            
            HStack(spacing: sizeInfo.padding20) {
                PermissionDetailView(icon: "icon_outline_picture", title: "s_picture_media_file_optional".localized, description: "p_write_profile_share".localized, bgColor: Color.clear)
            }.padding([.horizontal, .bottom], sizeInfo.padding20)
        }
        .background(Color.gray25)
        .cornerRadius(sizeInfo.cornerRadius)
    }
}

#Preview {
    PermissionPage()
}
