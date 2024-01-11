//
//  Array+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) {
        if prerequisite { append(newElement) }
    }
    @inlinable mutating func removeLast() {
        if !isEmpty { removeLast(1) }
    }
}
