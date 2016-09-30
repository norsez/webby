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

    fileprivate func computeCellSize() {

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
            let rect = text.boundingRect(with: CGSize(width: width, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font.withSize(self.fontSize)], context: nil)
            self.heightCells.append(max(rect.size.height, 50))
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        self.collectionView?.backgroundColor = UIColor.lightGray

        if TextCacheManager.shared.text == nil {
            TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
            self.title = "Unicode text"
        }
        self.computeCellSize()
        self.collectionView?.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFonts.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.size.width * 0.45
        let size = CGSize(width: width, height: heightCells[(indexPath as NSIndexPath).row])
        return size
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath) as! TestTextCell
        let font = self.allFonts[(indexPath as NSIndexPath).item]

        cell.topicLabel.text = font.fontName
        if  let text = TextCacheManager.shared.text {
            cell.testTextLabel.attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font.withSize(fontSize)])
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let c = cell as? TestTextCell {
            c.contentView.backgroundColor = UIColor.white
        }

    }

    @IBAction func showTextOptions () {
        let ctrl = UIAlertController(title: "Display text", message: nil, preferredStyle: .actionSheet)

        ctrl.addAction(UIAlertAction(title: "Show sample Unicode", style: .default, handler: { (action) in
            TextCacheManager.shared.text = TextCacheManager.shared.unicodeSampleText
            self.title = "Unicode text"
            self.computeCellSize()
        }))
        ctrl.addAction(UIAlertAction(title: "Show sample Zawgyi", style: .default, handler: { (action) in
            TextCacheManager.shared.text = TextCacheManager.shared.zawgyiSampleText
            self.title = "Zawgyi text"
            self.computeCellSize()
            self.collectionView?.reloadData()
        }))
        ctrl.addAction(UIAlertAction(title: "Paste text from clipboard", style: .default, handler: { (action) in
            if let text = UIPasteboard.general.string {
                TextCacheManager.shared.text = text
                self.title = "Unknown encoding"
                self.computeCellSize()
                self.collectionView?.reloadData()
            }
        }))
        self.present(ctrl, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            fatalError("segue id can't be nil")
        }

        if segueId == "showTextConfig" {
            guard let tov = segue.destination as? TextConfigViewController else {
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
