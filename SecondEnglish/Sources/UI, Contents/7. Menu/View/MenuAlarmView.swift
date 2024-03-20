//
//  MenuAlarmView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI

struct MenuAlarmView: View {

    @StateObject var languageManager = LanguageManager.shared
    
    //MARK: - Variables
    let alimList: [AlimMessage]
    let unreadCount: Int
    let onCheck: (Int?) -> Void
    let onShow: () -> Void
    
    private struct sizeInfo {
        static let padding: CGFloat = 16.0
        static let cellHeight: CGFloat = 56.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGFloat = 18.0
        
        static let arrowLeading: CGFloat = 5.0
        static let arrowIconSize: CGFloat = 12.0
        
        static let bottomHeight1: CGFloat = 40.0        //모든 알림 보기.
        static let bottomHeight2: CGFloat = 50.0        //모든 알림을 다 확인했어요.
    }
    
    private struct colorInfo {
        static let topBarBgColor: Color = Color(red: 237/255.0, green: 240/255.0, blue: 250/255.0, opacity: 1.0)
        static let topTextButtonColor: Color = Color(red: 120/255.0, green: 132/255.0, blue: 169/255.0, opacity: 1.0)
        static let borderStroke: Color = Color(red: 214/255.0, green: 217/255.0, blue: 241/255.0, opacity: 1.0)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            //top
            HStack(spacing: 4) {
                Image("icon_fill_alarm")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: sizeInfo.iconSize, height: sizeInfo.iconSize)
                    .foregroundColor(.primaryDefault)
                
                Text("a_notification".localized)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(.primaryDefault)
                
                if unreadCount > 0 {
                    Text(unreadCount > 99 ? "99+" : "\(unreadCount)")
                        .font(Font.caption21116Regular)
                        .foregroundColor(Color.gray25)
                        .padding(EdgeInsets(top: 1, leading: 8, bottom: 2, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 9).fill(Color.stateDanger))
                        
                }
                
                Spacer()
                
                Button(
                    action: {
                        if unreadCount > 0 {
                            onCheck(nil)
                        }
                        else {
                            onShow()
                        }
                    },
                    label: {
                        Text(unreadCount > 0 ? "m_read_alam".localized : "a_previous_alam_check".localized)
                            .font(Font.caption11218Regular)
                            .foregroundColor(colorInfo.topTextButtonColor)
                    }
                )
            }
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .background(colorInfo.topBarBgColor)
            
            
            //bottom
            if unreadCount > 0 {
                ForEach(Array(alimList.enumerated()), id: \.offset) { index, element in
                    AlertItem(data: element, simple: true) {
                        onCheck(element.alimId)
                    }
                }
                
                Divider()
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
                
                Button(
                    action: {
                        onShow()
                    },
                    label: {
                        HStack(alignment: .center, spacing: 0) {
                            Text("m_view_alam".localized)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color(red: 91/255.0, green: 93/255.0, blue: 123/255.0, opacity: 1.0))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.7)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxHeight: .infinity, alignment: .leading)
                            
                            Image("icon_outline_go")
                                .resizable()
                                .frame(width: sizeInfo.arrowIconSize, height: sizeInfo.arrowIconSize, alignment: .leading)
                                .padding(.leading, sizeInfo.arrowLeading)
                        }
                        .frame(height: sizeInfo.bottomHeight1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
            }
            else {
                Text("se_m_all_alam_check".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray500)
                    .padding(.vertical, 20)
            }
        }
        .background(Color.gray25)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(colorInfo.borderStroke, lineWidth: 1))
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 12, trailing: 20))
    }
}

//#Preview {
//    MenuAlarmView()
//}
