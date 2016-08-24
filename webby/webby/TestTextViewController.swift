//
//  TestTextViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 8/3/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit
import QuartzCore
class TestTextCell: UICollectionViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var testTextLabel: UILabel!

}

class TestTextViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let CELLID = "TestTextCell"
    let allFonts = CustomFont.ALL_FONTS
    let MARGIN_TOP: CGFloat = 32
    var fontSize: CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        self.collectionView?.backgroundColor = UIColor.lightGrayColor()

        if TextCacheManager.shared.text == nil {
            TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
            self.title = "Unicode text"
            self.collectionView?.reloadData()
        }
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFonts.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let width = ((self.collectionView?.bounds.width)! * 0.5 ) - (8 * 2)
        let font = self.allFonts[indexPath.item]

        if let text = TextCacheManager.shared.text {
            let attr = [NSFontAttributeName: font.fontWithSize(fontSize)]
            let rect = text.boundingRectWithSize(CGSizeMake(width, 99999), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: attr, context: nil)
            return CGSizeMake(width, min(max(31, rect.size.height), 278))
        } else {
            return CGSizeMake(width, 31)
        }

    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELLID, forIndexPath: indexPath) as! TestTextCell
        let font = self.allFonts[indexPath.item]

        cell.topicLabel.text = font.fontName
        if  let text = TextCacheManager.shared.text {
            cell.testTextLabel.attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font.fontWithSize(fontSize)])
        }

        return cell
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let c = cell as? TestTextCell {
            c.contentView.backgroundColor = UIColor.whiteColor()
        }

    }

    @IBAction func showTextOptions () {
        let ctrl = UIAlertController(title: "Display text", message: nil, preferredStyle: .ActionSheet)

        ctrl.addAction(UIAlertAction(title: "Show sample Unicode", style: .Default, handler: { (action) in
            TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
            self.title = "Unicode text"
            self.collectionView?.reloadData()
        }))
        ctrl.addAction(UIAlertAction(title: "Show sample Zawgyi", style: .Default, handler: { (action) in
            TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
            self.title = "Zawgyi text"
            self.collectionView?.reloadData()
        }))
        ctrl.addAction(UIAlertAction(title: "Paste text from clipboard", style: .Default, handler: { (action) in
            if let text = UIPasteboard.generalPasteboard().string {
                TextCacheManager.shared.text = text
                self.title = "Unknown encoding"
                self.collectionView?.reloadData()
            }
        }))
        self.presentViewController(ctrl, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueId = segue.identifier else {
            fatalError("segue id can't be nil")
        }

        if segueId == "showTextOptions" {
            guard let tov = segue.destinationViewController as? TextConfigViewController else {
                fatalError("expect TextConfigViewController here")
            }

            tov.fontSizeValueDidChange = { size in
                self.fontSize = size
                self.collectionView?.reloadData()
            }
        }
    }

}
