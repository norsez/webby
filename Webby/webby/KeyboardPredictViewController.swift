//
//  KeyboardPredictViewController.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 8/22/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit
import QuartzCore

extension UIColor {
    var asTextColor: UIColor {
        get {
            var hue: CGFloat = 0
            self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            return UIColor(hue: hue, saturation: 1, brightness: 0.4, alpha: 1)
        }
    }
}

class KeyboardPredictViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var statusTextLabel: UILabel!

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Predict Burmese Encoding"
        self.statusTextLabel.text = "Paste some text below…"
        self.statusTextLabel.numberOfLines = 2
        
        self.textView.text = TextCacheManager.shared.unicodeSampleText

        let didPressPasteTextButton = UIBarButtonItem(title: "Paste Text", style: .Plain, target: self, action: #selector(didPressPasteText))
        self.navigationItem.rightBarButtonItem = didPressPasteTextButton
        self.updateResults()
    }

    @objc func didPressPasteText () {
        self.textView.text = UIPasteboard.generalPasteboard().string?.onlyBurmese
        self.updateResults()
    }

    func textViewDidChange(textView: UITextView) {
        self.updateResults()
    }

    private func updateResults () {
        
        self.textView.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, animations: {
            self.statusTextLabel.alpha = 0
        }) { (completed) in

            let result = EncodingPrediction.shared.predict(withText: self.textView!.text)
            var text = ""
            switch result.result {
            case .NOT_BURMESE:
                text = "Not Burmese"
                self.statusTextLabel.textColor = UIColor.redColor().asTextColor
            case .PROBABLY_UNICODE:
                text = "Probably Unicode Encoding"
                self.statusTextLabel.textColor = UIColor.greenColor().asTextColor
            case .PROBABLY_ZAWGYI:
                text = "Probably Zawgyi Encoding"
                self.statusTextLabel.textColor = UIColor.yellowColor().asTextColor
            }


            let nf = NSNumberFormatter()
            nf.numberStyle = .PercentStyle
            nf.minimumSignificantDigits = 2
            if let ratio = nf.stringFromNumber(result.nonZawgyiPerUnicodeRatio) {
                text.appendContentsOf("\nZawgyi/Unicode ratio = \(ratio)")
            }
            self.statusTextLabel.text = text

            UIView.animateWithDuration(0.5, animations: {
                self.statusTextLabel.alpha = 1
                }, completion: { (completed) in

            })

        }

    }

}
