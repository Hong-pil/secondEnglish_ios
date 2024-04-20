//
//  DoneView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/12/24.
//

import SwiftUI

struct DoneView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let cancle: () -> Void
    let nextStep: () -> Void
    let reload: () -> Void
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
    }
}

extension DoneView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Image("congrats3_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit).frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 30)
                    .padding(.trailing, 20)
                    
                
                Spacer()
                
                Button(action: {
                    nextStep()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("다음 단계로 넘어가기")
                        .font(.buttons1420Medium)
                        .foregroundColor(.gray25)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryDefault))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                })
                
                Button(action: {
                    reload()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("다시 복습하기")
                        .font(.buttons1420Medium)
                        .foregroundColor(.gray700)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray400, lineWidth: 1))
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray25))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                })
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
    }
}

//#Preview {
//    DoneView()
//}
