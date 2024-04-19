//
//  DefineNotification.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

class DefineNotification: NSObject {
    
    static let moveToSwipeTab = "moveToSwipeTab"
    static let setEditMode = "setEditMode"
    static let cardEditSuccess = "cardEditSuccess"
    
    //change minute
    static let changeMinuteDetail = "changeMinuteDetail"        //좋아요, 싫어요, 북마크가 변경되었을 때.
    static let changeMinuteFavorite = "changeMinuteFavorite"        //북마크가 변경되었을때, remove, insert
    static let changeMinuteBlock = "changeMinuteBlock"      //minute 차단
    static let changeMinuteCommentBlock = "changeMinuteCommentBlock"      //minute comment 차단
    static let changeAccountBlock = "changeAccountBlock"      //계정 차단
    static let minuteFromNewest = "minuteFromNewest"      // from Newest Tab
    
    static let changeLoginStatus = "changeLoginStatus"      //로그인/로그아웃이 되었다.
    static let changeLanguage = "changeLanguage"      //언어변경 시
    
    static let refreshConverstion = "refreshConverstion"      //로그아웃, 로그인 시
}
