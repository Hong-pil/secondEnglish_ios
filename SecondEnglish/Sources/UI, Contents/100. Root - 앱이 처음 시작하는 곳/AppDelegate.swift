//
//  AppDelegate.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/12/24.
//

import Foundation
import SwiftUI
// Firebase
import FirebaseCore
import FirebaseAuth
// 구글 로그인
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 초기화 하는 코드는 여기서(didFinishLaunchingWithOptions 있는 곳) 하면 됨
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2)
        
        // Firebase 설정
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
