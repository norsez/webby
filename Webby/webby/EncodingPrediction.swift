//
//  EncodingPrediction.swift
//  ZawgyiViewer
//
//  Created by Norsez Orankijanan on 8/22/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

extension String {
    var onlyBurmese: String {
        get {
            var results = ""
            self.unicodeScalars.forEach { (us) in
                if EncodingPrediction.BURMESE_RANGE ~= Int(us.value) {
                    results.append(Character(us))
                }
            }
            return results
        }
    }

    var onlyNonZawgyiChars: String {
        get {
            var results = ""
            self.unicodeScalars.forEach { (us) in
                if EncodingPrediction.CHARS_NOT_IN_ZAWGYI.contains(Int(us.value)) {
                  results.append(Character(us))
                }
            }
            return results
        }
    }
}

class EncodingPrediction: NSObject {

    static let CHARS_NOT_IN_ZAWGYI = [0x1022, 0x1028, 0x1035, 0x103E, 0x103F,
                               0x1050, 0x1052, 0x1053, 0x1054, 0x1055, 0x1056, 0x1057, 0x1058, 0x1059, 0x1051,
                               0x105B, 0x105C, 0x105D, 0x105E, 0x105F,
                               0x1098, 0x1099, 0x109E, 0x109F
                               ]
    static let BURMESE_RANGE = 0x1000...0x109F

    enum Result {
        case PROBABLY_ZAWGYI, PROBABLY_UNICODE, NOT_BURMESE
    }

    var nonZawgyiTotalRatio: Double {
        get {
            return Double(EncodingPrediction.CHARS_NOT_IN_ZAWGYI.count)/Double(EncodingPrediction.BURMESE_RANGE.count)
        }
    }

    func predict(withText text: String) -> (result: Result, nonZawgyiPerUnicodeRatio: Double) {
        let stringWithBurmese = text.onlyBurmese
        if stringWithBurmese.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            return (result: .NOT_BURMESE, 0)
        }

        let nonZawgyiChars = stringWithBurmese.onlyNonZawgyiChars

        let tellingRatio = Double (nonZawgyiChars.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) / Double( stringWithBurmese.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        if nonZawgyiChars.unicodeScalars.count > 0 {
            return (result: .PROBABLY_UNICODE, nonZawgyiPerUnicodeRatio: tellingRatio)
        } else {
            return (result: .PROBABLY_ZAWGYI, nonZawgyiPerUnicodeRatio: tellingRatio)
        }
    }


    //#MARK: - singleton
    static let shared: EncodingPrediction = {
        let instance = EncodingPrediction()
        // setup code
        return instance
    }()

}
