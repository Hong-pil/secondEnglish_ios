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
        static let numberOfTabs: CGFloat = 5.0
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
                tabStateHandler.selection = .home
            }
        })
    }
    
    var contentTabView: some View {
        TabView(selection: $tabStateHandler.selection) {
            Group {
                TabHomePage()
                    .tag(bTab.home)
                
                TabPetLifePage()
                    .tag(bTab.pet_life)
                
                TabPetsPage()
                    .tag(bTab.pets)
                
                TabChattingPage()
                    .tag(bTab.chatting)
                
                TabProfilePage()
                    .tag(bTab.profile)
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
                        tabStateHandler.selection = .home
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "house.fill")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .home ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: 17.0, height: 17.0)
                            Text("tab_home".localized)
                                .font(.caption11218Regular)
                                .foregroundColor(tabStateHandler.selection == .home ? .stateActivePrimaryDefault: .gray400)
                        }
                    }
                    
                    Button {
                        tabStateHandler.selection = .pet_life
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down.fill")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .pet_life ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: 17.0, height: 17.0)
                            Text("slider")
                                .font(.caption11218Regular)
                                .foregroundColor(tabStateHandler.selection == .pet_life ? .stateActivePrimaryDefault: .gray400)
                        }
                    }
                    
                    Button {
                        tabStateHandler.selection = .pets
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .pets ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: 17.0, height: 17.0)
                            Text("swipe")
                                .font(.caption11218Regular)
                                .foregroundColor(tabStateHandler.selection == .pets ? .stateActivePrimaryDefault: .gray400)
                        }
                    }
                    
                    Button {
                        tabStateHandler.selection = .chatting
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "calendar")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .chatting ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: 17.0, height: 17.0)
                            Text("tab_calendar".localized)
                                .font(.caption11218Regular)
                                .foregroundColor(tabStateHandler.selection == .chatting ? .stateActivePrimaryDefault: .gray400)
                        }
                    }
                    
                    Button {
                        tabStateHandler.selection = .profile
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "person.fill")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(tabStateHandler.selection == .profile ? .stateActivePrimaryDefault: .gray400)
                                .frame(width: 17.0, height: 17.0)
                            Text("tab_my".localized)
                                .font(.caption11218Regular)
                                .foregroundColor(tabStateHandler.selection == .profile ? .stateActivePrimaryDefault: .gray400)
                        }
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
