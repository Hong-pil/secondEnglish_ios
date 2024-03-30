//
//  InfiniteCarousel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 3/23/24.
//

import SwiftUI
import Combine

/**
 * [Ref] https://github.com/dancarvajc/SwiftUI-Infinite-Carousel
 */
public struct InfiniteCarousel<Content: View, T: Any>: View {
    
    // MARK: Properties
    @Environment(\.scenePhase) var scenePhase
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    
    @State private var selectedTabIndex: Int = 1
    var returnIndex: (Int, Bool, Bool) -> Void = {_,_,_ in} // (인덱스, 첫번째유무, 마지막유무) // 값을 변경하기 때문에 @State 타입으로 선언해야 됨. @State 타입으로 선언하지 않으면 자동모드에서 카드 넘겨질 때 애니메이션 효과 적용 안 됨.
    @State private var isMoveFirst: Bool = false
    @State private var isMoveLast: Bool = false
    
    var isAutoPlay: Bool = false
    
    @State private var isScaleEnabled: Bool = true
    private let data: [T]
    private let seconds: Double
    private let content: (T) -> Content
    private let showAlternativeBanner: Bool // true 이면 무한 루프 안 됨.
    var height: CGFloat
    private let horizontalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let transition: TransitionType
    
    // MARK: Init
    public init(
        data: [T],
        secondsDisplayingBanner: Double = 3,
        height: CGFloat,
        horizontalPadding: CGFloat = 30,
        cornerRadius: CGFloat = 10,
        transition: TransitionType = .scale,
        returnIndex: @escaping(Int, Bool, Bool) -> Void,
        isAutoPlay: Bool,
        @ViewBuilder content: @escaping (T) -> Content)
    {
        /**
         * 무한 루프 로직 설명 :
         * 배열의 마지막 요소를 첫 번째에 추가하고, 첫 번째 요소를 마지막 번째에 추가한다.
         * 결과 => [item 4, item 1, item 2, item 3, item 4, item 1]
         * 그래서 탭 인덱스가 변경될 때, 첫 번째와 마지막 번째일 때 동일한 아이템으로 이동시킨다.
         * 즉,
         * 인덱스가 0(item 4)이면 -> 배열의 (arr.count - 2)번째 아이템(item 4)으로 이동시킨다.
         * 인덱스가 배열의 마지막 번째 아이템(item 1)이면 -> 배열의 (1)번째 아이템(item 1)으로 이동시킨다.
         */
        var modifiedData = data
        if let firstElement = data.first, let lastElement = data.last {
            modifiedData.append(firstElement)
            modifiedData.insert(lastElement, at: 0)
            showAlternativeBanner = false
        } else {
            showAlternativeBanner = true
        }
        self._timer = .init(initialValue: Timer.publish(every: secondsDisplayingBanner, on: .main, in: .common))
        self.data = modifiedData
        self.content = content
        self.seconds = secondsDisplayingBanner
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.cornerRadius = cornerRadius
        self.transition = transition
        self.returnIndex = returnIndex
        self.isAutoPlay = isAutoPlay
    }

