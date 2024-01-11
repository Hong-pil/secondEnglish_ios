//
//  LoadingViewContainer.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct LoadingViewContainer<Content>: View where Content: View {
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
            
            LoadingView()
        }
    }
}

