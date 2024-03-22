//
//  ContentViewPopup.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/24/24.
//

import Foundation
import SwiftUI

struct ContentViewPopup: ViewModifier {
    
    @StateObject var userManager = UserManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject var languageManager = LanguageManager.shared
    
    private struct BottomSheetInfo {
        static let bigHeight: CGFloat = 765
        static let middleHeight: CGFloat = 290
        static let middleHalfHeight: CGFloat = 250
        static let smallHeight: CGFloat = 210
        static let onlyOne: CGFloat = 160
        static let boardReportHeight: CGFloat = 420
    }
    
    func body(content: Content) -> some View {
        content
            // Swipe Tab -> 카드 더보기
            .bottomSheet(
                isPresented: $bottomSheetManager.show.swipeCardMore,
                height: self.getPopupHeight(type: CustomBottomSheetClickType.SwipeCardMore),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "", // 제목없는 팝업뷰
                        type: CustomBottomSheetClickType.SwipeCardMore,
                        onPressItemMore: { buttonType in
                            //fLog("\n--- \(buttonType) ---\n")
                            bottomSheetManager.pressedCardMorType = buttonType
                        },
                        isShow: $bottomSheetManager.show.swipeCardMore
                    )
                }
            )
            // Swipe Tab -> 카드 더보기 - 신고하기
            .bottomSheet(
                isPresented: $bottomSheetManager.show.swipeCardReport,
                height: self.getPopupHeight(type: CustomBottomSheetClickType.SwipeCardReport),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "", // 제목없는 팝업뷰
                        type: CustomBottomSheetClickType.SwipeCardReport,
                        onPressItemReportCode: { reportCode in
                            //fLog("\n--- \(reportCode) ---\n")
                            bottomSheetManager.pressedCardReportCode = reportCode
                        },
                        isShow: $bottomSheetManager.show.swipeCardReport
                    )
                }
            )
            // Swipe Tab -> 카드 자르기
            .bottomSheet(
                isPresented: $bottomSheetManager.show.swipeCardCut,
                height: self.getPopupHeight(type: CustomBottomSheetClickType.SwipeCardCut),
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    CustomBottomView(
                        title: "", // 제목없는 팝업뷰
                        type: CustomBottomSheetClickType.SwipeCardCut,
                        onPressItemCutPercent: { percent in
                            fLog("\n--- \(percent) ---\n")
                            bottomSheetManager.pressedCardCutPercent = percent
                        },
                        isShow: $bottomSheetManager.show.swipeCardCut
                    )
                }
            )
            // Swipe Tab -> HELP
            .bottomSheet(
                isPresented: $bottomSheetManager.show.grammarInfo,
                height: .infinity,
                topBarCornerRadius: DefineSize.CornerRadius.BottomSheet,
                content: {
                    GrammarInfoView()
                }
            )
        
    }
    
    func getPopupHeight(type: CustomBottomSheetClickType) -> CGFloat {
        var finalHeight: CGFloat = 0.0
        
        switch type {
        case .SwipeCardMore:
            finalHeight = self.defineSize(isTitleEmpty: true, size: DefineBottomSheet.cardMoreItem.count)
        case .SwipeCardReport:
            finalHeight = self.defineSize(isTitleEmpty: true, size: DefineBottomSheet.reportListItems.count)
        case .SwipeCardCut:
            finalHeight = self.defineSize(isTitleEmpty: true, size: DefineBottomSheet.swipeCardCutPercentItems.count)
        default:
            finalHeight = 100
        }
        return finalHeight
    }
    
    func defineSize(isTitleEmpty: Bool, size: Int) -> CGFloat {
        var finalHeight: CGFloat = 0.0
        if size > 0 {
            switch size {
            case 1...3:
                finalHeight = 200.0
            case 4...6:
                finalHeight = 330.0
            case 7...9:
                finalHeight = 450.0
            case 10...12:
                finalHeight = 580.0
            case 13...15:
                finalHeight = 700.0
            case 16..<18:
                finalHeight = 810.0
            default:
                finalHeight = .infinity
            }
        }
        
        
        
        // 팝업 상단 타이틀이 있는 경우 -> 타이틀 높이를 더해줌
        if !isTitleEmpty {
            if size == 1 {
                finalHeight += 80.0
            }
            else {
                finalHeight += 50.0
            }
        }
        return finalHeight
    }
}
