//
//  CustomFocusTextField.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI
import Swift

struct CustomFocusTextField: UIViewRepresentable {
    enum CustomFocusTextFieldType: Int {
        case Default
        case Search
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var correctStatus: CheckCorrectStatus
        @Binding var isKeyboardEnter: Bool
        var didBecomeFirstResponder = false
        var didFirstResponder = false
        var textField = UITextField(frame: .zero)
        var limit: Int? = nil
        var onLimited: (() -> Void)?
        var onShouldReturn: ((UITextField) -> Bool)?
        var onShouldBeginEditing: ((UITextField) -> Bool)?
        var onShouldSpaceBar: ((UITextField) -> Bool)?
        
        init(textField:UITextField,
             text: Binding<String>,
             correctStatus: Binding<CheckCorrectStatus>,
             isKeyboardEnter: Binding<Bool>,
             limit: Int?,
             onLimited: (() -> Void)?,
             onShouldReturn: ((UITextField) -> Bool)?,
             onShouldBeginEditing: ((UITextField) -> Bool)?,
             onShouldSpaceBar: ((UITextField) -> Bool)?
        ) {
            self.textField = textField
            self._text = text
            self._correctStatus = correctStatus
            self._isKeyboardEnter = isKeyboardEnter
            self.limit = limit
            self.onLimited = onLimited
            self.onShouldReturn = onShouldReturn
            self.onShouldBeginEditing = onShouldBeginEditing
            self.onShouldSpaceBar = onShouldSpaceBar
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if
                let limit = limit,
                let text = textField.text,
                text.count > limit {
                textField.text = String(text.prefix(limit))
                onLimited?()
                
                return
            }
            
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return onShouldReturn?(textField) ?? true
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return onShouldBeginEditing?(textField) ?? true
        }
        
        // 스페이스 인식 (해시태그 등록)
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == " " {
                //fLog("Spacebar pressed!")
                //fLog("text : \(text)")
                //fLog("text.count : \(text.count)")
                
                // 예외처리 1
                if text.count == 0 {
                    text = ""
                    
                    return false
                }
                // 예외처리 2 - 스페이스바 입력시 인식이기 때문에
                // 처음부터 스페이스바를 연속으로 두 번 입력한 경우 아래 조건으로 들어옴
                else if text.count == 1 && text == " " {
                    text = ""
                    
                    return false
                }
                
                return onShouldSpaceBar?(textField) ?? true
            }
            
            return true
        }
    }
    
    let textField = UITextField(frame: .zero)
    var placeholder: String
    var isFirstResponder: Bool = false
    
    @Binding var text: String
    @Binding var correctStatus: CheckCorrectStatus
    @Binding var isKeyboardEnter: Bool
    var type: CustomFocusTextFieldType = .Default
    var limit: Int? = nil
    
    var onLimited: (() -> Void)?
    var onShouldReturn: ((UITextField) -> Bool)?
    var onShouldBeginEditing: ((UITextField) -> Bool)?
    var onShouldSpaceBar: ((UITextField) -> Bool)?
    
    
    func makeUIView(context: UIViewRepresentableContext<CustomFocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.placeHolderColor = UIColor.gray400
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        if type == .Default {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            textField.clearButtonMode = .whileEditing
            textField.setLeftPaddingPoints(15.0)
        }
        else if type == .Search {
            textField.font = UIFont.body21420Regular
            textField.returnKeyType = .done
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 42))
            
            let image = UIImage(named: "icon_outline_search")?.withRenderingMode(.alwaysTemplate)
            
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.stateEnableGray400
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 15, y: 0, width: 18, height: 42)
            paddingView.addSubview(imageView)
            
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        
        return textField
    }
    
    
    func makeCoordinator() -> CustomFocusTextField.Coordinator {
        //        return Coordinator(text: $text)
        
        return Coordinator(textField: self.textField,
                           text: self.$text,
                           correctStatus: self.$correctStatus,
                           isKeyboardEnter: self.$isKeyboardEnter,
                           limit: self.limit,
                           onLimited: self.onLimited,
                           onShouldReturn: self.onShouldReturn,
                           onShouldBeginEditing: self.onShouldBeginEditing,
                           onShouldSpaceBar: self.onShouldSpaceBar)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomFocusTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
        if correctStatus == .Correct {
            uiView.layer.borderColor = UIColor.primary500.cgColor
        }
        else if correctStatus == .Wrong {
            uiView.layer.borderColor = UIColor.stateDanger.cgColor
        }
        else {
            uiView.layer.borderColor = UIColor.gray100.cgColor
        }
    }
}
