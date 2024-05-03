//
//  CountingNumberAnimationModifier.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/22/24.
//

import SwiftUI

struct CountingNumberAnimationModifier: AnimatableModifier {
    let doneViewType: DoneViewType
    var number: CGFloat = 0
    
    private struct sizeInfo {
        //static let learnColor: Color = Color(red: 230/255.0, green: 207/255.0, blue: 107/255.0, opacity: 1)
        static let learnColor: Color = Color(red: 219/255.0, green: 179/255.0, blue: 60/255.0, opacity: 1)
        static let knowColor: Color = Color(red: 140/255.0, green: 204/255.0, blue: 231/255.0, opacity: 1)
        
    }
    
    var animatableData: CGFloat {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(NumberLabelView(doneViewType: doneViewType, number: number))
    }
    
    struct NumberLabelView: View {
        let doneViewType: DoneViewType
        let number: CGFloat
        
        var body: some View {
            Text("\(doneViewType.rawValue) \(Int(number))%")
                .font(.buttons1420Medium)
                .foregroundColor(doneViewType == .know ? sizeInfo.knowColor : sizeInfo.learnColor)
        }
    }
}

//#Preview {
//    CountingNumberAnimationModifier()
//}