    public var body: some View {
        TabView(selection: $selectedTabIndex) {
            /*
             The data passed to ForEach is an array ([T]), but the actually data ForEach procesess is an array of tuples: [(1, data1),(2, data2), ...].
             With this, we have the data and its corresponding index, so we don't have the problem of the same id, because the real index for ForEach is using for identify the items is the index generated with the zip function.
             */
            ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                GeometryReader { proxy in
                    let positionMinX = proxy.frame(in: .global).minX
                    
                    content(item)
                        .cornerRadius(cornerRadius)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .rotation3DEffect(transition == .rotation3D ? getRotation(positionMinX) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        .opacity(transition == .opacity ? getValue(positionMinX) : 1)
                        .scaleEffect(isScaleEnabled && transition == .scale ? getValue(positionMinX) : 1)
                        .padding(.horizontal, horizontalPadding)
                        .onChange(of: positionMinX) {
                            // If the user change the position of a banner, the offset is different of 0, so we stop the timer
                            // 배너 이동 중
                            if positionMinX != 0 {
                                stopTimer()
                            }
                            // When the banner returns to its initial position (user drops the banner), start the timer again
                            // 배너 이동 완료
                            if positionMinX == 0 {
                                if self.isAutoPlay {
                                    startTimer()
                                }
                            }
                        }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: height)
        .onChange(of: selectedTabIndex) {
            if showAlternativeBanner {
                guard selectedTabIndex < data.count else {
                    withAnimation {
                        selectedTabIndex = 0
                    }
                    return
                }
            } else {
                if isAutoPlay {
                    /**
                     * public init() 에서 아래와 같이 배열의 첫 번째와 마지막 번째에 추가한다.
                     * 결과 => [item 4, item 1, item 2, item 3, item 4, item 1]
                     *
                     * 인덱스가 0(item 4)이면 -> 배열의 (arr.count - 2)번째 아이템(item 4)으로 이동시킨다.
                     * 인덱스가 배열의 마지막 번째 아이템(item 1)이면 -> 배열의 (1)번째 아이템(item 1)으로 이동시킨다.
                     */
                    if selectedTabIndex == 0 {
                        // UI상, 첫 번째 카드에서 왼쪽으로 넘긴 경우
                        
                        // 0.3초 뒤에 카드를 넘기기 때문에, 0.3초 뒤에 실행해야 됨.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isMoveLast = true // 아래 selectedTabIndex 값을 변경하기 때문에 else문을 타지 않기 위함
                            selectedTabIndex = data.count - 2
                        }
                        
                        // 0.3초 뒤에 selectedTabIndex 변수가 설정되기 때문에 0.4초 뒤에 실행해야 됨.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            returnIndex(selectedTabIndex, false, true)
                        }
                    }
                    else if selectedTabIndex == data.count - 1 {
                        // UI상, 마지막 번째 카드에서 오른쪽으로 넘긴 경우
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isMoveFirst = true // 아래 selectedTabIndex 값을 변경하기 때문에 else문을 타지 않기 위함
                            selectedTabIndex = 1
                        }
                        
                        // 0.3초 뒤에 selectedTabIndex 변수가 설정되기 때문에 0.4초 뒤에 실행해야 됨.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            returnIndex(selectedTabIndex, true, false)
                        }
                    }
                    else {
                        if !isMoveFirst && !isMoveLast {
                            // 0.3초 뒤에 카드를 넘기기 때문에, 0.3초 뒤에 실행해야 됨.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                returnIndex(selectedTabIndex, false, false)
                            }
                        }
                        
                        isMoveFirst = false
                        isMoveLast = false
                    }
                }
                else {
                    if selectedTabIndex == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isMoveLast = true
                            selectedTabIndex = data.count - 2
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                returnIndex(selectedTabIndex, false, true)
                            }
                        }
                        
                    }
                    else if selectedTabIndex == data.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isMoveFirst = true
                            selectedTabIndex = 1
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                returnIndex(selectedTabIndex, true, false)
                            }
                        }
                    }
                    else {
                        if !isMoveFirst && !isMoveLast {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                returnIndex(selectedTabIndex, false, false)
                            }
                        }
                        
                        isMoveFirst = false
                        isMoveLast = false
                    }
                }
                
                
            }
        }
        .onAppear {
            // 다른 탭으로 이동하는 것 뿐만 아니라 동일한 화면에서 스크롤 오르/내릴 때에도 onAppear/onDisappear 호출됨.
            
            if isAutoPlay {
                startTimer()
            }
            isScaleEnabled = true
        }
        .onDisappear {
            // 다른 탭으로 이동하는 것 뿐만 아니라 동일한 화면에서 스크롤 오르/내릴 때에도 onAppear/onDisappear 호출됨.
            
            if isAutoPlay {
                stopTimer()
            }
            isScaleEnabled = false
        }
        .onReceive(timer) { _ in
            withAnimation {
                selectedTabIndex += 1
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                startTimer()
            case .background, .inactive:
                stopTimer()
            default:
                break
            }

        }
        .onChange(of: isAutoPlay) {
            if isAutoPlay {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
}

// Helpers functions
extension InfiniteCarousel {
    
    // Get rotation for rotation3DEffect modifier
    private func getRotation(_ positionX: CGFloat) -> Angle {
        return .degrees(positionX / -10)
    }
    
    // Get the value for scale and opacity modifiers
    private func getValue(_ positionX: CGFloat) -> CGFloat {
        let scale = 1 - abs(positionX / UIScreen.main.bounds.width)
        return scale
    }
    
    private func startTimer() {
        guard cancellable == nil else {
            return
        }
        timer = Timer.publish(every: seconds, on: .main, in: .common)
        cancellable = timer.connect()
    }
    
    private func stopTimer() {
        guard cancellable != nil else {
            return
        }
        cancellable?.cancel()
        cancellable = nil
    }
}

public enum TransitionType {
    case rotation3D, scale, opacity
}

struct TestView: View {
    @State private var isActive: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                InfiniteCarousel(
                    data: ["Element 1", "Element 2", "Element 3", "Element 4"],
                    height: 250,
                    returnIndex: { index, isMoveFirst, isMoveLast in
                        
                    },
                    isAutoPlay: false,
                    content: { element in
                        Text(element)
                            .font(.title.bold())
                            .padding()
                            .background(Color.green)
                    }
                )
                
                Button(action: {
                    isActive = true
                }, label: {
                    Text("Next screen")
                })
            }
            .navigationDestination(isPresented: $isActive) {
                Text("Next screen")
            }
        }
    }
}

#Preview {
    TestView()
}
