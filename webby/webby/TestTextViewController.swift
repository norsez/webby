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
    var heightCells: [CGFloat] = []

    private func computeCellSize() {

        self.heightCells = [CGFloat]()

        guard let text = TextCacheManager.shared.text  else {

            for _ in self.allFonts {
                self.heightCells.append(32)
            }
            return
        }

        for font in allFonts {
            let width = self.view.bounds.size.width * 0.45
            let height = self.view.bounds.size.height
            let rect = text.boundingRectWithSize(CGSizeMake(width, height), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: font.fontWithSize(self.fontSize)], context: nil)
            self.heightCells.append(max(rect.size.height, 50))
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        self.collectionView?.backgroundColor = UIColor.lightGrayColor()

        if TextCacheManager.shared.text == nil {
            TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
            self.title = "Unicode text"
        }
        self.computeCellSize()
        self.collectionView?.reloadData()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFonts.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let width = collectionView.bounds.size.width * 0.45
        let size = CGSizeMake(width, heightCells[indexPath.row])
        return size
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
            self.computeCellSize()
        }))
        ctrl.addAction(UIAlertAction(title: "Show sample Zawgyi", style: .Default, handler: { (action) in
            TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
            self.title = "Zawgyi text"
            self.computeCellSize()
            self.collectionView?.reloadData()
        }))
        ctrl.addAction(UIAlertAction(title: "Paste text from clipboard", style: .Default, handler: { (action) in
            if let text = UIPasteboard.generalPasteboard().string {
                TextCacheManager.shared.text = text
                self.title = "Unknown encoding"
                self.computeCellSize()
                self.collectionView?.reloadData()
            }
        }))
        self.presentViewController(ctrl, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueId = segue.identifier else {
            fatalError("segue id can't be nil")
        }

        if segueId == "showTextConfig" {
            guard let tov = segue.destinationViewController as? TextConfigViewController else {
                fatalError("expect TextConfigViewController here")
            }

            tov.fontSizeValueDidChange = { size in
                self.fontSize = size
                self.computeCellSize()
                self.collectionView?.reloadData()
            }
        }
    }

}
