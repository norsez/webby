//
//  TextDisplayViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/8/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class TextDisplayViewController: UIViewController {

    var font: UIFont = UIFont.systemFontOfSize(12)
    var contentEncoding: ContentEncoding?

    var loadTextButton: UIBarButtonItem?
    var statusLabel: UILabel?
    
    let KEY_LAST_PASTED_TEXT = "KEY_LAST_PASTED_TEXT"

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTextButton = UIBarButtonItem(title: "Load text from clipboard", style: .Plain, target: self, action: #selector(loadTextFromClipboard))
        self.navigationItem.rightBarButtonItem = self.loadTextButton

        //create status bar
        self.statusLabel = UILabel()
        self.statusLabel?.font = UIFont.systemFontOfSize(12)
        let statusTextBarButtonItem = UIBarButtonItem(customView: self.statusLabel!)
        self.toolbarItems = [statusTextBarButtonItem]
        self.updateStatusBar()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.font = self.font
        self.textView.text = TextCacheManager.shared.text
        
        
    }
    
    @objc func loadTextFromClipboard () {
        if let t = UIPasteboard.generalPasteboard().string {
            TextCacheManager.shared.text = t
            self.textView.text = t
            self.contentEncoding = nil
            self.updateStatusBar()
        }
    }

    func updateStatusBar() {

        if let enc = self.contentEncoding {
            self.statusLabel?.text = "font: \(self.font.fontName)\nencoding:\(enc)"
        } else {
            self.statusLabel?.text = "font: \(self.font.fontName)\nencoding:???"
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
