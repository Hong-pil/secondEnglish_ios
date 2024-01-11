//
//  DefineSize.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct DefineSize {
    
    //safe area insets
    struct SafeArea {
        @Environment(\.safeAreaInsets) static var safeAreaInsets
        
        static let top: CGFloat = safeAreaInsets.top
        static let bottom: CGFloat = safeAreaInsets.bottom
    }
    
    //contents
    struct Contents {
        static let TopPadding: CGFloat = 15.0           //컨텐츠 네비와의 간격
        static let BottomPadding: CGFloat = 15.0
        static let HorizontalPadding: CGFloat = 20.0        //컨텐츠 좌우 여백
    }
    
    
    static let LineHeight: CGFloat = 1.0
    static let ShowTopMinY: CGFloat = -200
    static let MainTabHeight: CGFloat = 50.0            // 메인탭 높이
    
    //corner radius
    struct CornerRadius {
        static let ProfileThumbnailS: CGFloat = 12.0
        static let ProfileThumbnailM: CGFloat = 12.0
        static let ProfileThumbnailL: CGFloat = 12.0
        
        static let ClubThumbnailS: CGFloat = 12.0
        static let ClubThumbnailM: CGFloat = 12.0
        static let ClubThumbnailL: CGFloat = 12.0
        
        static let BottomSheet: CGFloat = 30.0
        
        static let TextField: CGFloat = 7.0
    }
    
    //size
    struct Size {
        static let ProfileThumbnailS: CGSize = CGSize(width: 36.0, height: 36.0)
        static let ProfileThumbnailM: CGSize = CGSize(width: 54.0, height: 54.0)
        static let ProfileThumbnailL: CGSize = CGSize(width: 80.0, height: 80.0)
        
        static let ClubThumbnailS: CGSize = CGSize(width: 38.0, height: 38.0)
        static let ClubThumbnailM: CGSize = CGSize(width: 54.0, height: 54.0)
    }
    
    //listHeight
    struct ListHeight {
        
    }
    
    //screen
    struct Screen {
        static let Width = UIScreen.main.bounds.size.width
        static let Height = UIScreen.main.bounds.size.height
        static let Size = UIScreen.main.bounds.size
    }
    
    //list size
    struct ListSize {
        static let Common: Int = 10
    }
    
    // 프로필 완성하기
    struct ProfileCompleteStepSize {
        //프로필 완성 6단계 (2023.03 / 6->관심사 1로 변경됨)
        static let Common: Int = 1
    }
    
    static func getDefaultWidth() -> CGFloat {
        return 375.0
    }
    
    static func getDefaultHeight() -> CGFloat {
        return 667.0
    }
    
    static func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    static func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func getSize(size:CGFloat) -> CGFloat {
        return size * getRatioValue()
    }
    
    static func getRatioValue() ->CGFloat {
        let defaultRatio:CGFloat = 0.92
        
        let deviceWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        if deviceWidth / getDefaultWidth() == 1.0 {
            return 1.0
        }
        else {
            let returnValue = deviceWidth / getDefaultWidth() * defaultRatio
            if returnValue <= 0.80 {
                return 0.80
            }
            
            return returnValue
        }
    }
    
    static func getTopSafeAreaHeightForPlayer() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if window!.safeAreaInsets.top == 20 {
            return 0
        }
        
        return window!.safeAreaInsets.top
    }
    
    static func getSafeAreaInsets() -> UIEdgeInsets {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window!.safeAreaInsets
    }
    
    static func getTopHeight() -> CGFloat {
        return 60 * getRatioValue() + getSafeAreaInsets().top
    }
}
