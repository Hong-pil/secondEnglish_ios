//
//  TabHomePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct TabHomePage {
    @State private var showTestPage: Bool = false
}

extension TabHomePage: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("This is TabHomePage")
            
            Spacer()
            
            Button(action: {
                showTestPage = true
            }, label: {
                Text("툴바 셈플 페이지 이동")
            })
            .buttonStyle(PrimaryButton01(
                isActiveBinding: false,
                isTextActive: .constant(false),
                isBackgroundActive: .constant(false))
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.green.opacity(0.5))
        .fullScreenCover(isPresented: $showTestPage) {
            TextPage()
        }
    }
}

#Preview {
    TabHomePage()
}
