//
//  UIWindow+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
