//
//  GridSelectorLayout.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal class GridSelectorLayout: UICollectionViewLayout {
    private var style: MonthOrDaySelectorStyle = .Day
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()

    convenience init(style: MonthOrDaySelectorStyle) {
        self.init()
        self.style = style
    }

    override func prepareLayout() {
        super.prepareLayout()
        if !self.layoutAttributes.isEmpty {
            return
        }

        let itemSize = GridSelectorLayout.itemSizeWithStyle(style, selectorViewWidth: collectionView!.frame.width)
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        switch style {
        case .Day:
            for section in 0...4 {
                for row in 0...6 {
                    let itemNumber = section * 7 + row
                    if itemNumber < 31 {
                        let indexPath = NSIndexPath(forItem: itemNumber, inSection: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        let x = itemSize.width * CGFloat(row)
                        let y = itemSize.height * CGFloat(section)
                        attributes.frame = CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
                        layoutAttributes.append(attributes)
                    }
                }
            }
        case .Month:
            for section in 0...2 {
                for row in 0...3 {
                    let itemNumber = section * 4 + row
                    if itemNumber < 12 {
                        let indexPath = NSIndexPath(forItem: itemNumber, inSection: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        let x = itemSize.width * CGFloat(row)
                        let y = itemSize.height * CGFloat(section)
                        attributes.frame = CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
                        layoutAttributes.append(attributes)
                    }
                }
            }
        }
        self.layoutAttributes = layoutAttributes
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in self.layoutAttributes {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func collectionViewContentSize() -> CGSize {
        return collectionView!.frame.size
    }
}

extension GridSelectorLayout {
    internal static func itemSizeWithStyle(style: MonthOrDaySelectorStyle, selectorViewWidth: CGFloat) -> CGSize {
        switch style {
        case .Day:
            let width: CGFloat = selectorViewWidth / 7
            let height: CGFloat = width * 0.9
            return CGSize(width: width, height: height)
        case .Month:
            let width: CGFloat = selectorViewWidth / 4
            let height: CGFloat = 44
            return CGSize(width: width, height: height)
        }
    }
}
