//
//  TextCacheManager.swift
//  webby
//
//  Created by Norsez Orankijanan on 8/2/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit


struct AlphabetTile {
    let char: String
    let unicodeNumber: Int
}

class TextCacheManager: NSObject {


    var text: String?

    private var _unicodeSampleText: String?
    private var _zawgyiSampleText: String?

    var unicodeSampleText: String {
        get {

            if self._unicodeSampleText == nil {
                if let path = NSBundle.mainBundle().pathForResource("unicode-text", ofType: "txt") {
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
                if let path = NSBundle.mainBundle().pathForResource("zawgyicode-text", ofType: "txt") {
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

    private var _tiles = [AlphabetTile]()
    private let FIRST_LETTER = 0x1000
    private let NUM_LETTERS = 159

    var alphabetTiles: [AlphabetTile] {
        get {

            if self._tiles.count == 0 {

                for index in 0 ... 9 {
                    self._tiles.append(AlphabetTile(char: "\(index)", unicodeNumber: index))
                }
                for index in FIRST_LETTER ... (FIRST_LETTER + NUM_LETTERS) {
                    self._tiles.append(AlphabetTile(char: "\(UnicodeScalar(index))", unicodeNumber: index))
                }
            }

            return self._tiles
        }
    }


    //#MARK: - singleton
    static let shared: TextCacheManager = {
        let instance = TextCacheManager()
        // setup code
        return instance
    }()

}
