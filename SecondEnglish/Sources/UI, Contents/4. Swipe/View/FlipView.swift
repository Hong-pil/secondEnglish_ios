//
//  FlipView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

/*
Abstract:
The flip view container applies a 3D horizontal rotation effect to two views.
*/

/**
 * 코드 설명
 * - https://www.youtube.com/watch?v=v2Xf1gwcQSA
 */
import SwiftUI

struct FlipView<Front: View, Back: View> : View {
    let front: Front
    let back: Back
    let tap: () -> Void
    @Binding var flipped: Bool
    @Binding var disabled: Bool

    init(_ front: Front, _ back: Back,
         tap: @escaping () -> Void,
         flipped: Binding<Bool>,
         disabled: Binding<Bool>) {
        self.front = front
        self.back = back
        self.tap = tap
        self._flipped = flipped
        self._disabled = disabled
    }

    var body: some View {
        GeometryReader {
            FlipContent(front: self.front,
                        back: self.back,
                        size: $0.size,
                        tap: self.tap,
                        flipped: self.$flipped,
                        disabled: self.$disabled)
        }
    }
}

/**
 The FlipContent view applies a 3D rotation effect to the view when it is either
 tapped or dragged. To achieve the desired effect of the card having both a
 "front" and "back", when the view reaches 90 degrees of rotation the "front"
 view becomes translucent and the "back" view becomes opaque. This allows for
 seamlessly switching between the two views during the animation.
 */
private struct FlipContent<Front: View, Back: View> : View {
    let front: Front
    let back: Back
    let size: CGSize
    let tap: () -> Void
    @Binding var flipped: Bool
    @Binding var disabled: Bool

    @State var angleTranslation: Double = 0.0

    init(front: Front, back: Back, size: CGSize,
         tap: @escaping () -> Void,
         flipped: Binding<Bool>,
         disabled: Binding<Bool>) {
        self.front = front
        self.back = back
        self.size = size
        self.tap = tap
        self._flipped = flipped
        self._disabled = disabled
    }
    
    func flip() {
        withAnimation {
            self.flipped.toggle()
            self.angleTranslation = 0.0
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            front
                .opacity(self.showingFront ? 1.0 : 0.0)
            back
                .scaleEffect(CGSize(width: -1.0, height: 1.0))
                .opacity(self.showingFront ? 0.0 : 1.0)
        }
        .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 0.0, maxHeight: .infinity, alignment: .center)
        .rotation3DEffect(.degrees(self.totalAngle), axis: (0.0, 1.0, 0.0), perspective: 0.5)
        .contentShape(Rectangle())
        .onTapGesture {
            if !self.disabled {
                self.flip()
                self.tap()
            }
        }
        /**
         * 아래 주석처리한 코드는 좌-우 Swipe 시, 제스처한 방향으로 카드를 뒤집는 기능을 함
         * 주석처리한 이유는 이 뷰를 호출하는 SwipeView() 에서 DragGesture() 를 사용해야 하는데,
         * 아래 코드에서 DragGesture() 를 사용하기 때문에 우선순위로 인해
         * SwipeView() 에서 DragGesture() 기능이 안 먹힘.
         * 그것도 있고, 굳이 좌-우 Swipe 해서 카드를 뒤집을 필요는 없음 (탭시 뒤집으면 됨)
         */
//        .simultaneousGesture(
//            self.disabled ? nil :
//            DragGesture(minimumDistance: 5, coordinateSpace: .local)
//                .onChanged { value in
//                    self.angleTranslation = Double((value.translation.width / self.size.width)) * 180.0
//                }
//                .onEnded { value in
//                    let endAngle = Double((value.predictedEndTranslation.width / self.size.width)) * 180.0
//
//                    withAnimation{
//                        if endAngle >= 90.0 {
//                            if self.flipped {
//                                self.angleTranslation = 0
//                            } else {
//                                self.angleTranslation = 360
//                            }
//                            self.flipped.toggle()
//                        } else if endAngle < -90.0 {
//                            if self.flipped {
//                                self.angleTranslation = -360
//                            } else {
//                                self.angleTranslation = 0
//                            }
//                            self.flipped.toggle()
//                        } else {
//                            self.angleTranslation = 0
//                        }
//                    }
//                })
    }
    
    var baseAngle: Double {
        self.flipped ? -180 : 0
    }
    
    var totalAngle: Double {
        baseAngle + angleTranslation
    }

    var clampedAngle: Double {
        var clampedAngle = angleTranslation + baseAngle
        while clampedAngle < 360.0 {
            clampedAngle += 360.0
        }
        return clampedAngle.truncatingRemainder(dividingBy: 360.0)
    }

    var showingFront: Bool {
        return clampedAngle < 90.0 || clampedAngle > 270.0
    }
}

struct TranslatingAngleState {
    @Binding var flipped: Bool
    
    init(_ flipped: Binding<Bool>) {
        self._flipped = flipped
    }
    
    var angleTranslation: Double = 0.0
    
    var angle: Double {
        self.flipped ? -180 : 0
    }
    
    var total: Double {
        angle + angleTranslation
    }

    var clamped: Double {
        var clampedAngle = angleTranslation + angle
        while clampedAngle < 360.0 {
            clampedAngle += 360.0
        }
        return clampedAngle.truncatingRemainder(dividingBy: 360.0)
    }

    var showingFront: Bool {
        let clampedAngle = clamped
        return clampedAngle < 90.0 || clampedAngle > 270.0
    }
}
