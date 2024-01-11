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
                
                // 홈탭 -> Popular탭 -> GLOBAL버튼
                if type == .GlobalLan {
                    ForEach(Array(DefineBottomSheet.globalLanItems.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomItemGlobalView(
                            type: .GlobalLan,
                            item: element,
                            selectedLang: bottomSheetManager.onPressPopularLanguage,
                            onPress: { buttonType in
                                onPressGlobalLan(buttonType)
                                if buttonType == "d_other_language_select".localized {
                                    bottomSheetManager.onPressPopularLangState = true
                                }
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
                    }
                }
                else if type == .CommunityGlobalLan {
                    ForEach(Array(DefineBottomSheet.globalLanItems.enumerated()), id: \.offset) { index, element in
                        
                        CustomBottomItemGlobalView(
                            type: .CommunityGlobalLan,
                            item: element,
                            selectedLang: bottomSheetManager.onPressComLanguage,
                            onPress: { buttonType in
                                onPressGlobalLan(buttonType)
                                if buttonType == "d_other_language_select".localized {
                                    bottomSheetManager.onPressComLangState = true
                                }
                                isShow = false
                            }
                        )
                        .padding(.top, index==0 ? 0 : 10)
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
                onPress(MoreButtonType.Save)
            case 2:
                onPress(MoreButtonType.Share)
            case 3:
                onPress(MoreButtonType.Join)
            case 4:
                onPress(MoreButtonType.Report)
            case 5:
                onPress(MoreButtonType.BoardBlock)
            case 6:
                onPress(MoreButtonType.UserBlock)
            case 7:
                onPress(MoreButtonType.Edit)
            case 8:
                onPress(MoreButtonType.Delete)
            default:
                fLog("")
            }
        }
    }
}

struct CustomBottomItemGlobalView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    let type: CustomBottomSheetClickType
    let item: CustomBottomSheetModel
    let selectedLang: String
    //let onPress: ((GlobalLanType) -> Void)
    let onPress: ((String) -> Void)
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            Button {
                switch item.SEQ {
                case 1:
                    onPress(GlobalLanType.Global.description)
                case 2:
                    onPress(GlobalLanType.MyLan.description)
                case 3:
                    onPress(GlobalLanType.AnotherLan.description)
                default:
                    fLog("switch default")
                }
            } label: {
                HStack {
                    Text(item.title)
                        .font(.body11622Regular)
                        .foregroundColor(self.compareCheckMarkOpacity(title: self.item.title) ? Color.primaryDefault : Color.gray800)
                    Spacer()
                    if item.SEQ == 3 {
                        Text(selectedLang)
                            .foregroundColor(Color.primary300)
                            .opacity(self.compareCheckMarkOpacity(title: self.item.title) ? 1 : 0)
                    } else {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.primary300)
                            .opacity(self.compareCheckMarkOpacity(title: self.item.title) ? 1 : 0)
                    }
                }
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
    
    func compareCheckMarkOpacity(title: String) -> Bool {
        if type == .GlobalLan {
            if self.bottomSheetManager.onPressPopularGlobal == title {
                return true
            } else {
                return false
            }
        }
        else if type == .CommunityGlobalLan {
           if self.bottomSheetManager.onPressCommunityGlobal == title {
                return true
            } else {
                return false
            }
        }
        return true
    }
}

struct CustomBottomCommonView: View {
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    @StateObject var languageManager = LanguageManager.shared

    let type: CustomBottomSheetClickType
    let item: CustomBottomSheetCommonModel
    let onPress: ((String) -> Void)
    var onPressSeq: ((Int) -> Void) = {_ in }
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack {
            Button {
                if type == .JoinApprovalSettingOfClub || type == .JoinApprovalTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(AutoOrApprovalType.Auto.description)
                    case 1:
                        onPress(AutoOrApprovalType.Approval.description)
                    default:
                        fLog("switch default")
                    }
                }
                else if type == .ClubOpenSettingOfClub || type == .ClubOpenTitle || type == .MemberListTitle || type == .MemberNumberListTitle || type == .ArchiveVisibilityTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(OpenOrHiddenType.Open.description)
                    case 1:
                        onPress(OpenOrHiddenType.Hidden.description)
                    default:
                        fLog("switch default")
                    }
                }
                else if type == .ArchiveTypeTitle {
                    switch item.SEQ {
                    case 0:
                        onPress(ImageOrGeneralType.Image.description)
                    case 1:
                        onPress(ImageOrGeneralType.General.description)
                    default:
                        fLog("switch default")
                    }
                }
                else if type == .RejoinSetting {
                    onPressSeq(item.SEQ)
                    switch item.SEQ {
                    case 0:
                        onPress(ProhibitionOrAllowType.Prohibition.description)
                    case 1:
                        onPress(ProhibitionOrAllowType.Allow.description)
                    default:
                        fLog("switch default")
                    }
                }
                
            } label: {
                Text(item.subTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(self.compareCheckMarkOpacity(title: self.item.subTitle) ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                Spacer()
                Text(item.subDescription)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity(self.compareCheckMarkOpacity(title: self.item.subTitle) ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
    
    func compareCheckMarkOpacity(title: String) -> Bool {
        if type == .JoinApprovalSettingOfClub {
            if self.bottomSheetManager.onPressJoinApprovalSettingOfClub == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ClubOpenSettingOfClub {
            if self.bottomSheetManager.onPressClubOpenSettingOfClub == title {
                return true
            } else {
                return false
            }
        }
        else if type == .JoinApprovalTitle {
            if self.bottomSheetManager.onPressJoinApprovalTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ClubOpenTitle {
            if self.bottomSheetManager.onPressClubOpenTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .MemberListTitle {
            if self.bottomSheetManager.onPressMemberListTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .MemberNumberListTitle {
            if self.bottomSheetManager.onPressMemberNumberListTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ArchiveTypeTitle {
            if self.bottomSheetManager.onPressArchiveTypeTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .ArchiveVisibilityTitle {
            if self.bottomSheetManager.onPressArchiveVisibilityTitle == title {
                return true
            } else {
                return false
            }
        }
        else if type == .RejoinSetting {
            if self.bottomSheetManager.onPressRejoinSettingPopupTxt == title {
                return true
            } else {
                return false
            }
        }
        return true
    }
}
