//
//  ConfigManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class ConfigManager: ObservableObject {
    
    static let shared = ConfigManager()
    var canclelables = Set<AnyCancellable>()
    
    private var oldCurrentVersion = ""
    private var isShownRecommendedUpdate = false    //권장 업데이트는 앱 실행 후 한번만 보이게 한다.
    private var isProcessing = false        //체크를 진행중인 경우, 중복체크를 하지 않게 진행하지 않는다.
    
    var configData:MconfigData?
    
    
    //MARK: - Show & Value
    @Published var showNoticeAlert:Bool = false
    @Published var showFrontPopup:Bool = false
    @Published var showUpdateAlert:Bool = false
    @Published var showForceUpdateAlert:Bool = false
    
    @AppStorage(DefineKey.todayNotShowPopup) var todayNotShowPopup: String = ""
    
    var notice = ""
    
    
    //MARK: - Method
    func check() {
        if isProcessing { return }
        
        isProcessing = true
        ApiControl.mconfig(serviceType: "prod")
            .sink { error in
                fLog("mconfig error : \(error)")
                self.isProcessing = false
                
            } receiveValue: { value in
                self.configData = value
                
                //권장업데이트 체크를 위해
                if self.oldCurrentVersion != self.configData?.currentVersion ?? "" {
                    self.oldCurrentVersion = self.configData?.currentVersion ?? ""
                    self.isShownRecommendedUpdate = false
                }
                

                /*
                 긴급공지 먼저 체크,
                 isProcessing을 처리하지 않아도 됨. 저기서 더이상 앱 진행이 안됨.
                 */
                if self.isShowEmergency() {
                    self.showEmergency()
                }
                else if self.isShowVersionUpdate() {
                    self.showVersionUpdate {
                        self.isProcessing = false
                    }
                }
                else if self.isShowFrontPopup() {
                    self.showFrontPopupView()
                }
            }.store(in: &self.canclelables)
    }
    
    //긴급공지가 있는지
    private func isShowEmergency() -> Bool {
        if configData == nil {
            return false
        }
        
        if !(configData?.enable?.boolValue ?? false) {
            return false
        }
        
        let nowDate = Date()
        if nowDate.isBetween((configData!.startDate!.convertDate("yyyy-MM-dd hh:mm:ss")), (configData!.endDate!.convertDate("yyyy-MM-dd hh:mm:ss"))) {
            return true
        }
        
        
        return false
    }
    
    //전면팝업이 있는지
    private func isShowFrontPopup() -> Bool {
        if configData == nil {
            return false
        }
        
        if !(configData?.popupEnable?.boolValue ?? false) {
            return false
        }
        
        if UserManager.shared.isFirstLaunching {
            return false
        }
        
        if UserManager.shared.showLoginView {
            return false
        }
        
        let nowDate = Date()
        if nowDate.isBetween((configData!.popupStartDate!.convertDate("yyyy-MM-dd hh:mm:ss")), (configData!.popupEndDate!.convertDate("yyyy-MM-dd hh:mm:ss"))),
           todayNotShowPopup != Date().toString("yyyy-MM-dd")
        {
            return true
        }
        
        return false
    }
    
    //강제 or 권장 업데이트가 있는지 체크
    private func isShowVersionUpdate() -> Bool {
        if configData == nil {
            return false
        }
        
        if !(configData?.updateEnable?.boolValue ?? false) {
            return false
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.0.0"
        if configData?.currentVersion ?? "2.0.0" <= appVersion {
            return false
        }
        
        //권장업데이트면서, 앱 실행 후 한번 알럿을 본 경우 패스
        if !(configData?.forceUpdate?.boolValue ?? false), isShownRecommendedUpdate {
            return false
        }
        
        
        return true
    }
    
    
    //MARK: - Private : Show
    private func showEmergency() {
        var message = ""
        if LanguageManager.shared.getLanguageApiCode() == "ko" {
            message = configData?.messageKr ?? ""
        }
        else {
            message = configData?.messageEng ?? ""
        }
        
        notice = message
        
        UserManager.shared.showLoginView = false
        
        SimpleAlertView(
            title: "g_notice_short".localized,
            contents: message,
            buttons: ["j_quit".localized]) { _ in
                exit(-1)
            }
            .present {
                showNoticeAlert = true
            }
    }
    
    private func showFrontPopupView() {
//        let link = configData?.popupAppLink ?? ""
//        var image = ""
//        if LanguageManager.shared.isKor {
//            image = configData?.popupImgKo ?? ""
//        }
//        else {
//            image = configData?.popupImgEn ?? ""
//        }
//
//        FrontPopupView(imageId: image, link: link)
//            .present {
//                showFrontPopup = true
//            }
    }
    
    
    //업데이트, 취소버튼 시 isContinue 호출
    private func showVersionUpdate(isContinue:@escaping() -> Void) {
        if configData?.forceUpdate?.boolValue ?? false {
            UserManager.shared.showLoginView = false
            SimpleAlertView(
                title: "a_update_noti".localized,
                contents: "se_b_do_update_now".localized,
                buttons: ["j_quit".localized, "a_update".localized]) { buttonIndex in
                    if buttonIndex == 1 {
                        PopupManager.dismissAll()
                        CommonFunction.goAppStore()
                    } else {
                        exit(-1)
                    }
                }
                .present {
                    showForceUpdateAlert = true
                }
        }
        else {
            
            UserManager.shared.showLoginView = false
            
            //권장 업데이트는 앱 실행 후 한번만 보이게 한다.
            isShownRecommendedUpdate = true
            
            SimpleAlertView(
                title: "a_update_noti".localized,
                contents: "se_b_do_update_now".localized,
                buttons: ["n_later".localized, "a_update".localized]) { buttonIndex in
                    if buttonIndex == 1 {
                        PopupManager.dismissAll()
                        CommonFunction.goAppStore()
                    }
                }
                .present {
                    showUpdateAlert = true
                }
        }
    }
    
    
    /**
     # getDeviceUUID
     - Note: 디바이스 고유 넘버 반환
     */
    static func getDeviceUUID() -> String {
        guard let deviceUUID = UIDevice.current.identifierForVendor?.uuidString else {
            fLog("deviceUUID is nil")
            return ""
        }
        
        return deviceUUID
    }
}
