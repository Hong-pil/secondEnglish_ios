//
//  AlertPage.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/19/24.
//

import SwiftUI
import SDWebImageSwiftUI
import SwipeCellSUI

struct AlertPage {
    @StateObject var viewModel = AlertPageViewModel()
    @State var currentUserInteractionCellID: String?
}

extension AlertPage: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.primary600.opacity(0.12))
                .padding(.top, 10)
            
            if !viewModel.isPageLoading, viewModel.alimList.isEmpty {
                emptyView
            }
            else {
                ScrollView(showsIndicators: false) {
                    itemListView
                    
                    Spacer()
                }
            }
        }
        .onAppear() {
            self.callRemoteData()
        }
        .navigationType(
            leftItems: [.Back],
            rightItems: [],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: "a_notification".localized,
            onPress: { buttonType in
            })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("character_main2")
                .frame(width: 118, height: 124)

            Text("se_a_not_has_alarm_list".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
                .multilineTextAlignment(.center)
                .padding(.top, 14)
            
            Spacer()
        }
    }
    
    var itemListView: some View {
        ForEach(Array(viewModel.alimList.enumerated()), id: \.offset) { index, element in
            
            AlertItem(data: element, tapped: {
//                viewModel.alimRead(id: element.alimId ?? 0) {
//                    
//                }
            })
            .swipeCell(id: String(element.alimId ?? 0),
                       cellWidth: UIScreen.width,
                       leadingSideGroup: [],
                       trailingSideGroup: swipeCellRightGroup(element.alimId ?? 0),
                       currentUserInteractionCellID: $currentUserInteractionCellID)
            .onAppear() {
                moreData(data: element)
            }

        }
    }
    
    func swipeCellRightGroup(_ alimId: Int) -> [SwipeCellActionItem] {
        [
            SwipeCellActionItem(
                buttonView: {
                    VStack {
                        Text("s_delete".localized)
                            .font(Font.caption21116Regular)
                            .foregroundColor(Color.stateActiveGray25)
                    }
                    .castToAnyView()
                },
                backgroundColor: .stateDanger,
                actionCallback: {
//                    viewModel.alimDelete(id: alimId) {
//                        viewModel.getAlimList()
//                    }
                })
        ]
    }
}

extension AlertPage {
    func callRemoteData() {
        //self.viewModel.getAlimList()
    }
    
    func moreData(data: AlimMessage) {
//        if
//            let nextId = viewModel.alimModel?.nextId,
//            let next = Int(nextId),
//            next > 0,
//            viewModel.alimList.last == data
//        {
//            viewModel.getAlimList(nextId: nextId)
//        }
    }
}

struct AlertPage_Previews: PreviewProvider {
    static var previews: some View {
        AlertPage()
    }
}

struct AlertItem: View {
    
    let data: AlimMessage
    var simple: Bool = false
    
    let tapped: () -> Void
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                WebImage(url: URL(string: data.image?.imageOriginalUrl ?? ""))
                    .placeholder(content: {
                        Image("club_img_default")
                            .resizable()
                    })
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if simple {
                        Text(data.text01 ?? "")
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray870)
                            .lineLimit(1)
                    } else {
                        Text(data.text01 ?? "")
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray870)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if data.text02 != "" && !simple {
                        Text(data.text02 ?? "")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray800)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 6)
                    }
                    
                    HStack(spacing: 0) {
                        Text(data.text03 ?? "")
                            .font(.caption11218Regular)
                            .foregroundColor(.gray400)
                        
                        Text(" • ")
                            .font(.system(size: 20))
                            .foregroundColor(.gray400)
                        
                        Text("".changeDateFormat_Custom(strDate: data.createDate ?? ""))
                            .font(.caption11218Regular)
                            .foregroundColor(.gray400)
                    }
                }
                .padding(.leading, 12)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 16,
                                leading: sizeInfo.Hpadding,
                                bottom: simple ? 0 : 16,
                                trailing: sizeInfo.Hpadding))
            .background(Color.gray25)
            .opacity((data.status ?? 0) == 1 ? 0.5 : 1)
            
            if !simple {
                Divider()
            }
        }
        .onTapGesture {
            let linkUrl = data.link ?? ""
            if linkUrl.count > 0 {
                tapped()
                LandingManager.shared.check(
                    isAlertPage: true,
                    params: CommonFunction.getParameters(url: linkUrl)
                )
            }
        }
    }
}


#Preview {
    AlertPage()
}
