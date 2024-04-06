//
//  TabsV1.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/6/24.
//

import SwiftUI
import SwiftUIIntrospect

struct BackgroundView_first_0: View {
    var body: some View {
        Image("slicing_top_tab_first")
            .resizable(capInsets: EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 30))
            .renderingMode(.template)
            .foregroundColor(.gray25)
            .background(Color.stateActivePrimaryDefault)
    }
}
struct BackgroundView_choice_0: View {
    var body: some View {
        Image("slicing_top_tab_choice")
            .resizable(capInsets: EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            .renderingMode(.template)
            .foregroundColor(.gray25)
            .background(Color.stateActivePrimaryDefault)
    }
}
struct BackgroundView_bg_0: View {
    var body: some View {
        Image("slicing_top_tab_bg")
            .resizable(capInsets: EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .renderingMode(.template)
            .foregroundColor(.gray25)
            .background(Color.stateActivePrimaryDefault)
    }
}
struct BackgroundView_basic_0: View {
    var currentItemIndex: Int
    var selectedItemIndex: Int
    
    var body: some View {
        if currentItemIndex == selectedItemIndex {
            if currentItemIndex == 0 {
                return AnyView(BackgroundView_first_0())
            }
            else {
                return AnyView(BackgroundView_choice_0())
            }
        }
        /**
         * 아래 else 문 View : opacity 0.0 으로 줬기 때문에 투명한 View이다.
         * 아래 else 문 넣은 이유 : 넣지 않으면 탭 클릭시 깜빡이는 문제가 있음. 원인 분석해볼 것.
         */
        else {
            return AnyView(
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.0))
            )
        }
    }
}

struct TabsV1: View {
    let tabHeight: CGFloat = 62 // 위쪽 그림자 영역까지 포함해서 62
    var tabs: [TabMain]
    var geoWidth: CGFloat
    var tabtype: TabMainType
    @Binding var selectedTab: Int
    
    var selectedText : (Int, Int) -> Color = { currentItemIndex, selectedItemIndex in
        if currentItemIndex == selectedItemIndex {
            return Color.primaryDefault
        } else {
            return Color.gray25
        }
    }
    
    var selectedTextWidth : (CGFloat, Int) -> CGFloat = { geoWidth, selectedItemIndex in
        if selectedItemIndex == 0 {
            return geoWidth / CGFloat(4.0)
        }
        else {
            return geoWidth / CGFloat(2.5)
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 0) {
                    ForEach(0 ..< tabs.count, id: \.self) { row in
                        Button(action: {
                            withAnimation {
                                selectedTab = row
                            }
                        }, label: {
                            Text(tabs[row].title)
                                .font(.title5Roboto1622Medium)
                                .foregroundColor(selectedText(row, selectedTab))
                                .padding(.leading, row == 0 ? 30 : 45)
                                .padding(.trailing, row == 0 ? 45 : 45)
                        })
                        .frame(height: tabHeight)
                        .frame(maxWidth: .infinity)
                        .background(BackgroundView_basic_0(currentItemIndex: row, selectedItemIndex: selectedTab))
                    }
                }
                .onChange(of: selectedTab) {
                    withAnimation {
                        proxy.scrollTo(selectedTab)
                    }
                }
            }
        }
        .background(BackgroundView_bg_0())
        /**
         * 문제 :
         * 기본 ScrollView 설정에서는 좌우로  드래그하면 같이 움직이는 문제가 있음. (상단 Tab 메뉴는 고정되어야 함)
         *
         * 해결 :
         * 'UIKit 코드를 사용할 수 있도록 해주는 SwiftUI-Introspect 라이브러리'를 사용해서 수직-수평 모두 고정시켰음
         *
         * SwiftUIIntrospect 라이브러리 사용하는 이유 :
         * 아래 주석처리한 것처럼 UIScrollView.appearance().bounces = false 를 적용해도 Tab 메뉴가 고정되긴 하는데,
         * 문제는 Tab 메뉴 안의 다른 ScrollView 도 고정되서 PullToRefresh 기능 적용시 문제가 생겼다.
         * 물론 Tab 메뉴 안의 다른 ScrollView 에도 UIScrollView.appearance().bounces = true 를 적용하면 움직이긴 하지만
         * 다른 메뉴 이동 후 다시 오면 다시 고정되는 등의 다른 문제가 있었음.
         * 그래서 SwiftUI-Introspect 라이브러리를 사용해서 해결함 !
         */
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
        }
//        .onAppear(perform: {
//            UIScrollView.appearance().bounces = false
//        })
//        .onDisappear(perform: {
//            UIScrollView.appearance().bounces = false
//        })
    }
}

#Preview {
    TabsV1(tabs: [.init(title: "Tab 1"),
                  .init(title: "Tab 2")],
           geoWidth: 375,
           tabtype: TabMainType.vOne,
           selectedTab: .constant(0))
}
