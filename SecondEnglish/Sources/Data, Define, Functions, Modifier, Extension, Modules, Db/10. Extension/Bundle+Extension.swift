//
//  Bundle+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Bundle {
    var appVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    //Here magic happens
    //when you localize resources: for instance Localizable.strings, images
    //it creates different bundles
    //we take appropriate bundle according to language
    static var localizedBundle: Bundle {
        guard let path = Bundle.main.path(forResource: LanguageManager.shared.getLanguageCode(), ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}
