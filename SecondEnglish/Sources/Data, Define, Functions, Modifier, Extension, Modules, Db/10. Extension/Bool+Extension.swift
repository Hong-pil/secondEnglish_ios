//
//  Bool+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Bool {
    var intValue: Int { return self ? 1 : 0 }
    var doubleValue: Double { self ? 1 : 0 }
    var floatValue: CGFloat { self ? 1 : 0 }
}
