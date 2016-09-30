//
//  ViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/1/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let KEY_ESTIMATED_PROGRESS = "estimatedProgress"

    var webView: WKWebView?
    var loadButton: UIBarButtonItem?

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var topTextField: UITextField!

    fileprivate var loadedURL: URL?

    fileprivate func startup() {

        self.webView = WKWebView(frame: CGRect.zero)
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        self.view.insertSubview(self.webView!, belowSubview: self.progressView)
        self.webView?.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        let views = ["addressBar": self.topTextField, "webView": self.webView!, "progressBar": self.progressView] as [String : Any]
        constraints.append( contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[addressBar]-[webView]-|", options: [], metrics: nil, views: views))
        constraints.append( contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-[webView]-|", options: [], metrics: nil, views: views))

        self.view.addConstraints(constraints)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startup()


        self.loadButton = UIBarButtonItem(title: "Load URL", style: .plain, target: self, action: #selector(loadURLfromClipboard))

        let loadHTMLButton = UIBarButtonItem(title: "Load HTML", style: .plain, target: self, action: #selector(loadHTMLfromClipboard))

        self.navigationItem.rightBarButtonItems = [self.loadButton!, loadHTMLButton]

        UIPasteboard.general.string = "http://7daydaily.com"
        self.progressView.progress = 0
        self.progressView.isHidden = true
        self.loadURLfromClipboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView?.addObserver(self, forKeyPath: self.KEY_ESTIMATED_PROGRESS, options: .new, context: nil)
      self.loadURLfromClipboard()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView?.removeObserver(self, forKeyPath: self.KEY_ESTIMATED_PROGRESS)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.KEY_ESTIMATED_PROGRESS {
            self.progressView.progress = Float((self.webView?.estimatedProgress)!)
        }

        self.progressView.isHidden = self.progressView.progress == 0 || self.progressView.progress == 1

        //print("loading progress: \(self.webView?.estimatedProgress) ")
    }

    func loadHTMLfromClipboard () {
        guard let html = UIPasteboard.general.string else {
            self.topTextField.text = "no text pasted."
            return
        }

        self.webView!.loadHTMLString(html, baseURL:nil)
        self.topTextField.text = "loaded html from clipboard length: \(html.lengthOfBytes(using: String.Encoding.utf8)) chars"
    }

    func loadURLfromClipboard () {
        print("\(UIPasteboard.general.string!)")
        guard let urlString = UIPasteboard.general.string else {
            self.displayText("No url in the clipboard")
            return
        }

        guard let url = URL(string: urlString) else {
            self.displayText("\(urlString) isn't a valid URL")
            return
        }

        let req = URLRequest(url: url)
        self.progressView.progress = 0
        self.webView!.load(req)
        self.topTextField.text = "loading \(url)…"
        self.loadedURL = url
    }

    fileprivate func displayText(_ text: String) {
        let actrl = UIAlertController(title: "Info", message: text, preferredStyle: .alert)
        actrl.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(actrl, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("ok")
        self.progressView.progress = 0
        if let url = self.loadedURL {
            self.topTextField.text = "🔗\(url)"
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("")
        decisionHandler(.allow)
    }

}
