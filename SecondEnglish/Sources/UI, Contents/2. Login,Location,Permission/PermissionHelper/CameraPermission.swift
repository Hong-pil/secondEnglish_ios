//
//  CameraPermission.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import AVFoundation

@MainActor
class CameraPermission: ObservableObject {
    
    @Published var isCameraPermission:Bool = false
    
    func getCameraPermission() async {
        
        let status =  AVCaptureDevice.authorizationStatus(for: .video)
        
        switch(status){
        case .authorized:
            isCameraPermission = true
        case .notDetermined:
            await AVCaptureDevice.requestAccess(for: .video)
            isCameraPermission = true
        case .denied:
            isCameraPermission = false
        case .restricted:
            isCameraPermission = false
            
        @unknown default:
            isCameraPermission = false
        }
    }
}
