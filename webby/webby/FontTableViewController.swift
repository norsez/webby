//
//  FontTableViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/8/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

struct CustomFont {
    static let ZAWGYI = "Zawgyi-One"
    static let MYANMAR2 = "Myanmar2"
    static let MYANMAR3 = "Myanmar3"
    static let MYANMAR_MN = "Myanmar MN"
    static let MENLO_REG = "Menlo-Regular"
    static let HELVETICA = "HelveticaNeue"
    static let PYIDAUNGSU = "Pyidaungsu"

    static var ALL_FONTS: [UIFont] {
        get {
            let names = [UIFont.systemFontOfSize(16).fontName,
                         CustomFont.ZAWGYI,
                         CustomFont.PYIDAUNGSU,
                         CustomFont.MYANMAR2,
                         CustomFont.MYANMAR3,
                         CustomFont.HELVETICA
                         ]

            return names.flatMap({ (name) -> UIFont? in
                return CustomFont.font(withName: name)
            })
        }
    }

    static func font(withName name: String) -> UIFont? {
        return UIFont(name: name, size: 16)
    }
}


class FontTableViewController: UITableViewController {


    let UNIT_TEST_ALPHABET = "\u{104E}"
    let CELL_ID = "CellID"
    var contentEncoding: ContentEncoding = .Zawgyi
    static let FONT_SIZE: CGFloat = 20
    let CellFonts = [UIFont.systemFontOfSize(FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.PYIDAUNGSU, size: FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.ZAWGYI, size: FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.HELVETICA, size: FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.MYANMAR2, size: FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.MYANMAR3, size: FontTableViewController.FONT_SIZE),
                     UIFont(name: CustomFont.MYANMAR_MN, size: FontTableViewController.FONT_SIZE)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        for family: String in UIFont.familyNames() {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family) {
                print("== \(names)")
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellFonts.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(self.CELL_ID, forIndexPath: indexPath)
        cell.textLabel?.text = self.UNIT_TEST_ALPHABET
        cell.textLabel?.textAlignment = .Center
        if let font = self.CellFonts[indexPath.row] {
            cell.textLabel?.font = font
            cell.detailTextLabel?.text = "\(font.fontName) size: \(font.pointSize)"
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = "error loading font."
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {


//
//        if segue.identifier == "showText" {
//
//            if let indexPath = self.tableView.indexPathForCell(cell),
//                let font = self.CellFonts[indexPath.row] {
//                let tdc = segue.destinationViewController as! TextDisplayViewController
//                tdc.font = font
//
//            } else {
//                assert(false, "invalid cell and indexPath")
//            }
//
//
        //        } else

        if segue.identifier == "showTestText" {
            if UIPasteboard.generalPasteboard().string == nil {
                TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
            }
        }

        if segue.identifier == "showAlphabetTable" {

            guard let cell = sender as? UITableViewCell else {
                assert(false, "sender must be a cell.")
            }

            if let indexPath = self.tableView.indexPathForCell(cell),
                let font = self.CellFonts[indexPath.row] {

                let atctrl = segue.destinationViewController as! AlphabetCollectionViewController
                atctrl.contentEncoding = self.contentEncoding
                atctrl.font = font
            }


        }
    }

}
