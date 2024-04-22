//
//  DoneView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/12/24.
//

import SwiftUI

struct DoneView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let list: [KnowCardLocalInfo]
    let cancle: () -> Void
    let nextStep: () -> Void
    let reload: () -> Void
    
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
    
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
        static let progressBarWidth: CGFloat = UIScreen.main.bounds.width - 40.0 // horizontal padding 값 양쪽 20.0씩 빼줘서 총 40.0 빼줌
        static let horizontalPaddingSize: CGFloat = 20.0
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
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 30)
                        .padding(.trailing, 20)
                    
                    ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                        
                        VStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray25)
                                .modifier(
                                    CountingNumberAnimationModifier(subCategory: item.subCategory, number: self.getProgressPercent(index: index))
                                )
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                            
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: sizeInfo.progressBarWidth)
                                    .foregroundColor(.bgLightGray50)
                                    .cornerRadius(5)
                                
                                Rectangle().frame(width: self.getProgressWidth(index: index))
                                .foregroundColor(Color.stateActivePrimaryDefault)
                                .cornerRadius(5)
                            }
                            .frame(height: 30)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                // 버튼
//                Button("Increase Progress") {
//                    withAnimation(.easeIn(duration: 0.5)) {
//                        progressWidth = 0.7 * UIScreen.main.bounds.width // 70% 너비
//                    }
//                }
//                .padding()
                
                
                
                
                
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: {
                        nextStep()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("다음 단계로 넘어가기")
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray25)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryDefault))
                    })
                    
                    Button(action: {
                        reload()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("다시 복습하기")
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
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_outline_cancel")
                            .resizable()
                            .frame(width: sizeInfo.toolBarCancelButtonSize, height: sizeInfo.toolBarCancelButtonSize)
                    })
                }
            }
        }
        .task {
            
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
            
            
            for (index, item) in list.enumerated() {
                
                let calValue = calculatePercentage(value: Double(item.swipeCount), percentageVal: Double(item.totalCount))
                let percent = CGFloat(calValue) / 100.0
                //fLog("idpil::: calValue : \(calValue)")
                
                switch index {
                case 0:
                    localPercent_0 = calValue
                    progressWidth_0 = percent
                case 1:
                    localPercent_1 = calValue
                    progressWidth_1 = percent
                case 2:
                    localPercent_2 = calValue
                    progressWidth_2 = percent
                case 3:
                    localPercent_3 = calValue
                    progressWidth_3 = percent
                case 4:
                    localPercent_4 = calValue
                    progressWidth_4 = percent
                case 5:
                    localPercent_5 = calValue
                    progressWidth_5 = percent
                case 6:
                    localPercent_6 = calValue
                    progressWidth_6 = percent
                case 7:
                    localPercent_7 = calValue
                    progressWidth_7 = percent
                case 8:
                    localPercent_8 = calValue
                    progressWidth_8 = percent
                case 9:
                    localPercent_9 = calValue
                    progressWidth_9 = percent
                case 10:
                    localPercent_10 = calValue
                    progressWidth_10 = percent
                case 11:
                    localPercent_11 = calValue
                    progressWidth_11 = percent
                case 12:
                    localPercent_12 = calValue
                    progressWidth_12 = percent
                case 13:
                    localPercent_13 = calValue
                    progressWidth_13 = percent
                case 14:
                    localPercent_14 = calValue
                    progressWidth_14 = percent
                case 15:
                    localPercent_15 = calValue
                    progressWidth_15 = percent
                case 16:
                    localPercent_16 = calValue
                    progressWidth_16 = percent
                case 17:
                    localPercent_17 = calValue
                    progressWidth_17 = percent
                case 18:
                    localPercent_18 = calValue
                    progressWidth_18 = percent
                case 19:
                    localPercent_19 = calValue
                    progressWidth_19 = percent
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
            
        }
    }
    
    //Calucate percentage based on given values
    private func calculatePercentage(value:Double, percentageVal:Double)->Double{
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
}

//#Preview {
//    DoneView()
//}
