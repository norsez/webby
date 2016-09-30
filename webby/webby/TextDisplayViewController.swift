//
//  TextDisplayViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/8/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class TextDisplayViewController: UIViewController {
    class ActivityDoThis: UIActivity {
        let completion: () -> Void
        let title: String

        init(withTitle title: String, completion:@escaping () -> Void) {
            self.completion = completion
            self.title = title
        }
        
        override var activityType : UIActivityType? {
            return nil
        }

        override var activityTitle : String? {
            return self.title
        }

        override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
            return true
        }

        override func perform() {
            self.completion()
        }
    }

    var font: UIFont = UIFont.systemFont(ofSize: 12)
    var contentEncoding: ContentEncoding?

    var loadTextButton: UIBarButtonItem?
    var statusLabel: UILabel?

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadTextButton = UIBarButtonItem(title: "Load text from clipboard", style: .Plain, target: self, action: #selector(loadTextFromClipboard))
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didPressAction))
        self.navigationItem.rightBarButtonItem = actionButton

        //create status bar
        self.statusLabel = UILabel()
        self.statusLabel?.font = UIFont.systemFont(ofSize: 12)
        let statusTextBarButtonItem = UIBarButtonItem(customView: self.statusLabel!)
        self.toolbarItems = [statusTextBarButtonItem]

        TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
        self.textView.text = TextCacheManager.shared.text
        self.contentEncoding = ContentEncoding.Zawgyi

        self.updateTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.text = TextCacheManager.shared.text
    }

    @objc func loadTextFromClipboard () {
        if let t = UIPasteboard.general.string {
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

    var activitySampleZawgyi: UIActivity {
        get {
            let activity = ActivityDoThis(withTitle: "Zawgyi text") {
                TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
                self.textView.text = TextCacheManager.shared.text
                self.contentEncoding = ContentEncoding.Zawgyi
                self.updateTitle()
            }
            return activity
        }
    }

    var activitySampleUnicode: UIActivity {
        get {
            let activity = ActivityDoThis(withTitle: "Unicode text") {
                TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
                self.textView.text = TextCacheManager.shared.text
                self.contentEncoding = ContentEncoding.Unicode
                self.updateTitle()
            }
            return activity
        }
    }

    var activityPasteTextFromClipboard: UIActivity {
        get {
            let act = ActivityDoThis(withTitle: "Paste text") {
                if let text = UIPasteboard.general.string {
                    TextCacheManager.shared.text = text
                    self.textView.text = text
                    self.contentEncoding = ContentEncoding.Unknown
                    self.updateTitle()
                }
            }
            return act
        }
    }

    func didPressAction () {
        let ctrl = UIActivityViewController(activityItems: [], applicationActivities: [self.activitySampleZawgyi, self.activitySampleUnicode, self.activityPasteTextFromClipboard])
        self.present(ctrl, animated: true, completion: nil)
    }

    func updateTitle() {
        self.title = "\(self.font.fontName), \(self.contentEncoding!)"
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
