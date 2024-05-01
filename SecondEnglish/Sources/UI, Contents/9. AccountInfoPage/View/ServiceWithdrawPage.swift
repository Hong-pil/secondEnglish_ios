//
//  ServiceWithdrawPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/31/24.
//

import SwiftUI

struct ServiceWithdrawPage {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var viewModel = ServiceWithdrawViewModel()
    
    @State var checkState:Bool = false
    @State var showAlert:Bool = false
    @State var showPassword = false
    
    @Binding var withdrawState: Bool
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let padding10: CGFloat = 10.0
        static let padding14: CGFloat = 14.0
        static let padding20: CGFloat = 20.0
        static let spacing4: CGFloat = 4.0
        static let spacing10: CGFloat = 10.0
        static let spacing20: CGFloat = 20.0
        static let cornerRadius5: CGFloat = 5.0
        static let cornerRadius16: CGFloat = 16.0
        static let height1: CGFloat = 1.0
        static let height10: CGFloat = 10.0
        static let height22: CGFloat = 22.0
        // kdg, honor 없어서 높이 수정함
        static let height236: CGFloat = 260.0
        static let btnLogoIconSize: CGSize = CGSize(width: 24, height: 24)
        static let checkIconSize: CGSize = CGSize(width: 20, height: 20)
    }
}

//일단 회원 삭제 api는 붙였는데, 아직 해야할 기능이 남아있다.
//1. 서비스 탈퇴 알럿 뷰에서, '유저가 작성한 글, 좋아요한 수, 좋아요 받은 수 등 정보' api 콜해서 보여주기
//2. 현재 구현된 회원 탈퇴 api 에서는 단순히 회원만 삭제하는데, '회원이 작성한 글, 좋아요 등 정보'도 삭제해야 됨.
//3. 회원 삭제후, 동일한 계정으로 회원가입하면, 닉네임 입력화면으로 넘어 가는데, 이때 네트워크 에러 알럿 뜬다. 고칠 것.
//4. 로그아웃하면, 홈화면으로 이동시킨 후 로그인 뷰 띄울 것.
//5. 홈화면에서 리프레시 기능 추가할 것.
//6. 로그아웃 후, 재로그인했을 때 홈화면 로딩되게 수정할 것. (Pull To Refresh)
extension ServiceWithdrawPage: View {
    var body: some View {
        VStack(spacing: 0) {
            closeButton
            
            VStack(alignment: .leading, spacing: sizeInfo.spacing20) {
                Spacer().frame(height: sizeInfo.padding10)
                HStack {
                    Image("btn_logo_\(UserManager.shared.loginUserType)")
                        .resizable()
                        .frame(width: sizeInfo.btnLogoIconSize.width, height: sizeInfo.btnLogoIconSize.height, alignment: .center)
                    Text(UserManager.shared.account)
                        .font(Font.body11622Regular)
                        .foregroundColor(Color.black)
                }
                ExDivider(color: .bgLightGray50, height: sizeInfo.height1)
                    .padding(.vertical, -6)
                
                WithdrawDescriptionView
                    .padding(.top, -8)
                WithdrawDeleteDescriptionView
                
                Spacer().frame(maxHeight: .infinity)
                
                VStack {
                    Button(action:
                            {
                        self.checkState = !self.checkState
                        fLog("State : \(self.checkState)")
                    })  {
                        HStack(spacing: sizeInfo.spacing10) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit).frame(height: 10)
                                .foregroundColor(.gray25)
                                .padding(5)
                                .background(Circle().fill(self.checkState ? Color.primaryDefault : Color.gray200))

                            
                            Text("se_j_agree_delete_retention_info".localized)
                                .font(Font.buttons1420Medium)
                                .foregroundColor(Color.gray870)
                            Spacer()
                        }
                        
                    }.padding(.top, sizeInfo.padding5)
                    
                    Spacer().frame(height: sizeInfo.height22)
                    
                    HStack(alignment: .bottom) {
                        Button {
                            if checkState {
                                showAlert = true
                            }
                        } label: {
                            CommonButton(title: "s_leave".localized, bgColor: checkState ? Color.primaryDefault : Color.gray200)
                        }
                    }
                }
            }
            .padding(.horizontal, sizeInfo.padding20)
            .onAppear(perform: {
                viewModel.requestFanitPoint()
            })
        }
        .implementPopupView()
        .showCustomAlert(isPresented: $showAlert,
                         type: .Default,
                         title: "s_leave".localized,
                         message: "se_t_sure_want_withdraw".localized,
                         detailMessage: "",
                         buttons: ["t_do_leave".localized, "t_cancel_leave".localized],
                         onClick: { buttonIndex in
            if buttonIndex == 0 {
                viewModel.requestUserWithdrawal() { success in
                    presentationMode.wrappedValue.dismiss()
                    withdrawState = true
                }
            }
        })
    }
    
    var WithdrawDescriptionView: some View {
        VStack(alignment: .leading, spacing: sizeInfo.spacing20) {
            Text("se_j_really_leave".localized)
                .font(Font.title32028Bold)
            Text("se_t_check_info_when_withdraw".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray850)
            //                .kerning(0.5)
//            Text("se_t_after_use_withdraw_account".localized)
//                .font(Font.body21420Regular)
//                .foregroundColor(Color.gray850)
//            //                .kerning(0.5)
        }
    }
    
    var WithdrawDeleteDescriptionView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: sizeInfo.spacing4) {
                Text("s_delete".localized)
                    .font(Font.buttons1420Medium)
                    .multilineTextAlignment(.leading)
                
                Text("g_account_profile_info".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("j_like_post".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_block_post".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
                
                Text("b_block_user".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
//                
//                Text("\("b_have_fan_it".localized) \(viewModel.fanit == "" ? "0" : viewModel.fanit)")
//                    .font(Font.caption11218Regular)
//                    .foregroundColor(Color.gray700)
//                    .multilineTextAlignment(.leading)
//                    .padding(.bottom, 14)
                
                //                Text("b_have_kdg".localized)
                //                    .font(Font.caption11218Regular)
                //                    .foregroundColor(Color.gray700)
                //                    .multilineTextAlignment(.leading)
                //
                //                Text("b_have_honor".localized)
                //                    .font(Font.caption11218Regular)
                //                    .foregroundColor(Color.gray700)
                //                    .multilineTextAlignment(.leading)
                //                    .padding(.bottom, 10)
                
                Text("a_maintain".localized)
                    .font(Font.buttons1420Medium)
                    .multilineTextAlignment(.leading)
                
                Text("j_wrote_post".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray700)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, sizeInfo.padding14)
            .padding(.horizontal, sizeInfo.padding20)
        }
        .frame(maxWidth: .infinity, maxHeight: sizeInfo.height236, alignment: .topLeading)
        .background(Color.bgLightGray50.cornerRadius(sizeInfo.cornerRadius16))
        
    }
    
    var WithdrawStayDescriptionView: some View {
        VStack(alignment: .leading, spacing: sizeInfo.spacing10){
            Text("a_maintain".localized)
                .font(Font.buttons1420Medium)
            Text("n_keep_my_post_1".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray800)
            Spacer().frame(height: sizeInfo.height10)
            ExDivider(color: .bgLightGray50, height: sizeInfo.height1)
        }
    }
    
    //MARK: - toolBarButton
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack(spacing: 10) {
                Image("icon_outline_cancel")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("s_leave".localized)
                    .font(.title41824Medium)
                    .foregroundColor(Color.gray900)
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, sizeInfo.padding20)
    }
}

#Preview {
    ServiceWithdrawPage(withdrawState: .constant(false))
}
