//
//  ExpandingTextView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI


struct ExpandingTextView: View {
    @Binding var text: String
    @Binding var isKeyboardFocused: Bool
    var minHeight: CGFloat = 0
    var maxHeight: CGFloat = 0
    var font: UIFont? = nil
    var textColor: UIColor? = nil
    @State private var height: CGFloat?
    var textHeightChanged: ((CGFloat) -> Void)?
    @State private var heightSettingComplete = false
    
    // 클럽 멤버 아니면 키보드 올리지 않기
    @Binding var showNeedJoinToast: Bool
    var isClubMember: Bool

    var body: some View {
        WrappedTextView(text: $text,
                        font: font,
                        textColor: textColor,
                        textDidChange: self.textDidChange,
                        showNeedJoinToast: $showNeedJoinToast,
                        isClubMember: isClubMember
        )
        .frame(height: maxHeight > minHeight ? min((height ?? minHeight), maxHeight) : (height ?? minHeight))
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            /**
             * keyboardDidShowNotification 보다 더 빨리 호출되기 때문에 여기서 설정함
             */
            isKeyboardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            /**
             * keyboardDidHideNotification 보다 더 빨리 호출되기 때문에 여기서 설정함
             */
            isKeyboardFocused = false
        }
    }

    private func textDidChange(_ textView: UITextView) {
        self.height = max(textView.contentSize.height, minHeight)
        if
            !heightSettingComplete,
            let height = self.height {
            heightSettingComplete = true
            textHeightChanged?(height)
        }
    }
}


struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    var font: UIFont? = nil
    var textColor: UIColor? = nil
    let textDidChange: (UITextView) -> Void
    // 클럽 멤버 아니면 키보드 올리지 않기
    @Binding var showNeedJoinToast: Bool
    var isClubMember: Bool

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = .clear
        if let font = self.font {
            view.font = font
        }
        if let color = self.textColor {
            view.textColor = color
        }
        view.isEditable = true
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            textDidChange: textDidChange,
            showNeedJoinToast: $showNeedJoinToast,
            isClubMember: isClubMember
        )
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void
        // 클럽 멤버 아니면 키보드 올리지 않기
        @Binding var showNeedJoinToast: Bool
        var isClubMember: Bool

        init(
            text: Binding<String>,
            textDidChange: @escaping (UITextView) -> Void,
            showNeedJoinToast: Binding<Bool>,
            isClubMember: Bool
        ) {
            self._text = text
            self.textDidChange = textDidChange
            self._showNeedJoinToast = showNeedJoinToast
            self.isClubMember = isClubMember
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
        
        // 리턴값이 true -> 키보드 올림
        // 리턴값이 false -> 키보드 올리지 않음
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            if !isClubMember {
                showNeedJoinToast = true
                return false
            } else {
                return true
            }
        }
    }
}


