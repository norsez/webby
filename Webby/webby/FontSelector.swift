//
//  FontSelector.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 9/30/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class FontSelector: NSObject {
    
    
    func showFontSelector(inViewController: UIViewController, completion:@escaping (_ selectedFont: UIFont?)->Void) {
        
        let ctrl = UIAlertController(title: "Select Font", message: nil, preferredStyle: .actionSheet)
        for fn in CustomFont.ALL_FONTS {
            ctrl.addAction(UIAlertAction(title: fn.familyName, style: .default, handler: { (ua) in
                completion(fn)
            }))
        }
        
        inViewController.present(ctrl, animated: true, completion: nil)
    }
    
    static let shared: FontSelector = {
        let instance = FontSelector()
        // setup code
        return instance
    }()

}
