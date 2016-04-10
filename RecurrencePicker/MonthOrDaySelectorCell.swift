//
//  MonthOrDaySelectorCell.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal enum MonthOrDaySelectorStyle {
    case Day
    case Month
}

internal class MonthOrDaySelectorCell: UITableViewCell {
    @IBOutlet weak var selectorView: UICollectionView!

    internal var style: MonthOrDaySelectorStyle = .Day {
        didSet {
            selectorView.reloadData()
        }
    }
    internal var bymonthday = [Int]()
    internal var bymonth = [Int]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        accessoryType = .None
        let bundle = NSBundle(identifier: "Teambition.RecurrencePicker") ?? NSBundle.mainBundle()
        selectorView.registerNib(UINib(nibName: "SelectorItemCell", bundle: bundle), forCellWithReuseIdentifier: CellID.selectorItemCell)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            if NSStringFromClass(subview.dynamicType) == "_UITableViewCellSeparatorView" {
                subview.removeFromSuperview()
            }
        }
    }
}

extension MonthOrDaySelectorCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return style == .Day ? 31 : 12
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID.selectorItemCell, forIndexPath: indexPath) as! SelectorItemCell

        switch style {
        case .Day:
            cell.textLabel.text = String(indexPath.row + 1)
        case .Month:
            cell.textLabel.text = Constant.shortMonthSymbols()[indexPath.row]
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
}

extension MonthOrDaySelectorCell {
    internal static func itemSizeWithStyle(style: MonthOrDaySelectorStyle, selectorViewWidth: CGFloat) -> CGSize {
        switch style {
        case .Day:
            let width: CGFloat = selectorViewWidth / 7
            let height: CGFloat = width * 0.9
            return CGSize(width: floor(width), height: floor(height))
        case .Month:
            let width: CGFloat = selectorViewWidth / 4
            let height: CGFloat = 44
            return CGSize(width: floor(width), height: floor(height))
        }
    }
}

extension MonthOrDaySelectorCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return MonthOrDaySelectorCell.itemSizeWithStyle(style, selectorViewWidth: frame.width)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
