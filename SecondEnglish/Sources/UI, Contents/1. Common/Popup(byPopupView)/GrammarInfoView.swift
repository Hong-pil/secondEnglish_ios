//
//  GrammarInfoView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/20/24.
//

import SwiftUI

struct GrammarInfoView: View {
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    private struct sizeInfo {
        static let grammarTextFont_title: Font = Font.title32028Bold
        static let grammarTextFont_content: Font = Font.caption11317Regular
        static let grammarTextFontColor_title: Color = Color.primaryDefault
        static let grammarTextFontColor_content: Color = Color.gray850
        static let grammarTextPaddingTop_title: CGFloat = 20.0
        static let grammarTextPaddingTop_content: CGFloat = 10.0
        static let grammarTextLineSpacing: CGFloat = 1.7
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let grammarInfo = bottomSheetManager.grammarInfo {
                    // 첫 번째만 (padding 값이 다름)
                    Group {
                        if let title = grammarInfo.step1_title,
                           let content = grammarInfo.step1_content {
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, 20)
                                
                                /**
                                 * 카테고리 글자에서 잘바꿈 하려고 중간에 개행문자(\n)를 입력해 놨다.
                                 * 문제는 값을 가져오면 \\n로 내려온다. 그래서 아래와 같이 변경해준다.
                                 * 원인) DB에서는 \n 을 \\n 으로 저장한다고 함.
                                 */
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                    }
                    .textSelection(.enabled)
                    .lineSpacing(sizeInfo.grammarTextLineSpacing) // 행간 설정
                    
                    Group {
                        if let title = grammarInfo.step2_title,
                           let content = grammarInfo.step2_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step3_title,
                           let content = grammarInfo.step3_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step4_title,
                           let content = grammarInfo.step4_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step5_title,
                           let content = grammarInfo.step5_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step6_title,
                           let content = grammarInfo.step6_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step7_title,
                           let content = grammarInfo.step7_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step8_title,
                           let content = grammarInfo.step8_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step9_title,
                           let content = grammarInfo.step9_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step10_title,
                           let content = grammarInfo.step10_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step11_title,
                           let content = grammarInfo.step11_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step12_title,
                           let content = grammarInfo.step12_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step13_title,
                           let content = grammarInfo.step13_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step14_title,
                           let content = grammarInfo.step14_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step15_title,
                           let content = grammarInfo.step15_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step16_title,
                           let content = grammarInfo.step16_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step17_title,
                           let content = grammarInfo.step17_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step18_title,
                           let content = grammarInfo.step18_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step19_title,
                           let content = grammarInfo.step19_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                        
                        if let title = grammarInfo.step20_title,
                           let content = grammarInfo.step20_content{
                            
                            if !title.isEmpty && !content.isEmpty {
                                Text(title)
                                    .font(sizeInfo.grammarTextFont_title)
                                    .foregroundColor(sizeInfo.grammarTextFontColor_title)
                                    .padding(.top, sizeInfo.grammarTextPaddingTop_title)
                                
                                Text((content).replacingOccurrences(of: "\\n", with: "\n"))
                                .font(sizeInfo.grammarTextFont_content)
                                .foregroundColor(sizeInfo.grammarTextFontColor_content)
                                .padding(.top, sizeInfo.grammarTextPaddingTop_content)
                            }
                        }
                    }
                    .textSelection(.enabled)
                    .lineSpacing(sizeInfo.grammarTextLineSpacing) // 행간 설정
                } else {
                    Text("no")
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    GrammarInfoView()
}
