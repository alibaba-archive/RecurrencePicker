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

internal protocol MonthOrDaySelectorCellDelegate {
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didSelectMonthday monthday: Int)
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didDeselectMonthday monthday: Int)
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, shouldDeselectMonthday monthday: Int) -> Bool
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didSelectMonth month: Int)
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didDeselectMonth month: Int)
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, shouldDeselectMonth month: Int) -> Bool
}

internal class MonthOrDaySelectorCell: UITableViewCell {
    @IBOutlet weak var selectorView: UICollectionView!

    internal var delegate: MonthOrDaySelectorCellDelegate?
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
                let height = index < 4 ? (itemSize.height * CGFloat(5) + Constant.gridLineWidth) : (itemSize.height * CGFloat(4) + Constant.gridLineWidth)
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding - Constant.gridLineWidth / 2, width: Constant.gridLineWidth, height: height)
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
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding - Constant.gridLineWidth / 2, width: Constant.gridLineWidth, height: (itemSize.height * CGFloat(3) + Constant.gridLineWidth))
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
            cell.setItemSelected(bymonthday.contains(indexPath.row + 1))
        case .Month:
            cell.textLabel.text = Constant.shortMonthSymbols()[indexPath.row]
            cell.setItemSelected(bymonth.contains(indexPath.row + 1))
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? SelectorItemCell else {
            return
        }

        switch style {
        case .Day:
            let monthday = indexPath.row + 1
            if cell.isItemSelected {
                let shouldDeselectDay = delegate?.monthOrDaySelectorCell(self, shouldDeselectMonthday: monthday) ?? true
                if shouldDeselectDay {
                    cell.setItemSelected(false)
                    if let index = bymonthday.indexOf(monthday) {
                        bymonthday.removeAtIndex(index)
                    }
                    delegate?.monthOrDaySelectorCell(self, didDeselectMonthday: monthday)
                }
            } else {
                cell.setItemSelected(true)
                bymonthday.append(monthday)
                delegate?.monthOrDaySelectorCell(self, didSelectMonthday: monthday)
            }
        case .Month:
            let month = indexPath.row + 1
            if cell.isItemSelected {
                let shouldDeselectMonth = delegate?.monthOrDaySelectorCell(self, shouldDeselectMonth: month) ?? true
                if shouldDeselectMonth {
                    cell.setItemSelected(false)
                    if let index = bymonth.indexOf(month) {
                        bymonth.removeAtIndex(index)
                    }
                    delegate?.monthOrDaySelectorCell(self, didDeselectMonth: month)
                }
            } else {
                cell.setItemSelected(true)
                bymonth.append(month)
                delegate?.monthOrDaySelectorCell(self, didSelectMonth: month)
            }
        }
    }
}
