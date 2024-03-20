//
//  AlertPageViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation
import Combine
import UIKit

class AlertPageViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    @Published var isAllRead: Bool = false
    
    @Published var alimModel: AlimUserMessage?
    @Published var alimList = [AlimMessage]()
    
    
}
