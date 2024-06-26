//
//  StatusManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Combine

class StatusManager: ObservableObject {
        
    static let shared = StatusManager()
    
    private var loadingTimer: Timer?
    private let loadingTime = 15.0
    
    @Published var loadingStatus: LoadingStatus = .Close {
        didSet {
            if loadingStatus != .Close {
                startLoadingTimer()
            }
        }
    }
    
    @Published var stopAllLoadingState = Date()    //모든 로딩을 멈추는데 사용.
    
    
    //MARK: - Method
    func stopAllLoading() {
        stopAllLoadingState = Date()
        loadingStatus = .Close
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
