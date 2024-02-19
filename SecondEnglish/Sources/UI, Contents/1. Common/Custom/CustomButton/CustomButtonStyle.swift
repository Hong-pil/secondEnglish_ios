//
//  CustomButtonStyle.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/19/24.
//

import Foundation
import SwiftUI

struct MyButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.gray25)
      .background(configuration.isPressed ? Color.gray25 : Color.stateEnablePrimaryDefault)
      .cornerRadius(8.0)
  }
}
