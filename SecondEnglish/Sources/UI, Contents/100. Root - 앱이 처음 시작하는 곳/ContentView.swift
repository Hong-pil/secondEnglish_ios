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
         
            PermissionPage()
                .opacity(userManager.isFirstLaunching ? 1.0 : 0.0)
        }
        .task {
            fLog("idpilLog::: showLoginView : \(userManager.showLoginView)")
        }
        .modifier(ContentViewAlert())
        
    }
}

#Preview {
    ContentView()
}
