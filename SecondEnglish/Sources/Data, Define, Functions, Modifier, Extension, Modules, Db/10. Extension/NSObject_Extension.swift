//
//  NSObject_Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    var className: String {
            return String(describing: type(of: self))
        }
        
        class var className: String {
            return String(describing: self)
        }
}
