//
//  CustomRecurrenceViewController.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import EventKit
import RRuleSwift

internal protocol CustomRecurrenceViewControllerDelegate {
    func customRecurrenceViewController(controller: CustomRecurrenceViewController, didPickRecurrence recurrenceRule: RecurrenceRule)

}

internal class CustomRecurrenceViewController: UITableViewController {
    internal var delegate: CustomRecurrenceViewControllerDelegate?
    internal var occurrenceDate: NSDate!
    internal var tintColor: UIColor!
    internal var recurrenceRule: RecurrenceRule!
    internal var backgroundColor: UIColor?
    internal var separatorColor: UIColor?

    private var isShowingPickerView = false
    private var pickerViewStyle: PickerViewCellStyle = .Frequency
    private var isShowingFrequencyPicker: Bool {
        return isShowingPickerView && pickerViewStyle == .Frequency
    }
    private var isShowingIntervalPicker: Bool {
        return isShowingPickerView && pickerViewStyle == .Interval
    }
    private var frequencyCell: UITableViewCell? {
        return tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    }
    private var intervalCell: UITableViewCell? {
        return isShowingFrequencyPicker ? tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) : tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            // navigation is popped
            delegate?.customRecurrenceViewController(self, didPickRecurrence: recurrenceRule)
        }
    }
}

extension CustomRecurrenceViewController {
    // MARK: - Table view helper
    private func isPickerViewCell(indexPath: NSIndexPath) -> Bool {
        guard indexPath.section == 0 && isShowingPickerView else {
            return false
        }
        return pickerViewStyle == .Frequency ? indexPath.row == 1 : indexPath.row == 2
    }

    private func isSelectorViewCell(indexPath: NSIndexPath) -> Bool {
        guard recurrenceRule.frequency == .Monthly || recurrenceRule.frequency == .Yearly else {
            return false
        }
        return indexPath == NSIndexPath(forRow: 0, inSection: 1)
    }

    private func unfoldPickerView() {
        switch pickerViewStyle {
        case .Frequency:
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
        case .Interval:
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Fade)
        }
    }

    private func foldPickerView() {
        switch pickerViewStyle {
        case .Frequency:
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
        case .Interval:
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Fade)
        }
    }

    private func updateSelectorSection(newFrequency: RecurrenceFrequency) {
        tableView.beginUpdates()
        switch newFrequency {
        case .Daily:
            if tableView.numberOfSections == 2 {
                tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            }
        case .Weekly, .Monthly, .Yearly:
            if tableView.numberOfSections == 1 {
                tableView.insertSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            } else {
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            }
        default:
            break
        }
        tableView.endUpdates()
    }

    private func unitStringForIntervalCell() -> String {
        if recurrenceRule.interval == 1 {
            return Constant.unitStrings()[recurrenceRule.frequency.number]
        }
        return String(recurrenceRule.interval) + " " + Constant.pluralUnitStrings()[recurrenceRule.frequency.number]
    }

    private func updateDetailTextColor() {
        frequencyCell?.detailTextLabel?.textColor = isShowingFrequencyPicker ? tintColor : Constant.detailTextColor
        intervalCell?.detailTextLabel?.textColor = isShowingIntervalPicker ? tintColor : Constant.detailTextColor
    }

    private func updateFrequencyCellText() {
        frequencyCell?.detailTextLabel?.text = Constant.frequencyStrings()[recurrenceRule.frequency.number]
    }

    private func updateIntervalCellText() {
        intervalCell?.detailTextLabel?.text = unitStringForIntervalCell()
    }

    private func updateRecurrenceRuleText() {
        let footerView = tableView.footerViewForSection(0)

        tableView.beginUpdates()
        footerView?.textLabel?.text = recurrenceRule.toText(occurrenceDate: occurrenceDate)
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
}

