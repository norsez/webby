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


    let LETTERS_PER_ROWS = 5
    var contentEncoding: ContentEncoding?
    private let FONT_SIZE: CGFloat = 28
    var font: UIFont = UIFont.systemFontOfSize(48)



    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()

        let width = self.view.bounds.size.width / CGFloat(LETTERS_PER_ROWS)
        flowLayout.itemSize = CGSizeMake(width, width + 21)
        self.collectionView!.collectionViewLayout = flowLayout
        self.title = "\(self.font.fontName)"

    }


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TextCacheManager.shared.alphabetTiles.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlphabetCell
        let atile = TextCacheManager.shared.alphabetTiles[indexPath.row]
        cell.textLabel.text = atile.char
        cell.textLabel.font = self.font.fontWithSize(self.FONT_SIZE)
        cell.detailLabel.text = "\(atile.unicodeNumber)"
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//
        let atile = TextCacheManager.shared.alphabetTiles[indexPath.row]
        UIPasteboard.generalPasteboard().string = atile.char
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
