//
//  LocationPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import AVFAudio
import AVFoundation

/**
 * 참고 중
 * https://dalili.tistory.com/281
 */
struct LocationPage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Detect App Moving to Background
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var locationPermission:LocationPermission = LocationPermission()
    
    @State private var isLocationPermissionOK = false
    
    // Alert
}

extension LocationPage: View {
    var body: some View {
        VStack(spacing: 0) {
            if isLocationPermissionOK {
                VStack {
                    Text("위치 정보 허용 했음 !")
                    
                    Text("latitude : \(locationPermission.cordinates?.latitude.description ?? "")")
                    Text("longitude : \(locationPermission.cordinates?.longitude.description ?? "")")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
        }
        .task() {
            // 위치 권한 확인
            checkLocationPermission()
        }
        // 위치권한 알럿창에서 버튼 클릭한 경우 호출
        .onChange(of: locationPermission.authorizationStatus) {
            // 위치 권한 확인
            checkLocationPermission()
//            switch locationPermission.authorizationStatus {
//            case .notDetermined:
//                fLog("")
//            case .restricted:
//                fLog("")
//            case .denied: // 위치권한 알럿창에서 "허용 안 함" 클릭
//                /**
//                 * 권한 설정 거절한 경우 -> 다시 알럿 띄울 수 없고 설정앱으로 유도해서 권한 설정하도록 해야 됨
//                 */
//                isLocationPermissionOK = false
//                UserManager.shared.showAlertLocationPermission = true
//            case .authorizedAlways:
//                fLog("")
//            case .authorizedWhenInUse: // 위치권한 알럿창에서 "한 번 허용" 또는 "앱을 사용하는 동안 허용" 클릭
//                isLocationPermissionOK = true
//            case .authorized:
//                fLog("")
//            default:
//                fLog("")
//            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                print("App went to background")
            case .active:
                print("App became active (or came to foreground)")
                // 위치 권한 확인
                checkLocationPermission()
            case .inactive:
                print("App became inactive")
            @unknown default:
                print("Well, something certainly happened...")
            }
        }
        
    }
}

extension LocationPage {
    
    private func checkLocationPermission() {
        // 위치 권한 상태
        switch locationPermission.authorizationStatus {
        case .notDetermined: // 권한 결정 안 한 상태 -> 권한 알럿창 띄우기
            locationPermission.requestLocationPermission()
        case .restricted:
            fLog("")
        case .denied:
            /**
             * 권한 설정 거절한 경우 -> 다시 알럿 띄울 수 없고 설정앱으로 유도해서 권한 설정하도록 해야 됨
             */
            isLocationPermissionOK = false
            //UserManager.shared.showAlertLocationPermission = true
        case .authorizedAlways:
            fLog("")
        case .authorizedWhenInUse:
            // 권한 알럿창에서 "한 번 허용" 또는 "앱을 사용하는 동안 허용" 한 경우
            isLocationPermissionOK = true
        case .authorized:
            fLog("")
        default:
            fLog("")
        }
    }
}

#Preview {
    LocationPage()
}
