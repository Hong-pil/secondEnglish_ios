//
//  WebPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/30/24.
//

import SwiftUI

struct WebPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var url: String
    var title: String
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let tabViewHeight: CGFloat = 40.0
        static let toolBarCancelButtonSize: CGFloat = 20.0
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                    WebView(url: URL(string: url)!)
            }
            .toolbar {
                // 취소버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_outline_cancel")
                            .resizable()
                            .frame(width: sizeInfo.toolBarCancelButtonSize, height: sizeInfo.toolBarCancelButtonSize)
                    })
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
//    var body: some View {
//        VStack(spacing: 0) {
//                WebView(url: URL(string: url)!)
//        }
//        .onDisappear() {
//            CommonFunction.offPageLoading()
//        }
//        
//        .edgesIgnoringSafeArea(.bottom)
//        
//        .background(Color.gray25)
//        .navigationType(leftItems: [.Back],
//                        rightItems: [],
//                        leftItemsForegroundColor: .black,
//                        rightItemsForegroundColor: .black,
//                        title: title,
//                        onPress: { buttonType in
//        })
//        .navigationBarBackground {
//            Color.gray25
//        }
//        .statusBarStyle(style: .darkContent)
//    }
}
