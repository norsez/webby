//
//  AlphabetCollectionViewController.swift
//  webby
//
//  Created by Norsez Orankijanan on 7/11/16.
//  Copyright © 2016 norsez. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellId"


class AlphabetCollectionViewController: UICollectionViewController {


    let LETTERS_PER_ROWS = 6
    var contentEncoding: ContentEncoding?
    fileprivate let FONT_SIZE: CGFloat = 28
    var font: UIFont = UIFont.systemFont(ofSize: 36)



    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()

        let width = self.view.bounds.size.width / CGFloat(LETTERS_PER_ROWS)
        flowLayout.itemSize = CGSize(width: width, height: width + 21)
        self.collectionView!.collectionViewLayout = flowLayout
        self.title = "\(self.font.fontName)"

    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TextCacheManager.shared.alphabetTiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlphabetCell
        let atile = TextCacheManager.shared.alphabetTiles[(indexPath as NSIndexPath).row]
        cell.textLabel.text = atile.char
        cell.textLabel.font = self.font.withSize(self.FONT_SIZE)
        cell.detailLabel.text = "\(atile.unicodeNumber)\nU+\(String(format:"%02X", Int(atile.unicodeNumber)).uppercased())"
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        UIPasteboard.generalPasteboard().string =
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

    }
    */

}
