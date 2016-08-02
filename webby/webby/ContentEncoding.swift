//
//  ContentEncoding.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/11/16.
//  Copyright © 2016 norsez. All rights reserved.
//
import Foundation
enum ContentEncoding: String {
    case Unicode, Zawgyi

    func loadSampleContent() throws -> String {

        var filename = "zawgyicode-text"
        if self == .Unicode {
            filename = "unicode-text"
        }

        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "txt") else {
            assert(false, "can't find \(filename).txt")
        }
        let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return text as String
    }
}
