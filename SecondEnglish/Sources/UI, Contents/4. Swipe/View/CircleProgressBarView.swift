//
//  CircleProgressBarView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/17/24.
//

import SwiftUI

struct CircleProgressBarView: View {
    var width: CGFloat
    var height: CGFloat
    var color1: Color
    var color2: Color
    @Binding var percent: Double
    
    var body: some View {
        // width의 비율에 따라 선의 두께를 지정하기 위해 multiplier 설정
        let multiplier = width / 40
        //트림하고 남은 영역이 진행 상태를 나타내는 부분으로 이를 역으로 계산
        //에를 들어 0.1 에서 1.0 까지 트림하는 경우 원의 10% 부분이 잘리고 남아있는 부분은 90%가 됨
        let progress = 1 - (percent / 100)
        
        return ZStack {
            
            //배경 원의 stroke 함수를 통해서 원의 외곽선을 그리고 원의 크기 지정
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round))
                .frame(width: width, height: height)
            
            //trim 함수를 이용해 progress 값만 큼 원의 외곽선을 잘라 냄
            Circle()
                .trim(from: progress, to: 1)
            
            //진행바는 리니어 그라데이션을 이용
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round))
                .frame(width: width, height: height)
            //상태바가 오른쪽 끝에서 반 시계 방향으로 회전하므로 이를 위쪽 끝에서 시계방향으로
            //이동하게 하기 위해 시계 방향 90도 이동후 x축을 기준으로 뒤집어 준다.
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .shadow(color: color2, radius: 14 * multiplier, x: 0.0, y: 14 * multiplier)
            
            //진행상황 표시용 레이블
            if percent > 0 {
                Text("\(Int(percent))%")
                    .font(.system(size : 14 * multiplier))
                    .fontWeight(.bold)
            }
        }
    }
}
