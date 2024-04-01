//
//  HomePageViewOffsetKey.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/1/24.
//

import SwiftUI

// A preference key to store ScrollView offset
// ScrollView offset 값 저장
struct HomePageViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
