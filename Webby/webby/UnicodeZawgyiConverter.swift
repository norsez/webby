//
//  UnicodeZawgyiConverter.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 8/24/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

class UnicodeZawgyiConverter: NSObject {

    func convertToZawgyi(withText text: String) -> String {
        return Rabbit.uni2zg(text)
    }

    func convertToUnicode(withText text: String) -> String {
        return Rabbit.zg2uni(text)
    }

    //#MARK: - singleton
    static let shared: UnicodeZawgyiConverter = {
        let instance = UnicodeZawgyiConverter()
        // setup code
        return instance
    }()
}
