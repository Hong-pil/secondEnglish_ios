//
//  Button+Modifier.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/23/24.
//

import SwiftUI

struct ButtonTextMinimunScaleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 5)
            .minimumScaleFactor(0.01)
    }
}
