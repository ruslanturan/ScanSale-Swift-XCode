//
//  VCPay.swift
//  ScanSale
//
//  Created by Ruslan Cahangirov on 5/15/20.
//  Copyright © 2020 Ruslan Cahangirov. All rights reserved.
//

import UIKit
import WebKit

class VCPay: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    var orderId:String = ""
    let vcPaymentResult = VCPaymentResult()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.myoutlet.ge/unipay/createorder/" + orderId)!
        webView.load(URLRequest(url: url))
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("myoutlet.ge") && !urlStr.contains("createorder"){
                self.navigationController?.pushViewController(vcPaymentResult, animated: true)
            }
            if urlStr.contains("unipay.com"){
                let urlArr = urlStr.split(separator: "=")
                vcPaymentResult.orderId = self.orderId
                vcPaymentResult.url = String(urlArr.last!)
            }
        }
        decisionHandler(.allow)
    }
}
