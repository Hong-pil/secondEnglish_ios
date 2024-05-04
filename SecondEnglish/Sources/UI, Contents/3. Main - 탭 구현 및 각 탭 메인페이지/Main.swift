//
//  Main.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import SwiftUINavigationBarColor

struct Main {
    /**
     * Main Tab 결정하는 부분
     */
    // Version 1
    var tabtype_1: TabMainType = .vOne
    let tabs_1: [TabMain] = [
        .init(title: "en_my_post".localized),
        .init(title: "en_my_like".localized)
    ]
    
    // Version 2
    var tabtype_2: TabMainType = .vTwo
    let tabs_2: [TabMain] = [
        .init(title: "en_for_you".localized),
        .init(title: "en_popular".localized),
        .init(title: "en_community".localized)
    ]
    
    @StateObject var userManager = UserManager.shared
    @StateObject var landingManager = LandingManager.shared
    @StateObject var tabStateHandler: TabStateHandlerManager = TabStateHandlerManager()
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var viewModel = MainViewModel()
    
    @State private var isFirstLoaded: Bool = true
    @State var isShowEditorView: Bool = false
    @State var navigationBarColor: Color = Color.stateActivePrimaryDefault
    @State var isAutoModeStop: Bool = false
    
    private struct sizeInfo {
        static let numberOfTabs: CGFloat = 3.0
        static let tabIconSize: CGFloat = 20.0
        static let tabPlusIconSize: CGFloat = 40.0
        static let tabPointIconSize: CGFloat = 5.0
        static let tabIconClickPaddingSize: CGFloat = 10.0 // 클릭 영역 확장
    }
}

extension Main: View {
    var body: some View {
        NavigationStack {
            ZStack {
                mainTabView
                
                LoadingView()
            }
            .ignoresSafeArea(edges: .bottom) // bottom SafeArea 없는게 계산하기 편함
            .navigationDestination(isPresented: $viewModel.showMenuPage) {
                MenuPage()
            }
        }
        .onChange(of: landingManager.showSwipePage) {
            if landingManager.showSwipePage {
                tabStateHandler.selection = .swipe_card // move to Swipe Tab
                landingManager.showSwipePage = false
                
                navigationBarColor = Color.primaryDefault
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
        .navigationBarBackground {
            // 아래 라이브러리 사용함
            // https://github.com/haifengkao/SwiftUI-Navigation-Bar-Color
            navigationBarColor.shadow(radius: 0)
        }
    }
    
    var contentTabView: some View {
        TabView(selection: $tabStateHandler.selection) {
            Group {
                TabHomePage(
                    tabtype: tabtype_1,
                    tabs: tabs_1,
                    moveToTopIndicator: $tabStateHandler.moveFirstTabToTop,
                    isShowEditorView: $isShowEditorView
                )
                .tag(bTab.my)
                
                TabSwipeCardPage(
                    isAutoModeStop: $isAutoModeStop,
                    isShowEditorView: $isShowEditorView
                )
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
                        //navigationBarColor = Color.bgLightGray50
                        navigationBarColor = Color.stateActivePrimaryDefault
                        //isAutoModeStop = true
                    } label: {
                        VStack(spacing: 8) {
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
                        .padding(sizeInfo.tabIconClickPaddingSize)
                        .background(Color.gray25) // 배경색 있어야 클릭 됨
                    }
                    .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
                    
                    Button {
                        if userManager.isLogin {
                            isShowEditorView = true
                            isAutoModeStop = true
                        } else {
                            userManager.showLoginAlert = true
                        }
                        
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
                        navigationBarColor = Color.primaryDefault
                    } label: {
                        VStack(spacing: 8) {
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
                        .padding(sizeInfo.tabIconClickPaddingSize)
                        .background(Color.gray25) // 배경색 있어야 클릭 됨
                    }
                    .buttonStyle(PlainButtonStyle()) // 버튼 깜빡임 방지
                    
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
                .frame(maxWidth: UIScreen.width/sizeInfo.numberOfTabs)
            }
            .background(Color.gray25) // 배경색 있어야 클릭 잘 됨 (영역을 차지하나봄)
            .padding(.horizontal, 30) // TabView 아이템 갯수가 2개 밖에 없어, 거리를 줄이는게 좀 더 버튼 누르기 편한 것 같음.
        }
        //.frame(minHeight: DefineSize.MainTabHeight)
        .padding(.bottom, 30)
    }
}

#Preview {
    Main()
}
