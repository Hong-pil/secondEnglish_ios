//
//  Shape+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI

extension Shape {
    
    /**
     * RoundedRectangle() 에서 stroke, fill 을 함께 사용할 수 있도록, extension 으로 함수를 추가했음
     */
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
    }
}
