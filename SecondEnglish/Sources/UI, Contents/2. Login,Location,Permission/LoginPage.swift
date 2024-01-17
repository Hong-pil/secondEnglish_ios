//
//  LoginPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct LoginPage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var phoneNumber: String = ""
    @State private var otpNumber: String = ""
    @State private var isSendSMSEnable: Bool = false
    @State private var isSendSMSCheckEnable: Bool = false
    @State private var isSendSMS: Bool = false
    @FocusState private var isPhoneNumberFocused: Bool
    @FocusState private var isOtpNumberFocused: Bool
    private let phoneNumber_placeholder: String = "휴대폰 번호(- 없이 숫자만 입력)"
    private let optNumber_placeholder: String = "인증번호 입력"
    
}

extension LoginPage: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                
                if !isSendSMS {
                    Text("안녕하세요!\n휴대폰 번호로 로그인해주세요.")
                        .font(.title22432Bold)
                        .foregroundColor(.gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("휴대폰 번호는 안전하게 보관되며 이웃들에게 공개되지 않아요.")
                        .font(.buttons1420Medium)
                        .foregroundColor(.gray800)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                }
                
                //MARK: - 휴대폰 번호 입력
                TextField(
                    phoneNumber_placeholder,
                    text: $phoneNumber
                )
                .onAppear {
                    // 폰번호 입력 키보드 올리기
                    isPhoneNumberFocused = true
                }
                .onChange(of: phoneNumber, initial: true) { oldValue, newValue in
                    
                    // [예외처리], 입력 값이 숫자가 아닌 경우 예외 처리 (복붙하면 String타입 값 입력 가능)
                    let trimmedString = newValue.removingWhitespaces() // 문자열에서 공백 제거
                    //print("로그::: \(trimmedString)")
                    let typeCastValue = Int(trimmedString) ?? 404
                    if typeCastValue == 404 {
                        phoneNumber = ""
                    }
                    else {
                        // 키보드 취소버튼 입력한 경우
                        if oldValue.count > newValue.count {
                            
                        } else {
                            phoneNumber = insertSpaceInMiddle(phoneNumber)
                        }
                        
                        // 글자 수 제한 ("010 6350 4981"까지 입력 가능하도록)
                        // prefix(_ maxLength: Int) : Collection에서 지정한 maxLength까지 하위 시퀀스를 리턴.
                        phoneNumber = String(phoneNumber.prefix(13))
                        
                        // 인증문자 전송 허용 (공백포함 10개부터 허용)
                        if phoneNumber.count > 9 {
                            isSendSMSEnable = true
                        } else {
                            isSendSMSEnable = false
                        }
                    }
                }
                .font(.title41824Medium)
                .foregroundColor(.gray900)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) // One Time Password(OTP) 인증, 키보드 활성 상태일 때 인증문자 받으면, 문자 내용 중에서 인증번호만 가져옴
                .focused($isPhoneNumberFocused)
                .background(Color.gray25)
                .textFieldStyle(PhoneNumberTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(isOtpNumberFocused ? Color.gray200 : Color.gray800, lineWidth: 1))
                .padding(.top, 20)
                
                Button(action: {
                    if isSendSMSEnable {
                        
                        viewModel.sendSMS(
                            toPhoneNumber: "01063504981",
                            accountSid: "ACe34732274fbb32995d0612cbea60be0d",
                            authToken: "8ade8567fdcda0e51cd281bd83293db9",
                            fromPhoneNumber: "+1 240 349 7171"
                        )
                        
                        // 폰번호 입력 키보드 내리기
                        isPhoneNumberFocused = false
                        
                        withAnimation {
                            isSendSMS = true
                        }
                        
                        isSendSMSEnable = false
                    }
                }, label: {
                    Text("인증문자 받기")
                })
                .buttonStyle(PrimaryButton01(
                    isActiveBinding: true,
                    textActiveColor: Color.gray900,
                    textInactiveColor: Color.gray200,
                    backgroundActiveColor: Color.gray800,
                    backgroundInactiveColor: Color.gray200,
                    isTextActive: $isSendSMSEnable,
                    isBackgroundActive: $isSendSMSEnable
                ))
                .padding(.top, 15)
                
                if !isSendSMS {
                    HStack(spacing: 5) {
                        Group {
                            Text("휴대폰 번호가 변경되었나요?")
                            
                            Text("이메일로 계정 찾기")
                                .underline()
                                .onTapGesture {
                                    print("로그::: 이메일로 계정 찾기 클릭!!!")
                                }
                        }
                        .font(.body21420Regular)
                        .foregroundColor(.gray800)
                    }
                    .padding(.top, 30)
                }
                
                if isSendSMS {
                    //MARK: - 인증번호 입력
                    TextField(
                        optNumber_placeholder,
                        text: $otpNumber
                    )
                    .onAppear {
                        // 인증번호 입력 키보드 올리기
                        isOtpNumberFocused = true
                    }
                    .onChange(of: otpNumber) {
                        if otpNumber.count > 0 {
                            isSendSMSCheckEnable = true
                        } else {
                            isSendSMSCheckEnable = false
                        }
                    }
                    .font(.title41824Medium)
                    .foregroundColor(.gray900)
                    .keyboardType(.numberPad)
                    .focused($isOtpNumberFocused)
                    .background(Color.gray25)
                    .textFieldStyle(PhoneNumberTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(isPhoneNumberFocused ? Color.gray200 : Color.gray800, lineWidth: 1))
                    .padding(.top, 20)
                    
                    Text("어떤 경우에도 타인에게 공유하지 마세요!")
                        .font(.caption11218Regular)
                        .foregroundColor(.gray300)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 7)
                    
                    Button(action: {
                        if isSendSMSCheckEnable {
                            //
                            fLog("")
                        }
                    }, label: {
                        Text("인증번호 확인")
                            .font(.title41824Medium)
                            .foregroundColor(isSendSMSCheckEnable ? Color.gray25 : Color.gray300)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(isSendSMSCheckEnable ? Color.primaryDefault : Color.gray100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.top, 15)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
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
        
        
    }
    
    private func insertSpaceInMiddle(_ number: String) -> String {
        var returnNumber = number
        
        //print("로그::: returnNumber.count : \(returnNumber.count)")
        if returnNumber.count > 0 {
            
            switch (returnNumber.count) {
            case 4:
                // "0106" 입력받았음 -> "010 6"으로 변경
                if let NOlastNumber = returnNumber.last {
                    returnNumber = returnNumber.dropLast() + " " + String(NOlastNumber)
                }
                return returnNumber
            case 9:
                // "010 63504" 입력받았음 -> "010 6350 4"으로 변경
                if let NOlastNumber = returnNumber.last {
                    returnNumber = returnNumber.dropLast() + " " + String(NOlastNumber)
                }
                return returnNumber
            default:
                return returnNumber
            }
        } else {
            return ""
        }
    }
}

#Preview {
    LoginPage()
}


extension String {
    var lastString: String {
        get {
            if self.isEmpty { return self }
            
            let lastIndex = self.index(before: self.endIndex)
            return String(self[lastIndex])
        }
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
