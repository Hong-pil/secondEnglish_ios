//
//  TabManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI


class TabStateHandlerManager: ObservableObject {
    static let shared = TabStateHandlerManager()
    
    @Published var selection: bTab = .my {
        didSet {
            if oldValue == selection && selection == .my {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .swipe_card {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .calendar {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .settings {
                moveFirstTabToTop.toggle()
            }
        }
    }
    
    @Published var moveFirstTabToTop: Bool = false
}