extension CustomRecurrenceViewController {
    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if recurrenceRule.frequency == .Daily {
            return 1
        }
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isShowingPickerView ? 3 : 2
        } else {
            switch recurrenceRule.frequency {
            case .Weekly: return Constant.weekdaySymbols().count
            case .Monthly, .Yearly: return 1
            default: return 0
            }
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isPickerViewCell(indexPath) {
            return Constant.pickerViewCellHeight
        } else if isSelectorViewCell(indexPath) {
            let style: MonthOrDaySelectorStyle = recurrenceRule.frequency == .Monthly ? .Day : .Month
            let itemHeight = GridSelectorLayout.itemSizeWithStyle(style, selectorViewWidth: tableView.frame.width).height
            let itemCount: CGFloat = style == .Day ? 5 : 3
            return ceil(itemHeight * itemCount) + Constant.selectorVerticalPadding * CGFloat(2)
        }
        return Constant.defaultRowHeight
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return recurrenceRule.toText(occurrenceDate: occurrenceDate)
        }
        return nil
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isPickerViewCell(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.pickerViewCell, forIndexPath: indexPath) as! PickerViewCell
            cell.delegate = self

            cell.style = pickerViewStyle
            cell.frequency = recurrenceRule.frequency
            cell.interval = recurrenceRule.interval

            return cell
        } else if isSelectorViewCell(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.monthOrDaySelectorCell, forIndexPath: indexPath) as! MonthOrDaySelectorCell
            cell.delegate = self

            cell.tintColor = tintColor
            cell.style = recurrenceRule.frequency == .Monthly ? .Day : .Month
            cell.bymonthday = recurrenceRule.bymonthday
            cell.bymonth = recurrenceRule.bymonth

            return cell
        } else if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier(CellID.customRecurrenceViewCell)
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: CellID.customRecurrenceViewCell)
            }
            cell?.accessoryType = .None

            if indexPath.row == 0 {
                cell?.textLabel?.text = LocalizedString(key: "CustomRecurrenceViewController.textLabel.frequency")
                cell?.detailTextLabel?.text = Constant.frequencyStrings()[recurrenceRule.frequency.number]
                cell?.detailTextLabel?.textColor = isShowingFrequencyPicker ? tintColor : Constant.detailTextColor
            } else {
                cell?.textLabel?.text = LocalizedString(key: "CustomRecurrenceViewController.textLabel.interval")
                cell?.detailTextLabel?.text = unitStringForIntervalCell()
                cell?.detailTextLabel?.textColor = isShowingIntervalPicker ? tintColor : Constant.detailTextColor
            }

            return cell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(CellID.commonCell)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: CellID.commonCell)
            }

            cell?.textLabel?.text = Constant.weekdaySymbols()[indexPath.row]
            if recurrenceRule.byweekday.contains(Constant.weekdays[indexPath.row]) {
                cell?.accessoryType = .Checkmark
            } else {
                cell?.accessoryType = .None
            }

            return cell!
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard !isPickerViewCell(indexPath) else {
            return
        }
        guard !isSelectorViewCell(indexPath) else {
            return
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if isShowingFrequencyPicker {
                    tableView.beginUpdates()
                    isShowingPickerView = false
                    foldPickerView()
                    tableView.endUpdates()
                } else {
                    tableView.beginUpdates()
                    if isShowingIntervalPicker {
                        foldPickerView()
                    }
                    isShowingPickerView = true
                    pickerViewStyle = .Frequency
                    unfoldPickerView()
                    tableView.endUpdates()
                }
                updateDetailTextColor()
            } else {
                if isShowingIntervalPicker {
                    tableView.beginUpdates()
                    isShowingPickerView = false
                    foldPickerView()
                    tableView.endUpdates()
                } else {
                    tableView.beginUpdates()
                    if isShowingFrequencyPicker {
                        foldPickerView()
                    }
                    isShowingPickerView = true
                    pickerViewStyle = .Interval
                    unfoldPickerView()
                    tableView.endUpdates()
                }
                updateDetailTextColor()
            }
        } else if indexPath.section == 1 {
            if isShowingPickerView {
                tableView.beginUpdates()
                isShowingPickerView = false
                foldPickerView()
                tableView.endUpdates()
                updateDetailTextColor()
            }

            let weekday = Constant.weekdays[indexPath.row]
            if recurrenceRule.byweekday.contains(weekday) {
                if recurrenceRule.byweekday == [weekday] {
                    return
                }
                let index = recurrenceRule.byweekday.indexOf(weekday)!
                recurrenceRule.byweekday.removeAtIndex(index)
                cell?.accessoryType = .None
                updateRecurrenceRuleText()
            } else {
                recurrenceRule.byweekday.append(weekday)
                cell?.accessoryType = .Checkmark
                updateRecurrenceRuleText()
            }
        }
    }
}

