//
//  EditorPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/14/24.
//

import SwiftUI
import ComposableArchitecture

struct EditorPage: View {
    @State var store: StoreOf<EditorPageFeature>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private struct sizeInfo {
        static let toolBarCancelButtonSize: CGFloat = 20.0
    }
    
    var body: some View {
        NavigationView {
            LoadingViewContainer {
                // footerView 키보드 바로 위에 붙을 수 있도록 해줌
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        
                        ScrollViewReader { proxyReader in
                            
                            ScrollView(showsIndicators: false) {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(Array(store.sentenceList.enumerated()), id: \.offset) { index, item in
                                        
                                        EditorInputView(
                                            store: store,
                                            activeKoreanTxt: $store.koreanTxt,
                                            activeEnglishTxt: $store.englishTxt,
                                            inactiveKoreanTxt: item[DefineKey.sentenceKoKey] ?? "",
                                            inactiveEnglishTxt: item[DefineKey.sentenceEnKey] ?? "",
                                            activeCardIndex: $store.activeIndex,
                                            cardIndex: index,
                                            forceKeyboardUpIndex: store.forceKeyboardUpIndex,
                                            isCardAdd: store.isCardAdd
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    footerView
                }
                .task {
                    store.send(.addList)
                }
            }
            .toolbar {
                // 취소버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_outline_cancel")
                            .resizable()
                            .frame(width: sizeInfo.toolBarCancelButtonSize, height: sizeInfo.toolBarCancelButtonSize)
                    })
                }
                
                // 등록/수정 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Text("s_modifying".localized)
                            .foregroundColor(Color.stateEnableGray900)
                            .font(.title41824Medium)
                    })
                }
            }
        }
    }
    
    var footerView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray400)
                .frame(height: 1)
         
            ZStack {
                Text("\(store.activeIndex+1) / \(store.sentenceList.count)")
                    .font(.caption21116Regular)
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                Button {
                    store.send(.addList)
                } label: {
                    Image(systemName: "plus")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.gray25)
                        .padding(10)
                        .background(Circle().fill(Color.primaryDefault))
                        .aspectRatio(contentMode: .fit).frame(height: 40) // 높이에 맞춰 비율 유지함
                        .padding(10) // 클릭 영역 확장
                }
                //.opacity(viewModel.isEditMode ? 0.0 : 1.0) // 공간은 차지하기 위해 opacity로 설정함
                
                Button(action: {
                    // View 탭시, Keyboard dismiss 하기
                    UIApplication.shared.endEditing()
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.gray400)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .background(Color.gray25)
        }
    }
}

#Preview {
    EditorPage(
        store: Store(initialState: EditorPageFeature.State()) {
            EditorPageFeature()
        }
    )
}
