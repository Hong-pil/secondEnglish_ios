//
//  PageableScrollView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

/**
 * ScrollView Pull to Refresh
 * ScrollView에서 당겨서 새로고침 기능
 */
import SwiftUI

private enum PositionType {
    case fixed, moving
}

private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]
    static var defaultValue = [Position]()
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY)])
        }
    }
}

typealias RefreshCompleted = () -> Void
typealias DoRefresh = (@escaping RefreshCompleted) -> Void

private let THRESHOLD: CGFloat = 50
private enum RefreshState {
    case waiting, primed, loading
}

struct PageableScrollView<Content: View>: View {
    let doRefresh: OnRefresh
    let doOffsetChange: (CGFloat) -> Void
    let content: Content

    @State private var state = RefreshState.waiting

    init(
        @ViewBuilder content: () -> Content,
        doRefresh: @escaping DoRefresh,
        doOffsetChange: @escaping (CGFloat) -> Void
    ) {
        self.content = content()
        self.doRefresh = doRefresh
        self.doOffsetChange = doOffsetChange
    }

    var body: some View {
        ScrollView(showsIndicators: true) {
            
            ZStack(alignment: .top) {
                PositionIndicator(type: .moving)
                    .frame(height: 0)

                offsetReader
                content
                // 아래 .alignmentGuide 적용하면, 리프레시 직후 통통 튀는 문제가 있음.
//                    .alignmentGuide(.top, computeValue: { _ in
//                        (state == .loading) ? -THRESHOLD : 0
//                    })
                
                ActivityIndicator(isAnimating: state == .loading) {
                    $0.hidesWhenStopped = false
                }
                //.opacity((state == .loading) ? 1 : 0)
                .offset(y: (state == .loading) ? THRESHOLD : -20)
            }
        }
        .background(PositionIndicator(type: .fixed))
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            if state != .loading {
                DispatchQueue.main.async {
                    let movingY = values.first { $0.type == .moving }?.y ?? 0
                    let fixedY = values.first { $0.type == .fixed }?.y ?? 0
                    let offset = movingY - fixedY

                    if offset > THRESHOLD && state == .waiting {
                        state = .primed

                    } else if offset < THRESHOLD && state == .primed {
                        state = .loading
                        doRefresh {
                            withAnimation {
                                self.state = .waiting
                            }
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: doOffsetChange)
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0) // 👈🏻 make sure that the reader doesn't affect the content height
    }
}


/// Contains the gap between the smallest value for the y-coordinate of
/// the frame layer and the content layer.
private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