extension CustomRecurrenceViewController {
    // MARK: - Helper
    private func commonInit() {
        navigationItem.title = LocalizedString(key: "RecurrencePicker.textLabel.custom")
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        if let backgroundColor = backgroundColor {
            tableView.backgroundColor = backgroundColor
        }
        if let separatorColor = separatorColor {
            tableView.separatorColor = separatorColor
        }

        let bundle = NSBundle(identifier: "Teambition.RecurrencePicker") ?? NSBundle.mainBundle()
        tableView.registerNib(UINib(nibName: "PickerViewCell", bundle: bundle), forCellReuseIdentifier: CellID.pickerViewCell)
        tableView.registerNib(UINib(nibName: "MonthOrDaySelectorCell", bundle: bundle), forCellReuseIdentifier: CellID.monthOrDaySelectorCell)
    }
}

extension CustomRecurrenceViewController: PickerViewCellDelegate {
    func pickerViewCell(cell: PickerViewCell, didSelectFrequency frequency: RecurrenceFrequency) {
        recurrenceRule.frequency = frequency

        updateFrequencyCellText()
        updateIntervalCellText()
        updateSelectorSection(frequency)
        updateRecurrenceRuleText()
    }

    func pickerViewCell(cell: PickerViewCell, didSelectInterval interval: Int) {
        recurrenceRule.interval = interval

        updateIntervalCellText()
        updateRecurrenceRuleText()
    }
}

extension CustomRecurrenceViewController: MonthOrDaySelectorCellDelegate {
    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didSelectMonthday monthday: Int) {
        if isShowingPickerView {
            tableView.beginUpdates()
            isShowingPickerView = false
            foldPickerView()
            tableView.endUpdates()
            updateDetailTextColor()
        }
        recurrenceRule.bymonthday.append(monthday)
        updateRecurrenceRuleText()
    }

    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didDeselectMonthday monthday: Int) {
        if isShowingPickerView {
            tableView.beginUpdates()
            isShowingPickerView = false
            foldPickerView()
            tableView.endUpdates()
            updateDetailTextColor()
        }
        if let index = recurrenceRule.bymonthday.indexOf(monthday) {
            recurrenceRule.bymonthday.removeAtIndex(index)
            updateRecurrenceRuleText()
        }
    }

    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, shouldDeselectMonthday monthday: Int) -> Bool {
        return recurrenceRule.bymonthday.count > 1
    }

    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didSelectMonth month: Int) {
        if isShowingPickerView {
            tableView.beginUpdates()
            isShowingPickerView = false
            foldPickerView()
            tableView.endUpdates()
            updateDetailTextColor()
        }
        recurrenceRule.bymonth.append(month)
        updateRecurrenceRuleText()
    }

    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, didDeselectMonth month: Int) {
        if isShowingPickerView {
            tableView.beginUpdates()
            isShowingPickerView = false
            foldPickerView()
            tableView.endUpdates()
            updateDetailTextColor()
        }
        if let index = recurrenceRule.bymonth.indexOf(month) {
            recurrenceRule.bymonth.removeAtIndex(index)
            updateRecurrenceRuleText()
        }
    }

    func monthOrDaySelectorCell(cell: MonthOrDaySelectorCell, shouldDeselectMonth month: Int) -> Bool {
        return recurrenceRule.bymonth.count > 1
    }
}

extension CustomRecurrenceViewController {
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (context) -> Void in

        }) { (context) -> Void in
            let frequency = self.recurrenceRule.frequency
            if frequency == .Monthly || frequency == .Yearly {
                if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as? MonthOrDaySelectorCell {
                    cell.style = frequency == .Monthly ? .Day : .Month
                }
            }
        }
    }
}
