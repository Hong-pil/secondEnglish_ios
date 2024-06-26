//
//  BarView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct BarView: View {
    
    let isRecording: Bool
    var value: CGFloat = 0
    
    var sample: SampleModel?
    
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.green)
            .frame(width: isRecording ? 10 : 5, height: isRecording ? value : normalizeSoundLevel(level: sample?.sample ?? 0))
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 40) / 2
        return level
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(isRecording: true)
    }
}
