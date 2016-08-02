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


    //#MARK: - singleton
    static let shared: TextCacheManager = {
        let instance = TextCacheManager()
        // setup code
        return instance
    }()

}
