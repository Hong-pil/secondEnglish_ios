//
//  TextPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct TextPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("툴바 테스트")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        closeButton
                    })
                }
            }
        }
    }
    
    //MARK: - toolBarButton
    private var closeButton: some View {
        HStack(spacing: 0) {
            Image("icon_outline_cancel")
        }
    }
}

#Preview {
    TextPage()
}
