//
//  WebView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 4/30/24.
//

import UIKit
import SwiftUI
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webview = WKWebView()
        let request = URLRequest(url: self.url, cachePolicy: .useProtocolCachePolicy)
        
        webview.navigationDelegate = context.coordinator
        webview.load(request)
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            fLog("decidePolicyFor : \(String(describing: navigationAction.request.url))")
            
            if navigationAction.request.url?.absoluteString == parent.url.absoluteString + "#" {
                parent.presentationMode.wrappedValue.dismiss()
            }
            
            return decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            fLog("decidePoldidReceiveServerRedirectForProvisionalNavigationicyFor : \(String(describing: webView.url))")
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            fLog("탐색 시작")
            CommonFunction.onPageLoading()
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            fLog("내용 수신")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            fLog("탐색 완료")
            CommonFunction.offPageLoading()
        }
        
        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation: WKNavigation!,
                     withError: Error) {
            fLog("초기 탐색 프로세스 중에 오류가 발생했음 : \(withError)")
        }
        
        // 탐색 중에 오류가 발생했음 - Error Handler
        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            fLog("탐색 중에 오류가 발생했음")
        }
    }
}
