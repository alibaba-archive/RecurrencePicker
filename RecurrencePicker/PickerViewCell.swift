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
    case frequency
    case interval
}

internal protocol PickerViewCellDelegate: class {
    func pickerViewCell(_ cell: PickerViewCell, didSelectFrequency frequency: RecurrenceFrequency)
    func pickerViewCell(_ cell: PickerViewCell, didSelectInterval interval: Int)
}

internal class PickerViewCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!

    internal weak var delegate: PickerViewCellDelegate?
    internal var style: PickerViewCellStyle = .frequency {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    internal var frequency: RecurrenceFrequency = .daily {
        didSet {
            if style == .frequency {
                if pickerView.selectedRow(inComponent: 0) != frequency.number {
                    pickerView.selectRow(frequency.number, inComponent: 0, animated: false)
                }
            }
        }
    }
    internal var interval = 1 {
        didSet {
            if style == .interval {
                if pickerView.selectedRow(inComponent: 0) != interval - 1 {
                    pickerView.selectRow(interval - 1, inComponent: 0, animated: false)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .none
    }
}

extension PickerViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return style == .frequency ? 1 : 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch style {
        case .frequency:
            return Constant.frequencies.count
        case .interval:
            if component == 0 {
                return Constant.pickerMaxRowCount
            } else {
                return 1
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch style {
        case .frequency:
            return Constant.frequencyStrings()[row]
        case .interval:
            if component == 0 {
                return String(row + 1)
            } else {
                let unit = interval == 1 ? Constant.unitStrings()[frequency.number] : Constant.pluralUnitStrings()[frequency.number]
                return unit.lowercased()
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constant.pickerRowHeight
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch style {
        case .frequency:
            frequency = Constant.frequencies[row]
            delegate?.pickerViewCell(self, didSelectFrequency: frequency)
        case .interval:
            if component == 0 {
                interval = row + 1
                pickerView.reloadComponent(1)
                delegate?.pickerViewCell(self, didSelectInterval: interval)
            }
        }
    }
}
