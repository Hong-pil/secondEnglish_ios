//
//  CustomTextField.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import UIKit
import SwiftUI

struct CustomTextField: UIViewRepresentable {
    enum CustomTextFieldType: Int {
        case Default
        case Security
        case Search
    }
    
    @Binding var text: String
    @Binding var correctStatus: CheckCorrectStatus
    @Binding var isKeyboardEnter: Bool
    @Binding var isFocused: Bool
    
    var placeholder: String
    var isFirstResponder: Bool = false
    var type: CustomTextFieldType = .Default
    let textField = UITextField(frame: .zero)
    var limit: Int? = nil
    var onLimited: (() -> Void)?
    
    var shouldClearHandler: ((String?) -> Void)? = nil
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.placeHolderColor = UIColor.gray400
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        

        if type == .Default {
            fLog("디폴트콜")
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 0.3
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            //            textField.clearButtonMode = .whileEditing
            textField.setLeftPaddingPoints(15.0)
            
            let paddingView = UIView(frame: .zero)
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: 38).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: 42).isActive = true

            let imageView = UIImageView(image: UIImage(named: "btn_delete"))
            imageView.tintColor = UIColor.stateEnableGray200
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let tapGR = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.clear(sender:)))
            imageView.addGestureRecognizer(tapGR)
            imageView.isUserInteractionEnabled = true
            paddingView.addSubview(imageView)
            
            imageView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
            
            textField.rightView = paddingView
            textField.rightViewMode = .whileEditing
        }
        else if type == .Security {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 7.0
            textField.isSecureTextEntry = true
            textField.setLeftPaddingPoints(15.0)
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 42))
  
            let normalImage = UIImage(named: "icon_outline_eye")?.withRenderingMode(.alwaysTemplate)
            let selectedImage = UIImage(named: "icon_outline_eye_closed")?.withRenderingMode(.alwaysTemplate)
            
            let button = UIButton(type: .custom)
            button.setImage(normalImage, for: .selected)
            button.setImage(selectedImage, for: .normal)
            button.tintColor = UIColor.gray400
//            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 42)
            button.addTarget(context.coordinator, action: #selector(Coordinator.checkVisible(_:)), for: .touchUpInside)
            paddingView.addSubview(button)
            
            textField.rightView = paddingView
            textField.rightViewMode = .always
            
//            let checkButton = UIImageView()
//            checkButton.image = UIImage(named: "icon_fill_check")
//            checkButton.frame = CGRect(x: 0, y: 0, width: 50, height: 42)
//            checkButton.alpha = 0
            
        }
        else if type == .Search {
            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 0.3
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 8.0
            textField.clearButtonMode = .whileEditing   // 텍스트 초기화 버튼 추가
            
            let paddingView = UIView(frame: .zero)
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: 38).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: 42).isActive = true
  
            let imageView = UIImageView(image: UIImage(named: "icon_search_small"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview(imageView)
            
            imageView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
            
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = self.text
//        if isFirstResponder {
//            uiView.becomeFirstResponder()
//            context.coordinator.didFirstResponder = true
//        }
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
        
        if correctStatus == .Correct {
            uiView.layer.borderWidth = 1
            uiView.layer.borderColor = UIColor.primary500.cgColor
        }
        else if correctStatus == .Wrong {
            uiView.layer.borderWidth = 1
//            uiView.layer.borderColor = UIColor.stateDanger.cgColor
        }
        else {
            uiView.layer.borderWidth = 0.3
            uiView.layer.borderColor = UIColor.gray100.cgColor
        }
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        Coordinator(textField: self.textField,
                    text: self.$text,
                    correctStatus: self.$correctStatus,
                    isKeyboardEnter: self.$isKeyboardEnter,
                    isFocused: self.$isFocused,
                    limit: self.limit,
                    onLimited: self.onLimited,
                    shouldClearHandler: self.shouldClearHandler)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var correctStatus: CheckCorrectStatus
        @Binding var isKeyboardEnter: Bool
        @Binding var isFocused: Bool
        var didFirstResponder = false
        var textField = UITextField(frame: .zero)
        var shouldClearHandler: ((String?) -> Void)?
        var limit: Int? = nil
        var onLimited: (() -> Void)?
        
        init(textField:UITextField,
             text: Binding<String>,
             correctStatus: Binding<CheckCorrectStatus>,
             isKeyboardEnter: Binding<Bool>,
             isFocused: Binding<Bool>,
             limit: Int?,
             onLimited: (() -> Void)?,
             shouldClearHandler: ((String?) -> Void)?) {
            self.textField = textField
            self._text = text
            self._correctStatus = correctStatus
            self._isKeyboardEnter = isKeyboardEnter
            self._isFocused = isFocused
            self.limit = limit
            self.onLimited = onLimited
            self.shouldClearHandler = shouldClearHandler
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let limit = limit, let text = textField.text, text.count > limit {
                textField.text = String(text.prefix(limit))
                onLimited?()
                
                return
            }
            
            if !text.isEmpty && textField.text?.isEmpty == true {
                shouldClearHandler?(textField.text)
            }
            
            self.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //self.isKeyboardEnter = true
            textField.resignFirstResponder()
            return true
        }
        
        @objc func checkVisible(_ sender: UIButton) {
            if sender.isSelected {
                self.textField.isSecureTextEntry = true
                sender.isSelected = false
                
            }
            else {
                self.textField.isSecureTextEntry = false
                sender.isSelected = true
            }
        }
        
        @objc
        func clear(sender : AnyObject) {
            self.text = ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFocused = true
//
//            if correctStatus == .Check {
//                textField.layer.borderColor = UIColor.gray100.cgColor
//            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.isKeyboardEnter.toggle()
            
            self.isFocused = false
//
//            if correctStatus == .Check {
//                textField.layer.borderColor = UIColor.primary500.cgColor
//            }
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            shouldClearHandler?(textField.text)
            return true
        }
    }
}

