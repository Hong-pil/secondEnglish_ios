//
//  TranslateLoadingView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import Lottie

struct TranslateLoadingView: View {
    
    let width: CGFloat
    let height: CGFloat
    let loadingHeight: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        self.loadingHeight = height/2
    }
    
    var body: some View {
        ZStack {
            Image("icon_translation_loading")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primaryDefault)
                .frame(width: width, height: height)
            
            LottieView(jsonName: "translation_laoding")
                .frame(width: width, height: loadingHeight)
        }
        .animation(nil)
        .animation(.default)
    }
}
