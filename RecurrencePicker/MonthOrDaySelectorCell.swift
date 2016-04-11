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
            setNeedsDisplay()
            selectorView.reloadData()
            selectorView.collectionViewLayout = GridSelectorLayout(style: style)
        }
    }
    internal var bymonthday = [Int]()
    internal var bymonth = [Int]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        accessoryType = .None
        selectorView.clipsToBounds = false
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

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawGridLines()
    }
}

extension MonthOrDaySelectorCell {
    private func drawGridLines() {
        func removeAllGridLines() {
            guard let sublayers = layer.sublayers else {
                return
            }
            
            for sublayer in sublayers {
                if sublayer.name == Constant.gridLineName {
                    sublayer.removeFromSuperlayer()
                }
            }
        }

        let itemSize = GridSelectorLayout.itemSizeWithStyle(style, selectorViewWidth: frame.width)

        removeAllGridLines()
        switch style {
        case .Day:
            // draw vertical lines
            for index in 1...6 {
                let xPosition = CGFloat(index) * itemSize.width - Constant.gridLineWidth / 2
                let height = index < 4 ? (itemSize.height * CGFloat(5)) : (itemSize.height * CGFloat(4))
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding, width: Constant.gridLineWidth, height: height)
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.CGColor
                layer.addSublayer(line)
            }
            // draw horizontal lines
            for index in 0...5 {
                let yPosition = Constant.selectorVerticalPadding + CGFloat(index) * itemSize.height - Constant.gridLineWidth / 2
                let width = index < 5 ? frame.width : (itemSize.width * CGFloat(3) + Constant.gridLineWidth / 2)
                let lineFrame = CGRect(x: 0, y: yPosition, width: width, height: Constant.gridLineWidth)
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.CGColor
                layer.addSublayer(line)
            }
        case .Month:
            // draw vertical lines
            for index in 1...3 {
                let xPosition = CGFloat(index) * itemSize.width - Constant.gridLineWidth / 2
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding, width: Constant.gridLineWidth, height: (itemSize.height * CGFloat(3)))
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.CGColor
                layer.addSublayer(line)
            }
            // draw horizontal lines
            for index in 0...3 {
                let yPosition = Constant.selectorVerticalPadding + CGFloat(index) * itemSize.height - Constant.gridLineWidth / 2
                let lineFrame = CGRect(x: 0, y: yPosition, width: frame.width, height: Constant.gridLineWidth)
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.CGColor
                layer.addSublayer(line)
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

        cell.tintColor = tintColor
        switch style {
        case .Day:
            cell.textLabel.text = String(indexPath.row + 1)
        case .Month:
            cell.textLabel.text = Constant.shortMonthSymbols()[indexPath.row]
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? SelectorItemCell else {
            return
        }
        cell.setItemSelected(!cell.isItemSelected)
    }
}
