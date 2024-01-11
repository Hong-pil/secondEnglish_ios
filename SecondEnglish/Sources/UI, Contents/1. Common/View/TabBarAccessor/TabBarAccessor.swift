//
//  TabBarAccessor.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI
import UIKit

// UITabBarController 에 탭바를 가져오기 위한 TabBarAccessor
// Helper bridge to UIViewController to access enclosing UITabBarController
// and thus its UITabBar
struct TabBarAccessor: UIViewControllerRepresentable {
    
    var callback : (UITabBar) -> Void
    
    private let proxyController = ProxyViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) -> UIViewController {
        
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
        
    }
    
    // viewWillAppear 가 탈때 가지고 있는 탭바를 클로저 콜백으로 넘겨준다.
    private class ProxyViewController: UIViewController {
        
        var callback : (UITabBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if let tabBarController = self.tabBarController {
                callback(tabBarController.tabBar)
            }
        }
    }
}
