//
//  WebView.swift
//  Weather
//
//  Created by jonathan saville on 22/03/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
#Preview {
    WebView(url: URL(string: "https://www.youtube.com/embed/UxFyCqJoOpE?playsinline=1")!)
}
