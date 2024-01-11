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
    
    @Published var selection: bTab = .home {
        didSet {
            if oldValue == selection && selection == .home {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .pet_life {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .pets {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .chatting {
                moveFirstTabToTop.toggle()
            }
            else if oldValue == selection && selection == .profile {
                moveFirstTabToTop.toggle()
            }
        }
    }
    
    @Published var moveFirstTabToTop: Bool = false
}