extension UITextField {

    func modifyClearButtonWithImage(image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRectMake(0, 0, 40, 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.tintColor = UIColor.gray100
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    @objc
    func clear(sender : AnyObject) {
        self.text = ""
    }

}


extension UIImage {
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
}


//네비 > 검색 안돼서 따로 만들어 둠 상세 수정 예정
struct SearchCustomTextField: UIViewRepresentable {

    @Binding var text: String
    @Binding var correctStatus: CheckCorrectStatus
    @Binding var isKeyboardEnter: Bool
    
    var placeholder: String
    var isFirstResponder: Bool = false
    let textField = UITextField(frame: .zero)
    
    
    func makeUIView(context: UIViewRepresentableContext<SearchCustomTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.placeHolderColor = UIColor.gray400
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            textField.font = UIFont.body21420Regular
            textField.textColor = UIColor.gray870
            textField.backgroundColor = UIColor.gray50
            textField.layer.borderWidth = 0.3
            textField.layer.borderColor = UIColor.gray100.cgColor
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 8.0
            textField.clearButtonMode = .whileEditing   // 텍스트 초기화 버튼 추가
            
            let paddingView = UIView(frame: .zero)
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: 38).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: 42).isActive = true
  
            let imageView = UIImageView(image: UIImage(named: "icon_search_small"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview(imageView)
            
            imageView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
            
            textField.leftView = paddingView
            textField.leftViewMode = .always
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<SearchCustomTextField>) {
        if text != uiView.text {
            uiView.text = text
        }
        
//        if isFirstResponder && !context.coordinator.didFirstResponder {
//            uiView.becomeFirstResponder()
//            context.coordinator.didFirstResponder = true
//        }
        
        if correctStatus == .Correct {
            uiView.layer.borderWidth = 1
            uiView.layer.borderColor = UIColor.primary500.cgColor
        }
        else if correctStatus == .Wrong {
            uiView.layer.borderWidth = 1
            //            uiView.layer.borderColor = UIColor.stateDanger.cgColor
        }
        else {
            uiView.layer.borderWidth = 0.3
            uiView.layer.borderColor = UIColor.gray100.cgColor
        }
      }

      func makeCoordinator() -> Coordinator {
          Coordinator(textField: self.textField,
                      text: self.$text,
                      correctStatus: self.$correctStatus)
      }
      
      class Coordinator: NSObject, UITextFieldDelegate {
          @Binding var text: String
          @Binding var correctStatus: CheckCorrectStatus
          var textField = UITextField(frame: .zero)

          
          init(textField:UITextField,
               text: Binding<String>,
               correctStatus: Binding<CheckCorrectStatus>) {
              self.textField = textField
              self._text = text
              self._correctStatus = correctStatus

          }

        func textFieldDidChangeSelection(_ textField: UITextField) {
          guard textField.markedTextRange == nil, text != textField.text else {
            return
          }
          text = textField.text ?? ""
        }


        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
        }
      }
}
