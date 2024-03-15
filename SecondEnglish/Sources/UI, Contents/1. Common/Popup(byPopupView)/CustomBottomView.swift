//
//  CustomBottomView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct CustomBottomView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    let title: String
    let type: CustomBottomSheetClickType
    var onPressItemMore: ((MoreButtonType) -> Void) = {_ in}
    var onPressItemReportCode: ((Int) -> Void) = {_ in}
    var onPressItemCutPercent: ((CGFloat) -> Void) = {_ in}
    
    //var onPressGlobalLan: ((GlobalLanType) -> Void) = {_ in }
    var onPressGlobalLan: ((String) -> Void) = {_ in }
    var onPressCommon: ((String) -> Void) = {_ in }
    var onPressCommonSeq: ((Int) -> Void) = {_ in }
    var onPressBoardReport: ((Int) -> Void) = {_ in }
    @Binding var isShow: Bool
    //    @Published var onPressItemMore: HomePageItemMoreType = .None
    //    let onPressItemMore: ((HomePageItemMoreType) -> Void) = {
    //        (_ : HomePageItemMoreType ) in
    //    }
    
    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 22.0
        static let hPadding: CGFloat = 30.0
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if !title.isEmpty {
                    HStack(spacing: 0) {
                        Text(title)
                            .font(.title51622Medium)
                            .foregroundColor(.stateEnableGray900)
                        Spacer()
                    }
                    .padding(.bottom, sizeInfo.titleBottomPadding)
                }
                
                // Swipe Tab -> More
                if type == .SwipeCardMore {
                    ForEach(Array(DefineBottomSheet.cardMoreItem.enumerated()), id: \.offset) { index, element in
                        CustomBottomItemMoreView(
                            item: element,
                            onPress: { buttonType in
                                onPressItemMore(buttonType)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 10 : 20)
                    }
                }
                else if type == .SwipeCardReport {
                    ForEach(Array(DefineBottomSheet.reportListItems.enumerated()), id: \.offset) { index, element in
                        CustomBottomItemReportView(
                            item: element,
                            onPress: { reportCode in
                                onPressItemReportCode(reportCode)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 10 : 20)
                    }
                }
                else if type == .SwipeCardCut {
                    ForEach(Array(DefineBottomSheet.swipeCardCutPercentItems.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomItemSwipeCardCutView(
                            item: element,
                            onPress: { percent in
                                onPressItemCutPercent(percent)
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 10 : 20)
                    }
                }
                else if type == .SliderAuto {
                    Text("halo")
                }
                
                Spacer()
            }
            .padding(.horizontal, sizeInfo.hPadding)
        }
    }
}

struct CustomBottomItemMoreView: View {
    
    @StateObject var languageManager = LanguageManager.shared

    let item: CustomBottomSheetModel
    let onPress: ((MoreButtonType) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(item.image)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(item.title)
                .font(.body11622Regular)
                .foregroundColor(.gray870)
                .padding(.leading, 20)
            
            Spacer()
        }
        .background(Color.gray25)
        .onTapGesture {
            switch item.SEQ {
            case 1:
                onPress(MoreButtonType.Report)
            case 2:
                onPress(MoreButtonType.BoardBlock)
            case 3:
                onPress(MoreButtonType.UserBlock)
            default:
                fLog("")
            }
        }
    }
}

struct CustomBottomItemReportView: View {
    let item: ReportListData
    let onPress: ((Int) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(item.name ?? "")
                .font(.body11622Regular)
                .foregroundColor(.gray870)
                .padding(.leading, 20)
            
            Spacer()
        }
        .background(Color.gray25)
        .onTapGesture {
            onPress(item.code ?? 0)
        }
    }
}

struct CustomBottomItemSwipeCardCutView: View {
    let item: CustomBottomSheetModel
    let onPress: ((CGFloat) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(item.title)
                .font(.body11622Regular)
                .foregroundColor(.gray870)
                .padding(.leading, 20)
            
            Spacer()
        }
        .background(Color.gray25)
        .onTapGesture {
            switch item.SEQ {
            case 1:
                // 30% 자르기
                onPress(SwipeCardCutType.Percent_30.rawValue)
            case 2:
                // 50% 자르기
                onPress(SwipeCardCutType.Percent_50.rawValue)
            case 3:
                // 70% 자르기
                onPress(SwipeCardCutType.Percent_70.rawValue)
            default:
                fLog("")
            }
        }
    }
    
}
