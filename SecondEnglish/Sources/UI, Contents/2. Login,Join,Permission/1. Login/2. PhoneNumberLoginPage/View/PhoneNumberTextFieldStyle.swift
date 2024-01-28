//
//  PhoneNumberTextFieldStyle.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/28/24.
//

import SwiftUI

struct PhoneNumberTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
