//
//  Main.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct Main {
    @StateObject var userManager = UserManager.shared
    @StateObject var landingManager = LandingManager.shared
    @StateObject var tabStateHandler: TabStateHandlerManager = TabStateHandlerManager()
    @StateObject var languageManager = LanguageManager.shared
    
    @State private var isFirstLoaded: Bool = true
    @State private var isShowEditorView: Bool = false
    
    private struct sizeInfo {
        static let numberOfTabs: CGFloat = 3.0
        static let tabIconSize: CGFloat = 20.0
        static let tabPlusIconSize: CGFloat = 35.0
        static let tabPointIconSize: CGFloat = 5.0
        static let tabIconClickPaddingSize: CGFloat = 20.0 // 클릭 영역 확장
    }
}

extension Main: View {
    var body: some View {
        NavigationStack {
            ZStack {
                mainTabView
                
                LoadingView()
            }
        }
        .onChange(of: landingManager.showMinute) {
            if landingManager.showMinute {
                tabStateHandler.selection = .swipe_card   // 미닛 탭으로 이동
                landingManager.showMinute = false
            }
        }
        .fullScreenCover(isPresented: $isShowEditorView) {
            EditorPage() { saved, category in
                if saved {
                    RefreshManager.shared.postChangeDataSubject.send(PostChanged(state: .Create(code: category)))
                }
            }
        }
    }
    
    var mainTabView: some View {
        VStack(spacing: 0) {
            contentTabView
            
            customBottomTabs
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .onAppear(perform: {
            if isFirstLoaded {
                isFirstLoaded = false
                tabStateHandler.selection = .my
            }
        })
    }
    
    var contentTabView: some View {
        TabView(selection: $tabStateHandler.selection) {
            Group {
                TabHomePage()
                    .tag(bTab.my)
                
                TabSwipeCardPage()
                    .tag(bTab.swipe_card)
            }
            .setTabBarVisibility(isHidden: true)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
    
    var customBottomTabs: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .fill(Color.gray400)
                .frame(height: 1)
            
            // 참고 : 탭바 상단 그림자는 Main.swift 에서 설정함
            HStack(spacing: 0) {
                Group {
                    Button {
                        tabStateHandler.selection = .my
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: "bookmark.square")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .my ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            
                            if tabStateHandler.selection == .my {
                                Image(systemName: "circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(.stateActivePrimaryDefault)
                                    .frame(width: sizeInfo.tabPointIconSize, height: sizeInfo.tabPointIconSize)
                            }
                        }
                        .padding(.horizontal, sizeInfo.tabIconClickPaddingSize)
                    }
                    
                    Button {
                        isShowEditorView = true
                    } label: {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.gray25)
                            .padding(10)
                            .background(Circle().fill(Color.primaryDefault))
                            .frame(width: sizeInfo.tabPlusIconSize, height: sizeInfo.tabPlusIconSize)
                            .padding(sizeInfo.tabIconClickPaddingSize)
                    }
                    
                    Button {
                        tabStateHandler.selection = .swipe_card
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .swipe_card ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            
                            if tabStateHandler.selection == .swipe_card {
                                Image(systemName: "circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(.stateActivePrimaryDefault)
                                    .frame(width: sizeInfo.tabPointIconSize, height: sizeInfo.tabPointIconSize)
                            }
                        }
                        .padding(.horizontal, sizeInfo.tabIconClickPaddingSize)
                    }
                    
//                    Button {
//                        tabStateHandler.selection = .settings
//                    } label: {
//                        Image(systemName: "line.3.horizontal")
//                            .renderingMode(.template)
//                            .resizable()
//                            .foregroundColor(tabStateHandler.selection == .settings ? .stateActivePrimaryDefault: .gray400)
//                            .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
//                            .padding(sizeInfo.tabIconClickPaddingSize)
//                    }
                    
                }
                .buttonStyle(PlainButtonStyle())    // 버튼 깜빡임 방지
                .frame(maxWidth: UIScreen.width/sizeInfo.numberOfTabs, maxHeight: .infinity)
                .background(Color.gray25)   // 배경색 있어야 클릭 잘 됨 (영역을 차지하나봄)
            }
        }
        .frame(height: DefineSize.MainTabHeight)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
