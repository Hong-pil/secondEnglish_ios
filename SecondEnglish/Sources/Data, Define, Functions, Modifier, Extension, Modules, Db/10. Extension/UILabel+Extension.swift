//
//  UILabel+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension UILabel {
    func minuteShadow() {
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
    }
}
