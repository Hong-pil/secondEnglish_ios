//
//  ContentView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userManager = UserManager.shared
    
    var body: some View {
        ZStack {
            Main()
                .fullScreenCover(
                    isPresented: $userManager.showLoginView,
                    content: {
                        LoginPage()
                    }
                )
         
            // 프로필 이미지 등록 기능 아직 필요성을 못 느끼겠음.
//            PermissionPage()
//                .opacity(userManager.isFirstLaunching ? 1.0 : 0.0)
        }
        .modifier(ContentViewAlert())
        .modifier(ContentViewPopup())
        
    }
}

#Preview {
    ContentView()
}
