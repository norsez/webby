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


    @IBAction func didPressZawgyi2Unicode(_ sender: AnyObject) {

        self.textView.text = UnicodeZawgyiConverter.shared.convertToUnicode(withText: self.textView.text)
        self.textView.font = CustomFont.font(withName: CustomFont.PYIDAUNGSU)
        self.statusTextLabel.text = "converted to Unicode (fnt: Pyidaungsu)"

    }
    @IBAction func didPressUnicode2Zawgyi(_ sender: AnyObject) {
        self.textView.text = UnicodeZawgyiConverter.shared.convertToZawgyi(withText: self.textView.text)
        self.textView.font = CustomFont.font(withName: CustomFont.ZAWGYI)
        self.statusTextLabel.text = "converted to Zawgyi (fnt: Zawgyi-One)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Predict Burmese Encoding"
        self.statusTextLabel.text = "Paste some text below…"
        self.statusTextLabel.numberOfLines = 2

        self.textView.text = TextCacheManager.shared.unicodeSampleText

        let didPressPasteTextButton = UIBarButtonItem(title: "Paste Text", style: .plain, target: self, action: #selector(didPressPasteText))
        self.navigationItem.rightBarButtonItem = didPressPasteTextButton
        self.updateResults()
    }

    @objc func didPressPasteText () {
        self.textView.text = UIPasteboard.general.string?.onlyBurmese
        self.updateResults()
    }

    func textViewDidChange(_ textView: UITextView) {
        self.updateResults()
    }

    fileprivate func updateResults () {

        self.textView.resignFirstResponder()

        UIView.animate(withDuration: 0.5, animations: {
            self.statusTextLabel.alpha = 0
        }, completion: { (completed) in

            let result = EncodingPrediction.shared.predict(withText: self.textView!.text)
            var text = ""
            switch result.result {
            case .not_BURMESE:
                text = "Not Burmese"
                self.statusTextLabel.textColor = UIColor.red.asTextColor
                self.textView.font = UIFont.systemFont(ofSize: 18)
            case .probably_UNICODE:
                text = "Probably Unicode Encoding"
                self.statusTextLabel.textColor = UIColor.green.asTextColor
                self.textView.font = CustomFont.font(withName: CustomFont.PYIDAUNGSU)
            case .probably_ZAWGYI:
                text = "Probably Zawgyi Encoding"
                self.statusTextLabel.textColor = UIColor.yellow.asTextColor
                self.textView.font = CustomFont.font(withName: CustomFont.ZAWGYI)
            }

            text.append( " # Burmese chars: \(result.statistics.numBurmeseChars), # non-Zawgyi: \(result.statistics.numNonZawgyi)/\(EncodingPrediction.CHARS_NOT_IN_ZAWGYI.count)")

            self.statusTextLabel.text = text

            UIView.animate(withDuration: 0.5, animations: {
                self.statusTextLabel.alpha = 1
                }, completion: { (completed) in

            })

        }) 

    }

}
