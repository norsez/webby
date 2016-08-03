//
//  TextCacheManager.swift
//  webby
//
//  Created by Norsez Orankijanan on 8/2/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class TextCacheManager: NSObject {

    var text: String?

    private var _unicodeSampleText: String?
    private var _zawgyiSampleText: String?

    var unicodeSampleText: String {
        get {

            if self._unicodeSampleText == nil {
                if let path = NSBundle.mainBundle().pathForResource("unicode-text", ofType: "text") {
                    do {
                        self._unicodeSampleText = try NSString(contentsOfFile:path, encoding: NSUTF8StringEncoding) as String
                    } catch {
                        self._unicodeSampleText = "\(error)"
                    }
                }
            }

            return self._unicodeSampleText!
        }
    }

    var zawgyiSampleText: String {
        get {

            if self._zawgyiSampleText == nil {
                if let path = NSBundle.mainBundle().pathForResource("zawgyi-text", ofType: "text") {
                    do {
                        self._zawgyiSampleText = try NSString(contentsOfFile:path, encoding: NSUTF8StringEncoding) as String
                    } catch {
                        self._zawgyiSampleText = "\(error)"
                    }
                }
            }

            return self._zawgyiSampleText!
        }
    }



    //#MARK: - singleton
    static let shared: TextCacheManager = {
        let instance = TextCacheManager()
        // setup code
        return instance
    }()

}
