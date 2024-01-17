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
    
    private struct sizeInfo {
        static let numberOfTabs: CGFloat = 4.0
        static let tabIconSize: CGFloat = 20.0
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
        }
    }
    
    var mainTabView: some View {
        VStack(spacing: 0) {
            contentTabView
            
            customBottomTabs
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
                
                TabCalendarPage()
                    .tag(bTab.calendar)
                
                TabProfilePage()
                    .tag(bTab.settings)
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
                        Image(systemName: "person")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(tabStateHandler.selection == .my ? .stateActivePrimaryDefault: .gray400)
                            .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            .padding(sizeInfo.tabIconClickPaddingSize)
                    }
                    
                    Button {
                        tabStateHandler.selection = .swipe_card
                    } label: {
                        Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(tabStateHandler.selection == .swipe_card ? .stateActivePrimaryDefault: .gray400)
                            .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            .padding(sizeInfo.tabIconClickPaddingSize)
                    }
                    
                    Button {
                        tabStateHandler.selection = .calendar
                    } label: {
                        Image(systemName: "calendar")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(tabStateHandler.selection == .calendar ? .stateActivePrimaryDefault: .gray400)
                            .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            .padding(sizeInfo.tabIconClickPaddingSize)
                    }
                    
                    Button {
                        tabStateHandler.selection = .settings
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(tabStateHandler.selection == .settings ? .stateActivePrimaryDefault: .gray400)
                            .frame(width: sizeInfo.tabIconSize, height: sizeInfo.tabIconSize)
                            .padding(sizeInfo.tabIconClickPaddingSize)
                    }
                    
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
