//
//  NavigationBarActionManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation
import Combine

class NavigationBarActionManager: ObservableObject {
    static let shared = NavigationBarActionManager()
    
    var buttonActionSubject = PassthroughSubject<(String, CustomNavigationBarButtonType), Never>()
}
