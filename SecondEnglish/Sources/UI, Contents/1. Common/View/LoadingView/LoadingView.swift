//
//  LoadingView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    @StateObject var statusManager = StatusManager.shared
    
    var body: some View {
        ZStack {
//            Color.black.opacity(statusManager.loadingStatus == .ShowWithTouchable ? 0.0 : 0.4)
//                .ignoresSafeArea()
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
//            Circle()
//                .fill(Color.gray25.opacity(0.75))
//                .frame(width: 110, height: 110)
//                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 0)
//                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                
            // 이상하게도..
            // Assets.xcassets 과 /Resources/Image 경로 둘 다 파일이 있어야 됨
            if statusManager.loadingStatus == .Close {
                
            }
            else {
                //editor_post_loading
//                AnimatedImage(name: "character_loading.gif")
//                    .resizable()
//                    .frame(width: 200, height: 200)
                
                LottieView(jsonName: "editor_post_loading")
                    .frame(maxWidth: 200, maxHeight: 200)
            }
        }
        .opacity(statusManager.loadingStatus == .Close ? 0.0 : 1.0)
        //.transition(.asymmetric(insertion: AnyTransition.opacity, removal: AnyTransition.opacity))
    }
}
