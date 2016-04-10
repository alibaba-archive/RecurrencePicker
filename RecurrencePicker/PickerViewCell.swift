//
//  PickerViewCell.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import RRuleSwift

internal enum PickerViewCellStyle {
    case Frequency
    case Interval
}

internal protocol PickerViewCellDelegate {
    func pickerViewCell(cell: PickerViewCell, didSelectFrequency frequency: RecurrenceFrequency)
    func pickerViewCell(cell: PickerViewCell, didSelectInterval interval: Int)
}

internal class PickerViewCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!

    internal var delegate: PickerViewCellDelegate?
    internal var style: PickerViewCellStyle = .Frequency {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    internal var frequency: RecurrenceFrequency = .Daily {
        didSet {
            if style == .Frequency {
                if pickerView.selectedRowInComponent(0) != frequency.number {
                    pickerView.selectRow(frequency.number, inComponent: 0, animated: false)
                }
            }
        }
    }
    internal var interval = 1 {
        didSet {
            if style == .Interval {
                if pickerView.selectedRowInComponent(0) != interval - 1 {
                    pickerView.selectRow(interval - 1, inComponent: 0, animated: false)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        accessoryType = .None
    }
}

extension PickerViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return style == .Frequency ? 1 : 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch style {
        case .Frequency:
            return Constant.frequencies.count
        case .Interval:
            if component == 0 {
                return Constant.pickerMaxRowCount
            } else {
                return 1
            }
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch style {
        case .Frequency:
            return Constant.frequencyStrings()[row]
        case .Interval:
            if component == 0 {
                return String(row + 1)
            } else {
                let unit = interval == 1 ? Constant.unitStrings()[frequency.number] : Constant.pluralUnitStrings()[frequency.number]
                return unit.lowercaseString
            }
        }
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constant.pickerRowHeight
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch style {
        case .Frequency:
            frequency = Constant.frequencies[row]
            delegate?.pickerViewCell(self, didSelectFrequency: frequency)
        case .Interval:
            if component == 0 {
                interval = row + 1
                pickerView.reloadComponent(1)
                delegate?.pickerViewCell(self, didSelectInterval: interval)
            }
        }
    }
}
