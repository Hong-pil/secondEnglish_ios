//
//  DoneView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/12/24.
//

import SwiftUI
import SwiftUINavigationBarColor
import SPConfetti

struct DoneView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var userManager = UserManager.shared
    
    let list: [KnowCardLocalInfo]
    let isLastMainCategory: Bool
    let cancle: () -> Void
    let nextStep: () -> Void
    let reload: () -> Void
    let isShowLoginView: () -> Void
    
    @State private var progressPercent_0: CGFloat = 0.0
    @State private var progressPercent_1: CGFloat = 0.0
    @State private var progressPercent_2: CGFloat = 0.0
    @State private var progressPercent_3: CGFloat = 0.0
    @State private var progressPercent_4: CGFloat = 0.0
    @State private var progressPercent_5: CGFloat = 0.0
    @State private var progressPercent_6: CGFloat = 0.0
    @State private var progressPercent_7: CGFloat = 0.0
    @State private var progressPercent_8: CGFloat = 0.0
    @State private var progressPercent_9: CGFloat = 0.0
    @State private var progressPercent_10: CGFloat = 0.0
    @State private var progressPercent_11: CGFloat = 0.0
    @State private var progressPercent_12: CGFloat = 0.0
    @State private var progressPercent_13: CGFloat = 0.0
    @State private var progressPercent_14: CGFloat = 0.0
    @State private var progressPercent_15: CGFloat = 0.0
    @State private var progressPercent_16: CGFloat = 0.0
    @State private var progressPercent_17: CGFloat = 0.0
    @State private var progressPercent_18: CGFloat = 0.0
    @State private var progressPercent_19: CGFloat = 0.0
    
    @State private var progressWidth_0: CGFloat = 0.0
    @State private var progressWidth_1: CGFloat = 0.0
    @State private var progressWidth_2: CGFloat = 0.0
    @State private var progressWidth_3: CGFloat = 0.0
    @State private var progressWidth_4: CGFloat = 0.0
    @State private var progressWidth_5: CGFloat = 0.0
    @State private var progressWidth_6: CGFloat = 0.0
    @State private var progressWidth_7: CGFloat = 0.0
    @State private var progressWidth_8: CGFloat = 0.0
    @State private var progressWidth_9: CGFloat = 0.0
    @State private var progressWidth_10: CGFloat = 0.0
    @State private var progressWidth_11: CGFloat = 0.0
    @State private var progressWidth_12: CGFloat = 0.0
    @State private var progressWidth_13: CGFloat = 0.0
    @State private var progressWidth_14: CGFloat = 0.0
    @State private var progressWidth_15: CGFloat = 0.0
    @State private var progressWidth_16: CGFloat = 0.0
    @State private var progressWidth_17: CGFloat = 0.0
    @State private var progressWidth_18: CGFloat = 0.0
    @State private var progressWidth_19: CGFloat = 0.0
    
    
    
    
    @State private var progressKnowPercent_0: CGFloat = 0.0
    @State private var progressKnowPercent_1: CGFloat = 0.0
    @State private var progressKnowPercent_2: CGFloat = 0.0
    @State private var progressKnowPercent_3: CGFloat = 0.0
    @State private var progressKnowPercent_4: CGFloat = 0.0
    @State private var progressKnowPercent_5: CGFloat = 0.0
    @State private var progressKnowPercent_6: CGFloat = 0.0
    @State private var progressKnowPercent_7: CGFloat = 0.0
    @State private var progressKnowPercent_8: CGFloat = 0.0
    @State private var progressKnowPercent_9: CGFloat = 0.0
    @State private var progressKnowPercent_10: CGFloat = 0.0
    @State private var progressKnowPercent_11: CGFloat = 0.0
    @State private var progressKnowPercent_12: CGFloat = 0.0
    @State private var progressKnowPercent_13: CGFloat = 0.0
    @State private var progressKnowPercent_14: CGFloat = 0.0
    @State private var progressKnowPercent_15: CGFloat = 0.0
    @State private var progressKnowPercent_16: CGFloat = 0.0
    @State private var progressKnowPercent_17: CGFloat = 0.0
    @State private var progressKnowPercent_18: CGFloat = 0.0
    @State private var progressKnowPercent_19: CGFloat = 0.0
    
    
    @State private var progressKnowWidth_0: CGFloat = 0.0
    @State private var progressKnowWidth_1: CGFloat = 0.0
    @State private var progressKnowWidth_2: CGFloat = 0.0
    @State private var progressKnowWidth_3: CGFloat = 0.0
    @State private var progressKnowWidth_4: CGFloat = 0.0
    @State private var progressKnowWidth_5: CGFloat = 0.0
    @State private var progressKnowWidth_6: CGFloat = 0.0
    @State private var progressKnowWidth_7: CGFloat = 0.0
    @State private var progressKnowWidth_8: CGFloat = 0.0
    @State private var progressKnowWidth_9: CGFloat = 0.0
    @State private var progressKnowWidth_10: CGFloat = 0.0
    @State private var progressKnowWidth_11: CGFloat = 0.0
    @State private var progressKnowWidth_12: CGFloat = 0.0
    @State private var progressKnowWidth_13: CGFloat = 0.0
    @State private var progressKnowWidth_14: CGFloat = 0.0
    @State private var progressKnowWidth_15: CGFloat = 0.0
    @State private var progressKnowWidth_16: CGFloat = 0.0
    @State private var progressKnowWidth_17: CGFloat = 0.0
    @State private var progressKnowWidth_18: CGFloat = 0.0
    @State private var progressKnowWidth_19: CGFloat = 0.0
    
    @State private var isShowEffectView: Bool = false
    @State private var showLoginAlert: Bool = false
    
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
        static let progressBarWidth: CGFloat = UIScreen.main.bounds.width - 40.0 // horizontal padding 값 양쪽 20.0씩 빼줘서 총 40.0 빼줌
        static let horizontalPaddingSize: CGFloat = 20.0
        static let learnColor: Color = Color(red: 245/255.0, green: 207/255.0, blue: 107/255.0, opacity: 1)
        //static let learnColor: Color = Color(red: 230/255.0, green: 116/255.0, blue: 132/255.0, opacity: 1)
        static let knowColor: Color = Color(red: 140/255.0, green: 204/255.0, blue: 231/255.0, opacity: 1)
    }
}

