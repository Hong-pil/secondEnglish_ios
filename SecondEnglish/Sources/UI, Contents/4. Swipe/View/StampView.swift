//
//  StampView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI

struct StampView: View {
    let label: String
    let color: Color

//    var body: some View {
//        Text(label)
//            .tracking(2.5)
//            .font(.largeTitle)
//            .bold()
//            .textCase(.uppercase)
//            .multilineTextAlignment(.center)
//            .foregroundColor(color)
//            .padding(10)
//            .border(color, width: 4)
//            .cornerRadius(4)
//    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text(label)
                    .font(.title22432Bold)
                    .foregroundColor(color)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(color))
        }
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StampView(label: "외웠음 O.O", color: .green)
            StampView(label: "외울것 ㅠ.ㅠ", color: .red)
            StampView(label: "Key Insight", color: .blue)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
