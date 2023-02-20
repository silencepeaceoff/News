//
//  NewsWebView.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/13/23.
//

import UIKit
import WebKit

class NewsWebView: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    var request: URLRequest?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let request = request {
            DispatchQueue.main.async {
                self.webView.load(request)
            }
        }
    }
}
