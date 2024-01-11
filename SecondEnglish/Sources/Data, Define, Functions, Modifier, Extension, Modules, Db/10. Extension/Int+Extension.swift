//
//  Int+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Int {
    var doubleValue: Double { Double(self) }
    var floatValue: CGFloat { CGFloat(self) }
    var boolValue: Bool { return self != 0 }
    
    func timeStringMMSS() -> String {
        let minutes = self / 60 % 60
        let seconds = self % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func formatPoints() -> String {
        var result = "\(self)"
        
        if self >= 10000 && self < 10000000 {
            let remind = self % 1000
            let k = Double(self) / 1000.0
            
            if remind >= 100 {
                //fLog("-------\nvalue : \(self)\nremind : \(remind)\nk : \(k)\n----------------------------")
                result = String(format: "%.1fK", k)
            }
            else {
                result = String(format: "%.0fK", k)
            }
        }
        else if self >= 10000000 {
            let remind = self % 1000000
            let m = Double(self) / 1000000
            
            if remind >= 100000 {
                result = String(format: "%.1fM", m)
            }
            else {
                result = String(format: "%.0fM", m)
            }
        }
        
        return result
    }
}
