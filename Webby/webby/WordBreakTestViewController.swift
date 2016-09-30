//
//  WordBreakTestViewController.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 9/30/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class WordBreakTestViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressFont(_ sender: AnyObject) {
        
        FontSelector.shared.showFontSelector(inViewController: self) { (fn) in
            if let font = fn {
                self.textView.font = UIFont(name: font.familyName, size: 120)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
