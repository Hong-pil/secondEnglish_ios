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
            LoginStartPage()
            
//            Main()
//                .fullScreenCover(
//                    isPresented: $userManager.showLoginView,
//                    content: {
//                        LoginPage()
//                    }
//                )
            
        }
        .modifier(ContentViewAlert())
    }
}

#Preview {
    ContentView()
}
