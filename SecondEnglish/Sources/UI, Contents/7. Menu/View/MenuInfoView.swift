//
//  MenuInfoView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct MenuInfoView: View {
    
    var mySentenceNum: Int
    var myPostLikeNum: Int
    var myGetLikeNum: Int
    
    let onPress: (MenuButtonType) -> Void
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 78.0
        
        static let textSpacing: CGFloat = 5.0
        static let dividerWidth: CGFloat = 1.0
        static let dividerPadding: CGFloat = 15.0
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    ZStack {
                        Button {
                            onPress(.Sentence)
                        } label: {
                            VStack {
                                Text(String(mySentenceNum))
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("j_wrote_post".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    
                    ZStack {
                        Button {
                            onPress(.PostLike)
                        } label: {
                            VStack {
                                Text(String(myPostLikeNum))
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("l_like_do".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    ZStack {
                        Button {
                            onPress(.GetLike)
                        } label: {
                            VStack {
                                Text(String(myGetLikeNum))
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("l_like_get".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}

//#Preview {
//    MenuInfoView()
//}
