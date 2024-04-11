//
//  SpeechSynthesizerManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/10/24.
//

import Combine
import AVFoundation
import NaturalLanguage

/**
 ChatGPT 코드 설명, 내용 읽어보고, 정리할 것.
 
 
 주요 변경 사항은 다음과 같습니다:

 - SpeechSynthesizerManager 클래스가 이제 NSObject를 상속받습니다.
 - NSObject, ObservableObject, 및 AVSpeechSynthesizerDelegate 프로토콜을 준수하도록 클래스 정의가 수정되었습니다.
 - override init() 생성자에서 super.init() 호출을 추가하여 NSObject의 초기화 과정을 올바르게 처리합니다.
 - 이러한 수정을 통해 AVSpeechSynthesizerDelegate를 올바르게 구현하고, 초기화 과정에서 speechSynthesizer.delegate = self 할당이 가능해졌습니다. 이제 SwiftUI 앱 내에서 Text-to-Speech 기능을 구현하고 음성 합성이 완료되는 순간을 감지할 수 있습니다.
 
 
 
 
 
 좀 더 자세히 설명해줘.
 
 
 물론이죠, SwiftUI와 AVSpeechSynthesizer를 사용하여 Text-to-Speech 기능을 구현하고, 음성 합성이 완료되는 순간을 감지하는 과정을 자세히 설명드리겠습니다. 에러 메시지를 해결하기 위해 SpeechSynthesizerManager 클래스가 NSObject를 상속받아야 하는 이유와 수정된 코드의 동작 방식에 대해서도 다루겠습니다.

 왜 NSObject 상속이 필요한가?
 AVSpeechSynthesizerDelegate 프로토콜은 NSObjectProtocol을 준수하는 객체에서만 사용할 수 있습니다. Swift에서 NSObjectProtocol을 준수하려면 NSObject 클래스를 상속받는 클래스를 만들어야 합니다. NSObject는 Objective-C의 기본 클래스로, Objective-C 런타임의 기능을 Swift 클래스에 제공합니다. AVSpeechSynthesizer와 같은 많은 UIKit 및 AVFoundation 프레임워크 구성 요소는 Objective-C에서 온 것이기 때문에, 이들과 상호 작용할 때는 종종 NSObject를 상속받아야 합니다.

 코드 설명
 1. 클래스 정의 변경
 
 class SpeechSynthesizerManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
     ...
 }
 SpeechSynthesizerManager 클래스가 이제 NSObject를 상속받고, ObservableObject 프로토콜과 AVSpeechSynthesizerDelegate 프로토콜을 준수합니다. NSObject를 상속받음으로써 이 클래스의 인스턴스는 Objective-C 런타임 기능을 활용할 수 있고, AVSpeechSynthesizerDelegate 메서드를 올바르게 구현할 수 있습니다.

 
 
 2. 초기화 과정과 delegate 설정
 override init() {
     super.init()
     speechSynthesizer.delegate = self
     ...
 }
 NSObject를 상속받는 클래스는 init 메서드에서 super.init()을 호출해야 합니다. 이 호출은 부모 클래스인 NSObject의 초기화 과정을 수행합니다. 초기화 과정에서 speechSynthesizer의 delegate로 현재 인스턴스(self)를 설정합니다. 이렇게 하면 SpeechSynthesizerManager 클래스가 AVSpeechSynthesizer의 이벤트(예: 음성 합성 완료)를 받을 수 있게 됩니다.
 
 
 3. Delegate 메서드 구현
 func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
     didFinishSpeech.send(())
 }
 speechSynthesizer(_:didFinish:) 메서드는 음성 합성이 완료될 때마다 AVSpeechSynthesizer에 의해 호출됩니다. 이 메서드 내에서 didFinishSpeech.send(())를 호출하여 음성 합성이 완료되었음을 SpeechSynthesizerManager 클래스 내부의 다른 부분에 알립니다.
 
 
 4. Combine을 사용한 상태 관리
 음성 합성의 시작과 완료 상태는 @Published 프로퍼티와 Combine의 PassthroughSubject를 통해 관리됩니다. 이를 통해 SwiftUI 뷰에서 음성 합성의 상태를 선언적으로 반영할 수 있습니다.

 결론
 위에서 설명한 코드와 구조는 SwiftUI 앱 내에서 AVSpeechSynthesizer를 사용하여 Text-to-Speech 기능을 구현하고, 음성 합성이 완료되는 순간을 선언적으로 처리할 수 있는 방법을 제공합니다. NSObject를 상속받고, Combine을 사용한 이벤트 및 상태 관리를 통해, SwiftUI의 선언
 
 GPT 최고!
 
 
 */
class SpeechSynthesizerManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var didFinishSpeech = PassthroughSubject<Void, Never>()
    
    @Published var isSpeaking: Bool = false
    @Published var isPaused: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    let languageRecognizer = NLLanguageRecognizer() // 언어 감지 (아웃풋 : en, ko, ..)
    
    override init() {
        super.init()
        
        didFinishSpeech.sink { [weak self] _ in
            self?.isSpeaking = false
        }
        .store(in: &cancellables)
        
        speechSynthesizer.delegate = self
    }
    
    func speak(_ text: String) {
        // ChatGPT 원래 코드
//        if speechSynthesizer.isSpeaking {
//            return // 이미 말하고 있다면, 새로운 말하기 요청을 무시합니다.
//        }
//        
//        let utterance = AVSpeechUtterance(string: text)
//        isSpeaking = true
//        isPaused = false
//        speechSynthesizer.speak(utterance)
        
        
        
        
        if speechSynthesizer.isSpeaking {
            return // 이미 말하고 있다면, 새로운 말하기 요청을 무시합니다.
        }
        
        languageRecognizer.processString(text)
        
        if let dominantLanguage = languageRecognizer.dominantLanguage {
            fLog("idpil::: 감지된 언어 : \(dominantLanguage.rawValue)")
            
            /**
             * 설정
             */
            let utterance = AVSpeechUtterance(string: text)
            utterance.pitchMultiplier = 1.0 // 목소리의 높낮이
            utterance.rate = 0.5 // 읽는 속도
            //utterance.volume = 1.0 // 음성 볼륨
            //utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            //fLog("idpil::: speechVoices: \(AVSpeechSynthesisVoice.speechVoices())")
            utterance.voice = AVSpeechSynthesisVoice(language: dominantLanguage.rawValue)
            
            /**
             * 실행
             */
            isSpeaking = true
            isPaused = false
            speechSynthesizer.speak(utterance)
        }
    }
    
    func pauseSpeaking() {
        let wasPaused = speechSynthesizer.pauseSpeaking(at: .immediate)
        isPaused = wasPaused
    }
    
    func stopSpeaking() {
        let wasStopped = speechSynthesizer.stopSpeaking(at: .immediate)
        if wasStopped {
            isSpeaking = false
            isPaused = false
        }
    }
    
    
    // AVSpeechSynthesizerDelegate 메서드 구현
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        didFinishSpeech.send(())
//    }
    
    // AVSpeechSynthesizerDelegate 메서드 구현
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        didFinishSpeech.send(())
    }
}
