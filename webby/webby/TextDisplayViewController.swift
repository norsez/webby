//
//  TextDisplayViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/8/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class TextDisplayViewController: UIViewController {

  var font: UIFont = UIFont.systemFontOfSize(16)
  var text: String = ""


  var loadTextButton: UIBarButtonItem?

  @IBOutlet weak var textView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadTextButton = UIBarButtonItem(title: "Load text from clipboard", style: .Plain, target: self, action: #selector(loadTextFromClipboard))
    self.navigationItem.rightBarButtonItem = self.loadTextButton
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.textView.font = self.font
    self.textView.text = text
  }

  @objc func loadTextFromClipboard () {
    self.textView.text = UIPasteboard.generalPasteboard().string
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
