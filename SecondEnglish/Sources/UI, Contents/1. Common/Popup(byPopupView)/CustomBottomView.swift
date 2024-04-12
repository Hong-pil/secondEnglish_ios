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
    var onPressSwipeCutItem: ((SwipeCardCutType) -> Void) = {_ in}
    
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
                    VStack(spacing: 0) {
                        ForEach(Array(DefineBottomSheet.swipeCardCutPercentItems.enumerated()), id: \.offset) { index, element in
                            
                            Text(DefineBottomSheet.swipeCardCutTypeItems[index].title)
                                .font(.title51622Medium)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray800)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, index==0 ? 10 : 20)
                                .padding(.bottom, 7)
                            
                            HStack(spacing: 0) {
                                ForEach(Array(element.enumerated()), id: \.offset) { index2, item in
                                    CustomBottomItemSwipeCardCutView(
                                        item: item,
                                        onPress: { percent in
                                            onPressSwipeCutItem(percent)
                                            isShow = false
                                        }
                                    )
                                }
                            }
                        }
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
    let item: SwipeCutBottomSheetModel
    let width: CGFloat = 50.0
    let height: CGFloat = 50.0
    let lineWidth: CGFloat = 7.0
    let color: Color = Color.stateActivePrimaryDefault
    
    let onPress: ((SwipeCardCutType) -> Void)
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        // width의 비율에 따라 선의 두께를 지정하기 위해 multiplier 설정
        let multiplier = width / 40
        //트림하고 남은 영역이 진행 상태를 나타내는 부분으로 이를 역으로 계산
        //에를 들어 0.1 에서 1.0 까지 트림하는 경우 원의 10% 부분이 잘리고 남아있는 부분은 90%가 됨
        let progress = 1 - (item.percent / 100)
        
        ZStack {
            //배경 원의 stroke 함수를 통해서 원의 외곽선을 그리고 원의 크기 지정
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: lineWidth * multiplier, lineCap: .round))
                .frame(width: width, height: height)
            
            //trim 함수를 이용해 progress 값만 큼 원의 외곽선을 잘라 냄
            Circle()
                .trim(from: progress, to: 1)
            
            //진행바는 리니어 그라데이션을 이용
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth * multiplier, lineCap: .round))
                .frame(width: width, height: height)
            //상태바가 오른쪽 끝에서 반 시계 방향으로 회전하므로 이를 위쪽 끝에서 시계방향으로
            //이동하게 하기 위해 시계 방향 90도 이동후 x축을 기준으로 뒤집어 준다.
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                //.shadow(color: color2, radius: 14 * multiplier, x: 0.0, y: 14 * multiplier) // 그림자 효과는 필요 없음.
            
            //진행상황 표시용 레이블
            Text("\(Int(item.percent))")
                .font(.buttons1420Medium)
                //.font(.system(size : 10 * multiplier))
                .fontWeight(.bold)
                .foregroundColor(.gray700)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.gray25)
        .onTapGesture {
            switch item.SEQ {
            case 1:
                // 30% 앞에서부터 자르기
                onPress(SwipeCardCutType.Front_30)
            case 2:
                // 50% 앞에서부터 자르기
                onPress(SwipeCardCutType.Front_50)
            case 3:
                // 70% 앞에서부터 자르기
                onPress(SwipeCardCutType.Front_70)
            case 4:
                // 30% 뒤에서부터 자르기
                onPress(SwipeCardCutType.Back_30)
            case 5:
                // 50% 뒤에서부터 자르기
                onPress(SwipeCardCutType.Back_50)
            case 6:
                // 70% 뒤에서부터 자르기
                onPress(SwipeCardCutType.Back_70)
            case 7:
                // 30% 랜덤 자르기
                onPress(SwipeCardCutType.Random_30)
            case 8:
                // 50% 랜덤 자르기
                onPress(SwipeCardCutType.Random_50)
            case 9:
                // 70% 랜덤 자르기
                onPress(SwipeCardCutType.Random_70)
            default:
                fLog("")
            }
        }
    }
    
    
//    var body: some View {
//        HStack(spacing: 0) {
//            Text(item.title)
//                .font(.body11622Regular)
//                .foregroundColor(.gray870)
//                .padding(.leading, 20)
//            
//            Spacer()
//        }
//        .background(Color.gray25)
//        .onTapGesture {
//            switch item.SEQ {
//            case 1:
//                // 30% 자르기
//                onPress(SwipeCardCutType.Percent_30.rawValue)
//            case 2:
//                // 50% 자르기
//                onPress(SwipeCardCutType.Percent_50.rawValue)
//            case 3:
//                // 70% 자르기
//                onPress(SwipeCardCutType.Percent_70.rawValue)
//            default:
//                fLog("")
//            }
//        }
//    }
    
}
