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
                    Image("secondEnglish_logo_512")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("말이 트이는 순간영어")
                        .font(Font.system(size: 23))
                        .fontWeight(.bold)
                        .padding(.top, 5)
                    
                    Text("영문을 문형별로 만드는 연습을 통해\n어느새 말이 트인 자신을 발견할 수 있어요!")
                        .font(.body21420Regular)
                        .padding(.top, 10)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
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
