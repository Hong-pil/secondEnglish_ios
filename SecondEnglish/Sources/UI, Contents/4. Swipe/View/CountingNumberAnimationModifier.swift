//
//  CountingNumberAnimationModifier.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/22/24.
//

import SwiftUI

struct CountingNumberAnimationModifier: AnimatableModifier {
    let subCategory: String
    var number: CGFloat = 0
    
    var animatableData: CGFloat {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(NumberLabelView(subCategory: subCategory, number: number))
    }
    
    struct NumberLabelView: View {
        let subCategory: String
        let number: CGFloat
        
        var body: some View {
            HStack(spacing: 15) {
                Text(subCategory)
                    .font(.title5Roboto1622Medium)
                    .foregroundColor(.gray800)
                    .padding(.bottom, 7)
                
                Text("\(Int(number))%")
                    .font(.title5Roboto1622Medium)
                    .foregroundColor(.stateActivePrimaryDefault)
                    .padding(.bottom, 7)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//#Preview {
//    CountingNumberAnimationModifier()
//}