extension DoneView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    
                    Image("congrats3_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit).frame(height: 100)
                        .padding(.bottom, 15)
                        .onTapGesture {
                            isShowEffectView = true
                        }
                    
                    ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                        
                        VStack(spacing: 0) {
                            
                            //MARK: - 서브 카테고리 / 퍼센트 글자
                            HStack(spacing: 0) {
                                Text(item.subCategory)
                                    .font(.title5Roboto1622Medium)
                                    .foregroundColor(.gray800)
                            
                                Spacer()
                                
                                Text("\(DoneViewType.know.rawValue) \(Int(self.getProgressKnowPercent(index: index)))%")
                                    .opacity(0.0)
                                    .modifier(
                                        CountingNumberAnimationModifier(
                                            doneViewType: .know,
                                            number: self.getProgressKnowPercent(index: index)
                                        )
                                    )
                                
                                Text("\(DoneViewType.learn.rawValue) \(Int(self.getProgressPercent(index: index)))%")
                                    .opacity(0.0)
                                    .modifier(
                                        CountingNumberAnimationModifier(
                                            doneViewType: .learn,
                                            number: self.getProgressPercent(index: index)
                                        )
                                    )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            
                            
                            //MARK: - ProgressBar
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: sizeInfo.progressBarWidth)
                                    .foregroundColor(.bgLightGray50)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: self.getProgressWidth(index: index))
                                    .foregroundColor(sizeInfo.learnColor)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: self.getProgressKnowWidth(index: index))
                                    .foregroundColor(sizeInfo.knowColor)
                            }
                            .frame(height: 30)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    if !isLastMainCategory {
                        Button(action: {
                            // 게스트 예외처리
                            if !userManager.isLogin {
                                showLoginAlert = true
                                return
                            }
                            
                            nextStep()
                            isShowEffectView = false
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("se_doneview_next".localized)
                                .font(.buttons1420Medium)
                                .foregroundColor(.gray25)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryDefault))
                        })
                    }
                    
                    Button(action: {
                        
                        reload()
                        isShowEffectView = false
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("se_doneview_reload".localized)
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray700)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray400, lineWidth: 1))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray25))
                    })
                }
                .padding(.horizontal, sizeInfo.horizontalPaddingSize)
                .padding(.bottom, 20)
            }
            .toolbar {
                // 취소버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cancle()
                        isShowEffectView = false
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_outline_cancel")
                            .resizable()
                            .frame(width: sizeInfo.toolBarCancelButtonSize, height: sizeInfo.toolBarCancelButtonSize)
                    })
                }
            }
            .toolbarBackground(Color.gray25)
        }
        .task {
            
            isShowEffectView = true
            
            var localPercent_0: CGFloat = 0.0
            var localPercent_1: CGFloat = 0.0
            var localPercent_2: CGFloat = 0.0
            var localPercent_3: CGFloat = 0.0
            var localPercent_4: CGFloat = 0.0
            var localPercent_5: CGFloat = 0.0
            var localPercent_6: CGFloat = 0.0
            var localPercent_7: CGFloat = 0.0
            var localPercent_8: CGFloat = 0.0
            var localPercent_9: CGFloat = 0.0
            var localPercent_10: CGFloat = 0.0
            var localPercent_11: CGFloat = 0.0
            var localPercent_12: CGFloat = 0.0
            var localPercent_13: CGFloat = 0.0
            var localPercent_14: CGFloat = 0.0
            var localPercent_15: CGFloat = 0.0
            var localPercent_16: CGFloat = 0.0
            var localPercent_17: CGFloat = 0.0
            var localPercent_18: CGFloat = 0.0
            var localPercent_19: CGFloat = 0.0
            
            var localKnowPercent_0: CGFloat = 0.0
            var localKnowPercent_1: CGFloat = 0.0
            var localKnowPercent_2: CGFloat = 0.0
            var localKnowPercent_3: CGFloat = 0.0
            var localKnowPercent_4: CGFloat = 0.0
            var localKnowPercent_5: CGFloat = 0.0
            var localKnowPercent_6: CGFloat = 0.0
            var localKnowPercent_7: CGFloat = 0.0
            var localKnowPercent_8: CGFloat = 0.0
            var localKnowPercent_9: CGFloat = 0.0
            var localKnowPercent_10: CGFloat = 0.0
            var localKnowPercent_11: CGFloat = 0.0
            var localKnowPercent_12: CGFloat = 0.0
            var localKnowPercent_13: CGFloat = 0.0
            var localKnowPercent_14: CGFloat = 0.0
            var localKnowPercent_15: CGFloat = 0.0
            var localKnowPercent_16: CGFloat = 0.0
            var localKnowPercent_17: CGFloat = 0.0
            var localKnowPercent_18: CGFloat = 0.0
            var localKnowPercent_19: CGFloat = 0.0
            
            
            for (index, item) in list.enumerated() {
                
                let calValue = calculatePercentage(value: Double(item.swipeCount), percentageVal: Double(item.totalCount))
                let percent = CGFloat(calValue) / 100.0
                
                let calValueKnow = calculatePercentage(value: Double(item.knowCount), percentageVal: Double(item.totalCount))
                let percentKnow = CGFloat(calValueKnow) / 100.0
                
                
                switch index {
                case 0:
                    localPercent_0 = calValue
                    progressWidth_0 = percent
                    
                    localKnowPercent_0 = calValueKnow
                    progressKnowWidth_0 = percentKnow
                case 1:
                    localPercent_1 = calValue
                    progressWidth_1 = percent
                    
                    localKnowPercent_1 = calValueKnow
                    progressKnowWidth_1 = percentKnow
                case 2:
                    localPercent_2 = calValue
                    progressWidth_2 = percent
                    
                    localKnowPercent_2 = calValueKnow
                    progressKnowWidth_2 = percentKnow
                case 3:
                    localPercent_3 = calValue
                    progressWidth_3 = percent
                    
                    localKnowPercent_3 = calValueKnow
                    progressKnowWidth_3 = percentKnow
                case 4:
                    localPercent_4 = calValue
                    progressWidth_4 = percent
                    
                    localKnowPercent_4 = calValueKnow
                    progressKnowWidth_4 = percentKnow
                case 5:
                    localPercent_5 = calValue
                    progressWidth_5 = percent
                    
                    localKnowPercent_5 = calValueKnow
                    progressKnowWidth_5 = percentKnow
                case 6:
                    localPercent_6 = calValue
                    progressWidth_6 = percent
                    
                    localKnowPercent_6 = calValueKnow
                    progressKnowWidth_6 = percentKnow
                case 7:
                    localPercent_7 = calValue
                    progressWidth_7 = percent
                    
                    localKnowPercent_7 = calValueKnow
                    progressKnowWidth_7 = percentKnow
                case 8:
                    localPercent_8 = calValue
                    progressWidth_8 = percent
                    
                    localKnowPercent_8 = calValueKnow
                    progressKnowWidth_8 = percentKnow
                case 9:
                    localPercent_9 = calValue
                    progressWidth_9 = percent
                    
                    localKnowPercent_9 = calValueKnow
                    progressKnowWidth_9 = percentKnow
                case 10:
                    localPercent_10 = calValue
                    progressWidth_10 = percent
                    
                    localKnowPercent_10 = calValueKnow
                    progressKnowWidth_10 = percentKnow
                case 11:
                    localPercent_11 = calValue
                    progressWidth_11 = percent
                    
                    localKnowPercent_11 = calValueKnow
                    progressKnowWidth_11 = percentKnow
                case 12:
                    localPercent_12 = calValue
                    progressWidth_12 = percent
                    
                    localKnowPercent_12 = calValueKnow
                    progressKnowWidth_12 = percentKnow
                case 13:
                    localPercent_13 = calValue
                    progressWidth_13 = percent
                    
                    localKnowPercent_13 = calValueKnow
                    progressKnowWidth_13 = percentKnow
                case 14:
                    localPercent_14 = calValue
                    progressWidth_14 = percent
                    
                    localKnowPercent_14 = calValueKnow
                    progressKnowWidth_14 = percentKnow
                case 15:
                    localPercent_15 = calValue
                    progressWidth_15 = percent
                    
                    localKnowPercent_15 = calValueKnow
                    progressKnowWidth_15 = percentKnow
                case 16:
                    localPercent_16 = calValue
                    progressWidth_16 = percent
                    
                    localKnowPercent_16 = calValueKnow
                    progressKnowWidth_16 = percentKnow
                case 17:
                    localPercent_17 = calValue
                    progressWidth_17 = percent
                    
                    localKnowPercent_17 = calValueKnow
                    progressKnowWidth_17 = percentKnow
                case 18:
                    localPercent_18 = calValue
                    progressWidth_18 = percent
                    
                    localKnowPercent_18 = calValueKnow
                    progressKnowWidth_18 = percentKnow
                case 19:
                    localPercent_19 = calValue
                    progressWidth_19 = percent
                    
                    localKnowPercent_19 = calValueKnow
                    progressKnowWidth_19 = percentKnow
                default:
                    fLog("")
                }
            }
            
//            fLog("idpil::: progressWidth_0 : \(progressWidth_0)")
//            fLog("idpil::: progressWidth_1 : \(progressWidth_1)")
//            fLog("idpil::: progressWidth_2 : \(progressWidth_2)")
//            fLog("idpil::: progressWidth_3 : \(progressWidth_3)")
//            fLog("idpil::: progressWidth_4 : \(progressWidth_4)")
//            fLog("idpil::: progressWidth_5 : \(progressWidth_5)")
//            fLog("idpil::: progressWidth_6 : \(progressWidth_6)")
//            fLog("idpil::: progressWidth_7 : \(progressWidth_7)")
//            fLog("idpil::: progressWidth_8 : \(progressWidth_8)")
//            fLog("idpil::: progressWidth_9 : \(progressWidth_9)")
//            fLog("idpil::: progressWidth_10 : \(progressWidth_10)")
//            fLog("idpil::: progressWidth_11 : \(progressWidth_11)")
//            fLog("idpil::: progressWidth_12 : \(progressWidth_12)")
//            fLog("idpil::: progressWidth_13 : \(progressWidth_13)")
//            fLog("idpil::: progressWidth_14 : \(progressWidth_14)")
//            fLog("idpil::: progressWidth_15 : \(progressWidth_15)")
//            fLog("idpil::: progressWidth_16 : \(progressWidth_16)")
//            fLog("idpil::: progressWidth_17 : \(progressWidth_17)")
//            fLog("idpil::: progressWidth_18 : \(progressWidth_18)")
//            fLog("idpil::: progressWidth_19 : \(progressWidth_19)")
            
            
            withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                
                progressPercent_0 = localPercent_0
                progressPercent_1 = localPercent_1
                progressPercent_2 = localPercent_2
                progressPercent_3 = localPercent_3
                progressPercent_4 = localPercent_4
                progressPercent_5 = localPercent_5
                progressPercent_6 = localPercent_6
                progressPercent_7 = localPercent_7
                progressPercent_8 = localPercent_8
                progressPercent_9 = localPercent_9
                progressPercent_10 = localPercent_10
                progressPercent_11 = localPercent_11
                progressPercent_12 = localPercent_12
                progressPercent_13 = localPercent_13
                progressPercent_14 = localPercent_14
                progressPercent_15 = localPercent_15
                progressPercent_16 = localPercent_16
                progressPercent_17 = localPercent_17
                progressPercent_18 = localPercent_18
                progressPercent_19 = localPercent_19
                
                // calValue 너비 (70%)
                progressWidth_0 = progressWidth_0 * sizeInfo.progressBarWidth
                progressWidth_1 = progressWidth_1 * sizeInfo.progressBarWidth
                progressWidth_2 = progressWidth_2 * sizeInfo.progressBarWidth
                progressWidth_3 = progressWidth_3 * sizeInfo.progressBarWidth
                progressWidth_4 = progressWidth_4 * sizeInfo.progressBarWidth
                progressWidth_5 = progressWidth_5 * sizeInfo.progressBarWidth
                progressWidth_6 = progressWidth_6 * sizeInfo.progressBarWidth
                progressWidth_7 = progressWidth_7 * sizeInfo.progressBarWidth
                progressWidth_8 = progressWidth_8 * sizeInfo.progressBarWidth
                progressWidth_9 = progressWidth_9 * sizeInfo.progressBarWidth
                progressWidth_10 = progressWidth_10 * sizeInfo.progressBarWidth
                progressWidth_11 = progressWidth_11 * sizeInfo.progressBarWidth
                progressWidth_12 = progressWidth_12 * sizeInfo.progressBarWidth
                progressWidth_13 = progressWidth_13 * sizeInfo.progressBarWidth
                progressWidth_14 = progressWidth_14 * sizeInfo.progressBarWidth
                progressWidth_15 = progressWidth_15 * sizeInfo.progressBarWidth
                progressWidth_16 = progressWidth_16 * sizeInfo.progressBarWidth
                progressWidth_17 = progressWidth_17 * sizeInfo.progressBarWidth
                progressWidth_18 = progressWidth_18 * sizeInfo.progressBarWidth
                progressWidth_19 = progressWidth_19 * sizeInfo.progressBarWidth
            }
            
            withAnimation(.easeIn(duration: 0.5).delay(1.0)) {
                progressKnowPercent_0 = localKnowPercent_0
                progressKnowPercent_1 = localKnowPercent_1
                progressKnowPercent_2 = localKnowPercent_2
                progressKnowPercent_3 = localKnowPercent_3
                progressKnowPercent_4 = localKnowPercent_4
                progressKnowPercent_5 = localKnowPercent_5
                progressKnowPercent_6 = localKnowPercent_6
                progressKnowPercent_7 = localKnowPercent_7
                progressKnowPercent_8 = localKnowPercent_8
                progressKnowPercent_9 = localKnowPercent_9
                progressKnowPercent_10 = localKnowPercent_10
                progressKnowPercent_11 = localKnowPercent_11
                progressKnowPercent_12 = localKnowPercent_12
                progressKnowPercent_13 = localKnowPercent_13
                progressKnowPercent_14 = localKnowPercent_14
                progressKnowPercent_15 = localKnowPercent_15
                progressKnowPercent_16 = localKnowPercent_16
                progressKnowPercent_17 = localKnowPercent_17
                progressKnowPercent_18 = localKnowPercent_18
                progressKnowPercent_19 = localKnowPercent_19
                
                
                progressKnowWidth_0 = progressKnowWidth_0 * sizeInfo.progressBarWidth
                progressKnowWidth_1 = progressKnowWidth_1 * sizeInfo.progressBarWidth
                progressKnowWidth_2 = progressKnowWidth_2 * sizeInfo.progressBarWidth
                progressKnowWidth_3 = progressKnowWidth_3 * sizeInfo.progressBarWidth
                progressKnowWidth_4 = progressKnowWidth_4 * sizeInfo.progressBarWidth
                progressKnowWidth_5 = progressKnowWidth_5 * sizeInfo.progressBarWidth
                progressKnowWidth_6 = progressKnowWidth_6 * sizeInfo.progressBarWidth
                progressKnowWidth_7 = progressKnowWidth_7 * sizeInfo.progressBarWidth
                progressKnowWidth_8 = progressKnowWidth_8 * sizeInfo.progressBarWidth
                progressKnowWidth_9 = progressKnowWidth_9 * sizeInfo.progressBarWidth
                progressKnowWidth_10 = progressKnowWidth_10 * sizeInfo.progressBarWidth
                progressKnowWidth_11 = progressKnowWidth_11 * sizeInfo.progressBarWidth
                progressKnowWidth_12 = progressKnowWidth_12 * sizeInfo.progressBarWidth
                progressKnowWidth_13 = progressKnowWidth_13 * sizeInfo.progressBarWidth
                progressKnowWidth_14 = progressKnowWidth_14 * sizeInfo.progressBarWidth
                progressKnowWidth_15 = progressKnowWidth_15 * sizeInfo.progressBarWidth
                progressKnowWidth_16 = progressKnowWidth_16 * sizeInfo.progressBarWidth
                progressKnowWidth_17 = progressKnowWidth_17 * sizeInfo.progressBarWidth
                progressKnowWidth_18 = progressKnowWidth_18 * sizeInfo.progressBarWidth
                progressKnowWidth_19 = progressKnowWidth_19 * sizeInfo.progressBarWidth
            }
            
        }
        .navigationBarBackground {
            // 아래 라이브러리 사용함
            // https://github.com/haifengkao/SwiftUI-Navigation-Bar-Color
            Color.gray25.shadow(radius: 0)
        }
        // Animation Effect Library : https://github.com/ivanvorobei/SPConfetti?tab=readme-ov-file#swiftui
        .confetti(isPresented: $isShowEffectView,
                  animation: .fullWidthToDown,
                  particles: [.triangle, .arc],
                  duration: 1.5)
        .confettiParticle(\.velocity, 600) // 폭죽 내리는 속도 조절
        /**
         * [게스트에게 로그인 유도]
         * 여기가 fullScreenCover로 올라온 화면이기 때문에 ContentViewAlert에서 설정한 .showCustomAlert()를 이용하는 경우에는 fullScreenCover 가려서 보이지 않는 문제가 있다.
         * 그래서 여기서 .showCustomAlert()를 선언해서 사용해야 됨.
         */
        .showCustomAlert(isPresented: $showLoginAlert,
                         type: .Default,
                         title: "",
                         message: "se_r_need_login".localized,
                         detailMessage: "",
                         buttons: ["c_cancel".localized, "r_login".localized],
                         onClick: { buttonIndex in
            if buttonIndex == 1 {
                
                isShowLoginView()
                isShowEffectView = false
                presentationMode.wrappedValue.dismiss()
            }
        })
        
    }
    
    //Calucate percentage based on given values
    private func calculatePercentage(value:Double, percentageVal:Double) -> Double {
        // 300의 4는 몇 %?  == (100 * 4) / 300
        let val = 100.0 * value
        //fLog("idpil::: 퍼센트 : \(val / percentageVal)")
        return val / percentageVal
        
    }
    
    private func getProgressPercent(index: Int) -> CGFloat {
        if index == 0 {
            return progressPercent_0
        }
        else if index == 1 {
            return progressPercent_1
        }
        else if index == 2 {
            return progressPercent_2
        }
        else if index == 3 {
            return progressPercent_3
        }
        else if index == 4 {
            return progressPercent_4
        }
        else if index == 5 {
            return progressPercent_5
        }
        else if index == 6 {
            return progressPercent_6
        }
        else if index == 7 {
            return progressPercent_7
        }
        else if index == 8 {
            return progressPercent_8
        }
        else if index == 9 {
            return progressPercent_9
        }
        else if index == 10 {
            return progressPercent_10
        }
        else if index == 11 {
            return progressPercent_11
        }
        else if index == 12 {
            return progressPercent_12
        }
        else if index == 13 {
            return progressPercent_13
        }
        else if index == 14 {
            return progressPercent_14
        }
        else if index == 15 {
            return progressPercent_15
        }
        else if index == 16 {
            return progressPercent_16
        }
        else if index == 17 {
            return progressPercent_17
        }
        else if index == 18 {
            return progressPercent_18
        }
        else if index == 19 {
            return progressPercent_19
        }
        else {
            return 0.0
        }
    }
    
    private func getProgressKnowPercent(index: Int) -> CGFloat {
        if index == 0 {
            return progressKnowPercent_0
        }
        else if index == 1 {
            return progressKnowPercent_1
        }
        else if index == 2 {
            return progressKnowPercent_2
        }
        else if index == 3 {
            return progressKnowPercent_3
        }
        else if index == 4 {
            return progressKnowPercent_4
        }
        else if index == 5 {
            return progressKnowPercent_5
        }
        else if index == 6 {
            return progressKnowPercent_6
        }
        else if index == 7 {
            return progressKnowPercent_7
        }
        else if index == 8 {
            return progressKnowPercent_8
        }
        else if index == 9 {
            return progressKnowPercent_9
        }
        else if index == 10 {
            return progressKnowPercent_10
        }
        else if index == 11 {
            return progressKnowPercent_11
        }
        else if index == 12 {
            return progressKnowPercent_12
        }
        else if index == 13 {
            return progressKnowPercent_13
        }
        else if index == 14 {
            return progressKnowPercent_14
        }
        else if index == 15 {
            return progressKnowPercent_15
        }
        else if index == 16 {
            return progressKnowPercent_16
        }
        else if index == 17 {
            return progressKnowPercent_17
        }
        else if index == 18 {
            return progressKnowPercent_18
        }
        else if index == 19 {
            return progressKnowPercent_19
        }
        else {
            return 0.0
        }
    }
    
    private func getProgressWidth(index: Int) -> CGFloat {
        if index == 0 {
            return progressWidth_0
        }
        else if index == 1 {
            return progressWidth_1
        }
        else if index == 2 {
            return progressWidth_2
        }
        else if index == 3 {
            return progressWidth_3
        }
        else if index == 4 {
            return progressWidth_4
        }
        else if index == 5 {
            return progressWidth_5
        }
        else if index == 6 {
            return progressWidth_6
        }
        else if index == 7 {
            return progressWidth_7
        }
        else if index == 8 {
            return progressWidth_8
        }
        else if index == 9 {
            return progressWidth_9
        }
        else if index == 10 {
            return progressWidth_10
        }
        else if index == 11 {
            return progressWidth_11
        }
        else if index == 12 {
            return progressWidth_12
        }
        else if index == 13 {
            return progressWidth_13
        }
        else if index == 14 {
            return progressWidth_14
        }
        else if index == 15 {
            return progressWidth_15
        }
        else if index == 16 {
            return progressWidth_16
        }
        else if index == 17 {
            return progressWidth_17
        }
        else if index == 18 {
            return progressWidth_18
        }
        else if index == 19 {
            return progressWidth_19
        }
        else {
            return 0.0
        }
    }
    
    private func getProgressKnowWidth(index: Int) -> CGFloat {
        if index == 0 {
            return progressKnowWidth_0
        }
        else if index == 1 {
            return progressKnowWidth_1
        }
        else if index == 2 {
            return progressKnowWidth_2
        }
        else if index == 3 {
            return progressKnowWidth_3
        }
        else if index == 4 {
            return progressKnowWidth_4
        }
        else if index == 5 {
            return progressKnowWidth_5
        }
        else if index == 6 {
            return progressKnowWidth_6
        }
        else if index == 7 {
            return progressKnowWidth_7
        }
        else if index == 8 {
            return progressKnowWidth_8
        }
        else if index == 9 {
            return progressKnowWidth_9
        }
        else if index == 10 {
            return progressKnowWidth_10
        }
        else if index == 11 {
            return progressKnowWidth_11
        }
        else if index == 12 {
            return progressKnowWidth_12
        }
        else if index == 13 {
            return progressKnowWidth_13
        }
        else if index == 14 {
            return progressKnowWidth_14
        }
        else if index == 15 {
            return progressKnowWidth_15
        }
        else if index == 16 {
            return progressKnowWidth_16
        }
        else if index == 17 {
            return progressKnowWidth_17
        }
        else if index == 18 {
            return progressKnowWidth_18
        }
        else if index == 19 {
            return progressKnowWidth_19
        }
        else {
            return 0.0
        }
    }
    
}

//#Preview {
//    DoneView()
//}
