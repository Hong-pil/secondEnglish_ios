//
//  ActivityIndicator.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    public typealias UIView = UIActivityIndicatorView
    public var isAnimating: Bool = false
    public var configuration = { (indicator: UIView) in }

    public init(isAnimating: Bool, configuration: ((UIView) -> Void)? = nil) {
        self.isAnimating = isAnimating
        if let configuration = configuration {
            self.configuration = configuration
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        UIView()
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
