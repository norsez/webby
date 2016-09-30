//
//  TextConfigViewController.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 8/24/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class TextConfigViewController: UIViewController {

    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!

    var fontSizeValueDidChange: ((_ fontSize: CGFloat) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fontSizeDidChange(self)
    }

    @IBAction func fontSizeDidChange(_ sender: AnyObject) {
        self.fontSizeLabel.text = "Font size: \(self.fontSizeSlider.value)"
        if let c = fontSizeValueDidChange {
            c (CGFloat(Int(self.fontSizeSlider.value)))
        }
    }

}
