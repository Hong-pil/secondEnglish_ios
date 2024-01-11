//
//  PermissionViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import AVFoundation
import Photos
import PhotosUI

class PermissionViewModel {
    func requestPermission() {
        requestAccessCamera()
    }
    
    func requestAccessCamera(){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            self.requestAccessAlbum()
        }
    }
    
    func requestAccessAlbum(){
        PHPhotoLibrary.requestAuthorization(){ granted in
            
            switch granted {
            case .authorized:
                fLog("Album: 권한 허용")
            case .denied:
                fLog("Album: 권한 거부")
            case .restricted, .notDetermined:
                fLog("Album: 선택하지 않음")
            default:
                break
            }
            self.requestAccessAudio()
        }
    }
    
    func requestAccessAudio() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                UserManager.shared.isFirstLaunching = false
                UserManager.shared.showLoginView = true
            }
        })
    }
}

class PermissionCheck {
    static let cameraPermissionMessage = "카메라를 사용할 수 없습니다. \n[설정] > [개인 정보 보호] > [카메라]에서 FANTOO를 ON으로 설정해주세요."
    static let albumPermissionMessage = "카메라롤에 접근할 수 없습니다. \n[설정] > [개인 정보 보호] > [사진]에서 FANTOO를 ON으로 설정해주세요."
    
    static func photoAlbumAuth() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authStatus {
        case .authorized: return true
        case .denied: break
        case .limited: break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted: break
        default: break
        }
        
        return false
    }
    
    static func cameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }
}
