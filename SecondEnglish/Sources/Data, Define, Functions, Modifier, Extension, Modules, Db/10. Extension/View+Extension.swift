//
//  View+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

public extension View {
    func implementPopupView() -> some View {
        overlay(PopupView())
    }
}

// MARK: -Alignments
extension View {
    func alignToBottom(_ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            Spacer()
            self
            Spacer.height(value)
        }
    }
    func alignToTop(_ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            Spacer.height(value)
            self
            Spacer()
        }
    }
}

// MARK: -Content Height Reader
extension View {
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(heightReader).onPreferenceChange(HeightPreferenceKey.self, perform: action)
    }
}
private extension View {
    var heightReader: some View { GeometryReader {
        Color.clear.preference(key: HeightPreferenceKey.self, value: $0.size.height)
    }}
}
fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: -Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View {
        if condition { self }
    }
    func visible(if condition: Bool) -> some View {
        opacity(condition.doubleValue)
    }
}

extension View {
//    func setTabBarVisibility(isHidden: Bool) -> some View {
//        background(TabBarAccessor(callback: { tabBar in
//            tabBar.isHidden = true
//        }))
//    }
    
    /// 탭바 숨김 처리 여부
    /// - Parameter isHidden:
    /// - Returns:
    func setTabBarVisibility(isHidden : Bool) -> some View {
        background(TabBarAccessor { tabBar in
            print(">> TabBar height: \(tabBar.bounds.height)")
            // !! use as needed, in calculations, @State, etc.
            // 혹은 높이를 변경한다던지 여러가지 설정들이 가능하다.
            tabBar.isHidden = isHidden
        })
    }
}
