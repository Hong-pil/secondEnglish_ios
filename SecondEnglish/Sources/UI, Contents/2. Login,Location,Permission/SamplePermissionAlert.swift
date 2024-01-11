//
//  SamplePermissionAlert.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI
import CoreLocation


struct SamplePermissionAlert: View {
    @StateObject private var cameraPermission:CameraPermission=CameraPermission()
    @StateObject private var locationPermission:LocationPermission=LocationPermission()
    var body: some View {
        VStack {
            
            Text("Camera Permission \(cameraPermission.isCameraPermission.description)")
            
            
            switch locationPermission.authorizationStatus{
                
            case .notDetermined:
                Text("not determied")
            case .restricted:
                Text("restricted")
            case .denied:
                Text("denied")
            case .authorizedAlways:
                VStack {
                    Text(locationPermission.cordinates?.latitude.description ?? "")
                    Text(locationPermission.cordinates?.longitude.description ?? "")
                    
                }

            case .authorizedWhenInUse:
                VStack {
                    Text(locationPermission.cordinates?.latitude.description ?? "")
                    Text(locationPermission.cordinates?.longitude.description ?? "")
                    
                }

                
            default:
                Text("no")
            }
            
            
            Button {
                Task{
                    await  cameraPermission.getCameraPermission()
                }
            } label: {
                Text("Ask Camera Permission")
                    .padding()
            }
            
            Button {
                locationPermission.requestLocationPermission()
            } label: {
                Text("Ask Location Permission")
                    .padding()
            }
            
        }
        .buttonStyle(.bordered)
        
    }
    
    
}






