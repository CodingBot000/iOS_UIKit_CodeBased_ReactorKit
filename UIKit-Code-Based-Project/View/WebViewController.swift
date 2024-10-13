//
//  WebViewController.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/12/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    private let url: URL
    private let webView = WKWebView()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

   
    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    // MARK: - WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
    }
}
#if DEBUG
import SwiftUI

struct WebViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeUIViewController(context: Context) -> UIViewController {
        let url = URL(string: "https://www.google.com")!
        return WebViewController(url: url)
    }
}

struct WebViewController_Previews: PreviewProvider {
    static var previews: some View {
        WebViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
