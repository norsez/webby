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

    private func startup() {
        let path = NSBundle.mainBundle().pathForResource("zawgyi", ofType: "ttf")
        print(path)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startup()

        self.webView = WKWebView(frame: self.view.bounds)
        self.webView?.UIDelegate = self
        self.webView?.navigationDelegate = self
        self.view.insertSubview(self.webView!, belowSubview: self.progressView)

        self.loadButton = UIBarButtonItem(title: "Load URL", style: .Plain, target: self, action: #selector(loadURLfromClipboard))

        let loadHTMLButton = UIBarButtonItem(title: "Load HTML", style: .Plain, target: self, action: #selector(loadHTMLfromClipboard))

        self.navigationItem.rightBarButtonItems = [self.loadButton!, loadHTMLButton]

        UIPasteboard.generalPasteboard().string = "http://7daydaily.com"
        self.progressView.progress = 0
        self.progressView.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.webView?.addObserver(self, forKeyPath: self.KEY_ESTIMATED_PROGRESS, options: .New, context: nil)
      self.loadURLfromClipboard()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView?.removeObserver(self, forKeyPath: self.KEY_ESTIMATED_PROGRESS)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == self.KEY_ESTIMATED_PROGRESS {
            self.progressView.progress = Float((self.webView?.estimatedProgress)!)
        }

        self.progressView.hidden = self.progressView.progress == 0 || self.progressView.progress == 1
    }

    func loadHTMLfromClipboard () {
        guard let html = UIPasteboard.generalPasteboard().string else {
            print ("no html content in clipboard")
            return
        }

        self.webView!.loadHTMLString(html, baseURL: NSURL(string:"http://google.com"))
    }

    func loadURLfromClipboard () {
        print("\(UIPasteboard.generalPasteboard().string!)")
        guard let urlString = UIPasteboard.generalPasteboard().string else {
            self.displayText("No url in the clipboard")
            return
        }

        guard let url = NSURL(string: urlString) else {
            self.displayText("\(urlString) isn't a valid URL")
            return
        }

        let req = NSURLRequest(URL: url)
        self.progressView.progress = 0
        self.webView!.loadRequest(req)
    }

    private func displayText(text: String) {
        let actrl = UIAlertController(title: "Info", message: text, preferredStyle: .Alert)
        actrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(actrl, animated: true, completion: nil)
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("ok")
        self.progressView.progress = 0
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
    }

    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge,
                 completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        let cred = NSURLCredential.init(forTrust: challenge.protectionSpace.serverTrust!)
        completionHandler(.UseCredential, cred)
    }


}
