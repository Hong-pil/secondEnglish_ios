//
//  CommonButton.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/23/24.
//

import SwiftUI

struct CommonButton : View {
    var title : String
    var bgColor : Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .foregroundColor(Color.gray25)
                .font(Font.buttons1420Medium)
                .modifier(ButtonTextMinimunScaleModifier())
        }
        .frame(height: 42)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(bgColor)
        .cornerRadius(42/2)
    }
}

struct CommonButton_Previews: PreviewProvider {
    static var previews: some View {
        CommonButton(title: "버튼타이틀", bgColor: Color.primary500)
    }
}
