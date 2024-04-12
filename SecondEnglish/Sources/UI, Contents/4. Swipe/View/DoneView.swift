//
//  DoneView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/12/24.
//

import SwiftUI

struct DoneView: View {
    let reload: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Text("You've filled in all the cards!")

            Button("Refresh") {
                reload()
            }.buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.bgLightGray50)
    }
}

//#Preview {
//    DoneView()
//}
