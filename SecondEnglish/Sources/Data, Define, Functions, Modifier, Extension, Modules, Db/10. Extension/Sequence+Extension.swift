//
//  Sequence+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

// 배열의 중복되는 원소 제거하는 방법
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
