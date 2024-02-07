//
//  TabHomeControlPanel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/4/24.
//

import SwiftUI

struct TabHomeControlPanel: View {
    @Binding var spacing: CGFloat
    @Binding var headspace: CGFloat
    @Binding var sidesScaling: CGFloat
    @Binding var isWrap: Bool
    @Binding var autoScroll: Bool
    @Binding var duration: TimeInterval
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("spacing: ").frame(width: 120)
                    Slider(value: $spacing, in: 0...30, minimumValueLabel: Text("0"), maximumValueLabel: Text("30")) { EmptyView() }
                }
                HStack {
                    Text("headspace: ").frame(width: 120)
                    Slider(value: $headspace, in: 0...30, minimumValueLabel: Text("0"), maximumValueLabel: Text("30")) { EmptyView() }
                }
                HStack {
                    Text("sidesScaling: ").frame(width: 120)
                    Slider(value: $sidesScaling, in: 0...1, minimumValueLabel: Text("0"), maximumValueLabel: Text("1")) { EmptyView() }
                }
                HStack {
                    Toggle(isOn: $isWrap, label: {
                        Text("wrap: ").frame(width: 120)
                    })
                }
                VStack {
                    HStack {
                        Toggle(isOn: $autoScroll, label: {
                            Text("autoScroll: ").frame(width: 120)
                        })
                    }
                    if autoScroll {
                        HStack {
                            Text("duration: ").frame(width: 120)
                            Slider(value: $duration, in: 1...10, minimumValueLabel: Text("1"), maximumValueLabel: Text("10")) { EmptyView() }
                        }
                    }
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

//#Preview {
//    TabHomeControlPanel()
//}
