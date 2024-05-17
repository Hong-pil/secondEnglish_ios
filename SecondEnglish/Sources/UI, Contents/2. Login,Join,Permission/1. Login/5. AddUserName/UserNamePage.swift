//
//  UserNamePage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/21/24.
//

import SwiftUI

struct UserNamePage {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = LoginViewModel()
    
    var authSuccessedLoginId: String
    var authSuccessedLoginType: LoginUserType
    
    @FocusState private var isKeyboardFocused: Bool
    @State private var txt: String = ""
    @State private var isNameCheckOK: Bool = false
}

extension UserNamePage: View {
    var body: some View {
        LoadingViewContainer {
            // footView 키보드 바로 위에 붙을 수 있도록 해줌
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        
                        Text("se_nickname_page_title".localized)
                            .font(.title22432Bold)
                            .foregroundColor(.gray900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("se_nickname_page_content".localized)
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray800)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("se_nickname_page_word".localized)
                                .font(.caption11218Regular)
                                .foregroundColor(isNameCheckOK ? .black : .red)
                            
                            HStack(spacing: 5) {
                                
                                TextField("", text: $txt)
                                    .font(.title41824Medium)
                                    .foregroundColor(.gray900)
                                    .focused($isKeyboardFocused)
                                    .padding(.vertical, 5).background(Color.gray25) // TextField 클릭 감도 올림
                                
                                Button(action: {
                                    if !txt.isEmpty { txt = "" }
                                }, label: {
                                    Image("icon_fill_input_cancel")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
                                        .opacity(txt.isEmpty ? 0 : 1.0)
                                })
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                        .padding(.top, 20)
                        .overlay(
                            VStack {
                                if txt.isEmpty {
                                    emptyBubbleShapeView
                                }
                                else if !isNameCheckOK {
                                    wrongInputBubbleShapeView
                                }
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // footerView 키보드 바로 위에 붙을 수 있도록 해줌
                    .padding(.horizontal, 20)
                }
                
                footerView
            }
            .onAppear {
                // 키보드 올리기
                isKeyboardFocused = true
            }
            .onChange(of: txt, initial: true) { oldValue, newValue in
                
                //fLog("idpil::: oldValue : \(oldValue)")
                //fLog("idpil::: newValue : \(newValue)")
                //fLog("idpil::: 유효성 검사 : \(self.analyzeKoreanCharacters(newValue))")
                
                isNameCheckOK = self.analyzeKoreanCharacters(newValue)
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
        
        
    }
    
    var footerView: some View {
        VStack {
            if isKeyboardFocused {
                Button(action: {
                    if !txt.isEmpty && isNameCheckOK {
                        // 폰번호 입력 키보드 내리기
                        self.isKeyboardFocused = false
                        
                        self.requestLogin()
                    }
                }, label: {
                    Text("a_done".localized)
                        .font(.title41824Medium)
                        .foregroundColor(isNameCheckOK ? .gray25 : .primaryDefault)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(isNameCheckOK ? Color.primaryDefault : Color.gray40))
                })
            }
            else {
                Button(action: {
                    if !txt.isEmpty && isNameCheckOK {
                        // 폰번호 입력 키보드 내리기
                        self.isKeyboardFocused = false
                        
                        self.requestLogin()
                    }
                }, label: {
                    Text("a_done".localized)
                        .font(.title41824Medium)
                        .foregroundColor(isNameCheckOK ? .gray25 : .primaryDefault)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(txt.isEmpty ? Color.gray200 : Color.black, lineWidth: 1))
                        .background(RoundedRectangle(cornerRadius: 20).fill(isNameCheckOK ? Color.primaryDefault : Color.gray40))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                })
            }
        }
    }
    
    var emptyBubbleShapeView: some View {
        CustomBubbleShape(
            tailWidth: 10,
            tailHeight: 5,
            tailPosition: 0.2,
            tailDirection: .up,
            tailOffset: 0
        )
        .fill(Color.red)
        .frame(width: 140, height: 30)
        .overlay(
            Text("se_nickname_page_warning_empty".localized)
                .font(.caption11218Regular)
                .foregroundColor(.gray25)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 20, y: 53)
    }
    
    var wrongInputBubbleShapeView: some View {
        CustomBubbleShape(
            tailWidth: 10,
            tailHeight: 5,
            tailPosition: 0.2,
            tailDirection: .up,
            tailOffset: 0
        )
        .fill(Color.red)
        .frame(width: 170, height: 30)
        .overlay(
            Text("se_nickname_page_warning_format".localized)
                .font(.caption11218Regular)
                .foregroundColor(.gray25)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 20, y: 53)
    }
    
    
}

extension UserNamePage {
    // [ChatGTP] swiftui 에서 textfield를 사용해서 한글 이름을 입력받을 때,  입력된 글자가 자음인지 모음인지 판단하는 방법을 알려줘.
    // 입력된 글자 중에서, 자음 또는 모음이 하나라도 단독으로 있으면 안 됨
    func analyzeKoreanCharacters(_ text: String) -> Bool {
        var checkOKArr: [Bool] = []
        
        for char in text {
            if let scalar = char.unicodeScalars.first?.value {
                if scalar >= 0x3131 && scalar <= 0x314E {
                    //print("\(char): 자음")
                    checkOKArr.append(false)
                } else if scalar >= 0x314F && scalar <= 0x3163 {
                    //print("\(char): 모음")
                    checkOKArr.append(false)
                } else if scalar >= 0xAC00 && scalar <= 0xD7A3 {
                    //print("\(char): 조합형 한글")
                    checkOKArr.append(true)
                } else {
                    //print("\(char): 한글이 아님")
                    checkOKArr.append(true)
                }
            }
        }
        
        // 입력된 글자 중에서, 자음 또는 모음이 하나라도 단독으로 있으면 안 됨
        for isCheckResult in checkOKArr {
            if !isCheckResult {
                return false
            }
        }
        
        if checkOKArr.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func requestLogin() {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        
        viewModel.requestAddSnsUser(
            loginId: authSuccessedLoginId,
            loginType: authSuccessedLoginType,
            user_nickname: txt
        ) {
            // 로딩되는거 보여주려고 딜레이시킴
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                StatusManager.shared.loadingStatus = .Close
                UserManager.shared.showLoginView = false
            }
        }
    }
}

#Preview {
    UserNamePage(authSuccessedLoginId: "", authSuccessedLoginType: .Apple)
}
