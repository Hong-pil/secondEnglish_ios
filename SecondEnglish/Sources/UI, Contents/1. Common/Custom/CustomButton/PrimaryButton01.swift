//
//  PrimaryButton01.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct PrimaryButton01: ButtonStyle {
    var isActiveBinding: Bool
    var textActiveColor: Color = Color.black
    var textInactiveColor: Color = Color.black
    var backgroundActiveColor: Color = Color.black
    var backgroundInactiveColor: Color = Color.black
    @Binding var isTextActive: Bool
    @Binding var isBackgroundActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title41824Medium)
            .foregroundColor(isActiveBinding
                             ?
                             (isTextActive ? textActiveColor : textInactiveColor)
                             : Color.gray25
            )
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(isActiveBinding ? Color.gray25 : Color.primaryDefault)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        isBackgroundActive ? backgroundActiveColor : backgroundInactiveColor
                        , lineWidth: isActiveBinding ? 1 : 0
                    )
            )
    }
}
