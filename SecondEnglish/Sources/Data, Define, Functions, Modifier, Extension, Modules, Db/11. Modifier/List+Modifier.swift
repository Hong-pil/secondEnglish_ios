//
//  List+Modifier.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation
import SwiftUI

struct ListInsetGroupedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.gray100, radius: 2, x: 0, y: 2)
            .listStyle(.insetGrouped)
            .background(Color.bgLightGray50)
    }
}

struct CornerRadiusListModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.gray25
                .cornerRadius(15)
                .background {
                    Color.gray900
                        .cornerRadius(15)
                        .blur(radius: 2, opaque: false)
                        .opacity(0.12)
                }
            content
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
}

struct ScrollViewLazyVStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, DefineSize.Contents.TopPadding)
            .padding(.bottom, DefineSize.Contents.BottomPadding)
    }
}

struct ScrollViewLazyVStackModifierBottom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, DefineSize.Contents.BottomPadding)
    }
}

struct ListRowModifier: ViewModifier {
    let rowHeight:CGFloat
    func body(content: Content) -> some View {
        content
//            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)
            .frame(height: rowHeight)
    }
}
