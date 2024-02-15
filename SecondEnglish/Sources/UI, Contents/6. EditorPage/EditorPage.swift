//
//  EditorPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/15/24.
//

import SwiftUI

struct EditorPage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = EditorViewModel()
    
    var completion: ((Bool, String) -> Void)
    
    @State private var title: String = ""
}

extension EditorPage: View {
    var body: some View {
        // View 탭시, Keyboard dismiss 하기
        BackgroundTapGesture {
            NavigationView {
                LoadingViewContainer {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            if viewModel.checkMinimalData() {
                                CommonAlertView(title: {
                                    Text("se_b_post_write_back".localized)
                                        .foregroundColor(Color.gray870)
                                        .font(.buttons1420Medium)
                                        .multilineTextAlignment(.center)
                                },buttons: ["a_no".localized,"a_yes".localized]) { buttonIndex in
                                    if buttonIndex == 1 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                                .present {
                                    viewModel.showWriteCancel.toggle()
                                }
                            }
                            else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Image("icon_outline_cancel")
                        })
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    EditorPage()
//}
