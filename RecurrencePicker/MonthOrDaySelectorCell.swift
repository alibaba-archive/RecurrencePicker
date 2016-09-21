//
//  MonthOrDaySelectorCell.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal enum MonthOrDaySelectorStyle {
    case day
    case month
}

internal protocol MonthOrDaySelectorCellDelegate {
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, didSelectMonthday monthday: Int)
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, didDeselectMonthday monthday: Int)
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, shouldDeselectMonthday monthday: Int) -> Bool
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, didSelectMonth month: Int)
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, didDeselectMonth month: Int)
    func monthOrDaySelectorCell(_ cell: MonthOrDaySelectorCell, shouldDeselectMonth month: Int) -> Bool
}

internal class MonthOrDaySelectorCell: UITableViewCell {
    @IBOutlet weak var selectorView: UICollectionView!

    internal var delegate: MonthOrDaySelectorCellDelegate?
    internal var style: MonthOrDaySelectorStyle = .day {
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
        selectionStyle = .none
        accessoryType = .none
        selectorView.clipsToBounds = false
        let bundle = Bundle(identifier: "Teambition.RecurrencePicker") ?? Bundle.main
        selectorView.register(UINib(nibName: "SelectorItemCell", bundle: bundle), forCellWithReuseIdentifier: CellID.selectorItemCell)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            if NSStringFromClass(type(of: subview)) == "_UITableViewCellSeparatorView" {
                subview.removeFromSuperview()
            }
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGridLines()
    }
}

extension MonthOrDaySelectorCell {
    fileprivate func drawGridLines() {
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
        case .day:
            // draw vertical lines
            for index in 1...6 {
                let xPosition = CGFloat(index) * itemSize.width - Constant.gridLineWidth / 2
                let height = index < 4 ? (itemSize.height * CGFloat(5) + Constant.gridLineWidth) : (itemSize.height * CGFloat(4) + Constant.gridLineWidth)
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding - Constant.gridLineWidth / 2, width: Constant.gridLineWidth, height: height)
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.cgColor
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
                line.backgroundColor = Constant.gridLineColor.cgColor
                layer.addSublayer(line)
            }
        case .month:
            // draw vertical lines
            for index in 1...3 {
                let xPosition = CGFloat(index) * itemSize.width - Constant.gridLineWidth / 2
                let lineFrame = CGRect(x: xPosition, y: Constant.selectorVerticalPadding - Constant.gridLineWidth / 2, width: Constant.gridLineWidth, height: (itemSize.height * CGFloat(3) + Constant.gridLineWidth))
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.cgColor
                layer.addSublayer(line)
            }
            // draw horizontal lines
            for index in 0...3 {
                let yPosition = Constant.selectorVerticalPadding + CGFloat(index) * itemSize.height - Constant.gridLineWidth / 2
                let lineFrame = CGRect(x: 0, y: yPosition, width: frame.width, height: Constant.gridLineWidth)
                let line = CAShapeLayer()
                line.name = Constant.gridLineName
                line.frame = lineFrame
                line.backgroundColor = Constant.gridLineColor.cgColor
                layer.addSublayer(line)
            }
        }
    }
}

extension MonthOrDaySelectorCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return style == .day ? 31 : 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.selectorItemCell, for: indexPath) as! SelectorItemCell

        cell.tintColor = tintColor
        switch style {
        case .day:
            cell.textLabel.text = String((indexPath as NSIndexPath).row + 1)
            cell.setItemSelected(bymonthday.contains((indexPath as NSIndexPath).row + 1))
        case .month:
            cell.textLabel.text = Constant.shortMonthSymbols()[(indexPath as NSIndexPath).row]
            cell.setItemSelected(bymonth.contains((indexPath as NSIndexPath).row + 1))
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectorItemCell else {
            return
        }

        switch style {
        case .day:
            let monthday = (indexPath as NSIndexPath).row + 1
            if cell.isItemSelected {
                let shouldDeselectDay = delegate?.monthOrDaySelectorCell(self, shouldDeselectMonthday: monthday) ?? true
                if shouldDeselectDay {
                    cell.setItemSelected(false)
                    if let index = bymonthday.index(of: monthday) {
                        bymonthday.remove(at: index)
                    }
                    delegate?.monthOrDaySelectorCell(self, didDeselectMonthday: monthday)
                }
            } else {
                cell.setItemSelected(true)
                bymonthday.append(monthday)
                delegate?.monthOrDaySelectorCell(self, didSelectMonthday: monthday)
            }
        case .month:
            let month = (indexPath as NSIndexPath).row + 1
            if cell.isItemSelected {
                let shouldDeselectMonth = delegate?.monthOrDaySelectorCell(self, shouldDeselectMonth: month) ?? true
                if shouldDeselectMonth {
                    cell.setItemSelected(false)
                    if let index = bymonth.index(of: month) {
                        bymonth.remove(at: index)
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
