//
//  Dictionary+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Dictionary {
    func toString() -> String? {
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        }catch{
            //_log.e(error.localizedDescription)
            return nil
        }
    }
}
