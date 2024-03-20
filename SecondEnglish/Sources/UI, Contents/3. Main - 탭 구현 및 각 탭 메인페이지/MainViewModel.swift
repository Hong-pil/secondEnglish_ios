//
//  MainViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var showSettingPage = false
    @Published var showMenuPage = false
    @Published var showCommunitySearchPage = false
    @Published var showCommunityMyPage = false
    @Published var showClubSearchPage = false
    @Published var showClubNewClubPage = false
    @Published var showEventPage = false
    @Published var showAlertPage = false
    @Published var showChatPage = false
    @Published var showChatPickerPage = false
    @Published var showClubPickerPage = false
    @Published var showOpenChatCreatePage = false
    @Published var showOpenChatJoinPage = false
    @Published var showChatBottomsheet = false
    @Published var showChatBottomOpensheet = false
    @Published var showFPShopPage = false
    @Published var showAddFriendsPage = false
    
    init() {
        NavigationBarActionManager.shared.buttonActionSubject.sink { [weak self] title, type in
            guard let self = self else { return }
            self.navigationBarButtonAction(title: title, type: type)
        }
        .store(in: &cancellables)
    }
    
    func navigationBarButtonAction(title: String, type: CustomNavigationBarButtonType) {
        switch type {
//        case .ClubSetting:
//            if UserManager.shared.isLogin {
//                showSettingPage = true
//            }
//            else {
//                AlertManager().showLoginAlert()
//            }
        case .Menu:
            showMenuPage = true
            //LandingManager.shared.visibleHomeTab = false
//        case .Search:
//            if title == "k_community".localized {
//                showCommunitySearchPage = true
//            } else if title == "k_club".localized {
//                showClubSearchPage = true
//            }
//        case .Profile:
//            if title == "k_community".localized {
//                if UserManager.shared.isLogin {
//                    showCommunityMyPage = true
//                }
//                else {
//                    AlertManager().showLoginAlert()
//                }
//            }
//        case .Plus:
//            if title == "c_chatting".localized {
//                if UserManager.shared.isLogin && ChatManager.shared.conversationType == "friend" {
//                    showAddFriendsPage = true
//                }
//                else if UserManager.shared.isLogin && ChatManager.shared.conversationType != "friend" {
//                    showChatBottomsheet = true
//                }
//                else {
//                    AlertManager().showLoginAlert()
//                }
//            }
//            else {
//                if UserManager.shared.isLogin {
//                    if TabStateHandlerManager.shared.selection == .club {
//                        showClubNewClubPage = true
//                    } else {
////                        showChatPickerPage = true
//                        showChatBottomsheet = true
//                    }
//                }
//                else {
//                    AlertManager().showLoginAlert()
//                }
//            }
//        case .Present:
//            if !UserManager.shared.isLogin {
//                AlertManager().showLoginAlert()
//            } else {
//                showEventPage = true
//            }
//        case .FanitLine:
//            if !UserManager.shared.isLogin {
//                AlertManager().showLoginAlert()
//            } else {
//                showEventPage = true
//                LandingManager.shared.visibleHomeTab = false
//            }
//        case .AlarmOn, .AlarmOff, .AlarmNew:
//            if UserManager.shared.isLogin {
//                showAlertPage = true
//                LandingManager.shared.visibleHomeTab = false
//            }
//            else {
//                AlertManager().showLoginAlert()
//            }
//        case .Chatting, .ChattingNew:
////            if UserManager.shared.isLogin {
//                showChatPage = true
////            }
////            else {
////                AlertManager().showLoginAlert()
////            }
//        case .FPMain:
//            if !UserManager.shared.isLogin {
//                AlertManager().showLoginAlert()
//            } else {
//                showFPShopPage = true
//                LandingManager.shared.visibleHomeTab = false
//            }
            
        default:
            break
        }
    }
}
