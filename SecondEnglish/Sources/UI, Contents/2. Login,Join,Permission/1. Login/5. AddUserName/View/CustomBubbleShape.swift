//
//  CustomBubbleShape.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/22/24.
//

import SwiftUI

// ChatGTP4
// 질문 내용 : swiftui 에서 꼬리 위치와 간격을 조절할 수 있는 말풍선 view를 만드는 방법을 알려줘.
struct CustomBubbleShape: Shape {
    var tailWidth: CGFloat = 20
    var tailHeight: CGFloat = 10
    var tailPosition: CGFloat // 꼬리의 위치 (0.0 ~ 1.0 사이의 값으로, 말풍선 너비에 대한 비율)
    var tailDirection: TailDirection // 꼬리의 방향 (up, down, left, right)
    var tailOffset: CGFloat // 꼬리와 본체의 간격

    enum TailDirection {
        case up, down, left, right
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 말풍선 본체
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))

        // 꼬리 위치 계산
        var tailOrigin: CGPoint
        switch tailDirection {
        case .up:
            tailOrigin = CGPoint(x: rect.width * tailPosition - tailWidth / 2, y: tailOffset)
        case .down:
            tailOrigin = CGPoint(x: rect.width * tailPosition - tailWidth / 2, y: rect.height - tailHeight - tailOffset)
        case .left:
            tailOrigin = CGPoint(x: tailOffset, y: rect.height * tailPosition - tailHeight / 2)
        case .right:
            tailOrigin = CGPoint(x: rect.width - tailWidth - tailOffset, y: rect.height * tailPosition - tailHeight / 2)
        }

        // 꼬리 그리기
        let tailPath = Path { p in
            p.move(to: tailOrigin)
            switch tailDirection {
            case .up, .down:
                p.addLine(to: CGPoint(x: tailOrigin.x + tailWidth / 2, y: tailOrigin.y + (tailDirection == .up ? -tailHeight : tailHeight)))
                p.addLine(to: CGPoint(x: tailOrigin.x + tailWidth, y: tailOrigin.y))
            case .left, .right:
                p.addLine(to: CGPoint(x: tailOrigin.x + (tailDirection == .left ? -tailHeight : tailHeight), y: tailOrigin.y + tailHeight / 2))
                p.addLine(to: CGPoint(x: tailOrigin.x, y: tailOrigin.y + tailHeight))
            }
            p.closeSubpath()
        }
        path.addPath(tailPath)

        return path
    }
}


#Preview {
    CustomBubbleShape(
        tailWidth: 10,
        tailHeight: 5,
        tailPosition: 0.2,
        tailDirection: .up,
        tailOffset: 0
    )
}
