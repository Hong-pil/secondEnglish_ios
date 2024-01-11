//
//  LoadingViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Combine

class LoadingViewModel: ObservableObject {
    
    private var loadingTimer: Timer?
    private let loadingTime = 15.0
    
    @Published var loadingStatus: LoadingStatus = .Close {
        didSet {
            if loadingStatus != .Close {
                startLoadingTimer()
            }
        }
    }
    
    func startLoadingTimer() {
        if loadingTimer != nil && loadingTimer!.isValid {
            loadingTimer!.invalidate()
        }
        
        if loadingStatus != .ShowWithUntouchableUnlimited {
            loadingTimer = Timer.scheduledTimer(timeInterval: loadingTime, target: self, selector: #selector(checkLoadingTimer), userInfo: nil, repeats: false)
        }
    }
    
    @objc func checkLoadingTimer() {
        loadingStatus = .Close
    }
}
