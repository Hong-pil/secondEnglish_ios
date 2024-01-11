//
//  LoginStartPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct LoginStartPage {
    @State private var showLoginPage: Bool = false
    @State private var showLocationPage: Bool = false
}

extension LoginStartPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    Image("dolbwa_loading")
                    
                    Text("당신 근처의 dolbwa")
                        .font(.title32028Medium)
                        .padding(.top, 20)
                    
                    Text("동네라서 가능한 모든 것")
                        .font(.body21420Regular)
                        .padding(.top, 10)
                    
                    Text("지금 내 동네를 선택하고 시작해보세요!")
                        .font(.body21420Regular)
                }
                
                VStack(spacing: 10) {
                    Button(action: {
                        showLocationPage = true
                    }, label: {
                        Text("시작하기")
                    })
                    .buttonStyle(PrimaryButton01(
                        isActiveBinding: false,
                        isTextActive: .constant(false),
                        isBackgroundActive: .constant(false)
                    ))
                    
                    HStack(spacing: 3) {
                        Text("이미 계정이 있나요?")
                            .font(.body21420Regular)
                            .foregroundColor(.gray400)
                        
                        Button(action: {
                            showLoginPage = true
                        }, label: {
                            Text("로그인")
                                .font(.body21420Regular)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryDefault)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(isPresented: $showLoginPage) {
                LoginPage()
            }
            .navigationDestination(isPresented: $showLocationPage) {
                LocationPage()
                
                // 카메라,위치 권한 확인용 셈플
                //SamplePermissionAlert()
            }
        }
    }
}

#Preview {
    LoginStartPage()
}
