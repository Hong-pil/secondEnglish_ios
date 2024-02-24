//
//  SecondEnglishApp.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

// 카카오 로그인
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


@main
struct SecondEnglishApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        NetworkMonitorManager.shared.startNetworkMonitoring()
        UserManager.shared.start()
        
        // Kakao 설정 (키 값을 번들에서 가져온다.)
        // AppDelegate에서 해도 되는데, 어차피 .onOpenURL로 카카오 설정을 해줘야 하기 때문에, 따로따로 구분짓기 싫어서 여기서 설정함
        if let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: nativeAppKey)
        }
        
        
        
    }
    
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
