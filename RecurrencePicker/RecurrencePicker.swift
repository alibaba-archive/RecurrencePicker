//
//  RecurrencePicker.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import EventKit
import RRuleSwift

open class RecurrencePicker: UITableViewController {
    open var language: RecurrencePickerLanguage = .english {
        didSet {
            InternationalControl.sharedControl.language = language
        }
    }
    open weak var delegate: RecurrencePickerDelegate?
    open var tintColor = UIColor.blue
    open var calendar = Calendar.current
    open var occurrenceDate = Date()
    open var backgroundColor: UIColor?
    open var separatorColor: UIColor?

    fileprivate var recurrenceRule: RecurrenceRule?
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)

    // MARK: - Initialization
    public convenience init(recurrenceRule: RecurrenceRule?) {
        self.init(style: .grouped)
        self.recurrenceRule = recurrenceRule
    }

    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    open override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            // navigation is popped
            if let rule = recurrenceRule {
                switch rule.frequency {
                case .daily:
                    recurrenceRule?.byweekday.removeAll()
                    recurrenceRule?.bymonthday.removeAll()
                    recurrenceRule?.bymonth.removeAll()
                case .weekly:
                    recurrenceRule?.byweekday = rule.byweekday.sorted(by: <)
                    recurrenceRule?.bymonthday.removeAll()
                    recurrenceRule?.bymonth.removeAll()
                case .monthly:
                    recurrenceRule?.byweekday.removeAll()
                    recurrenceRule?.bymonthday = rule.bymonthday.sorted(by: <)
                    recurrenceRule?.bymonth.removeAll()
                case .yearly:
                    recurrenceRule?.byweekday.removeAll()
                    recurrenceRule?.bymonthday.removeAll()
                    recurrenceRule?.bymonth = rule.bymonth.sorted(by: <)
                default:
                    break
                }
            }
            recurrenceRule?.startDate = Date()

            delegate?.recurrencePicker(self, didPickRecurrence: recurrenceRule)
        }
    }
}

extension RecurrencePicker {
    // MARK: - Table view data source and delegate
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Constant.basicRecurrenceStrings().count
        } else {
            return 1
        }
    }

    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.defaultRowHeight
    }

    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? recurrenceRuleText() : nil
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID.basicRecurrenceCell)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellID.basicRecurrenceCell)
        }

        if (indexPath as NSIndexPath).section == 0 {
            cell?.accessoryType = .none
            cell?.textLabel?.text = Constant.basicRecurrenceStrings()[(indexPath as NSIndexPath).row]
        } else {
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.text = LocalizedString("RecurrencePicker.textLabel.custom")
        }

        let checkmark = UIImage(named: "checkmark", in: Bundle(for: type(of: self)), compatibleWith: nil)
        cell?.imageView?.image = checkmark?.withRenderingMode(.alwaysTemplate)

        if indexPath == selectedIndexPath {
            cell?.imageView?.isHidden = false
        } else {
            cell?.imageView?.isHidden = true
        }
        return cell!
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastSelectedCell = tableView.cellForRow(at: selectedIndexPath)
        let currentSelectedCell = tableView.cellForRow(at: indexPath)

        lastSelectedCell?.imageView?.isHidden = true
        currentSelectedCell?.imageView?.isHidden = false

        selectedIndexPath = indexPath

        if (indexPath as NSIndexPath).section == 0 {
            updateRecurrenceRule(withSelectedIndexPath: indexPath)
            updateRecurrenceRuleText()
            _ = navigationController?.popViewController(animated: true)
        } else {
            let customRecurrenceViewController = CustomRecurrenceViewController(style: .grouped)
            customRecurrenceViewController.occurrenceDate = occurrenceDate
            customRecurrenceViewController.tintColor = tintColor
            customRecurrenceViewController.backgroundColor = backgroundColor
            customRecurrenceViewController.separatorColor = separatorColor
            customRecurrenceViewController.delegate = self

            var rule = recurrenceRule ?? RecurrenceRule.dailyRecurrence()
            let occurrenceDateComponents = (calendar as Calendar).dateComponents([.weekday, .day, .month], from: occurrenceDate)
            if rule.byweekday.count == 0 {
                let weekday = EKWeekday(rawValue: occurrenceDateComponents.weekday!)!
                rule.byweekday = [weekday]
            }
            if rule.bymonthday.count == 0 {
                let monthday = occurrenceDateComponents.day
                rule.bymonthday = [monthday!]
            }
            if rule.bymonth.count == 0 {
                let month = occurrenceDateComponents.month
                rule.bymonth = [month!]
            }
            customRecurrenceViewController.recurrenceRule = rule

            navigationController?.pushViewController(customRecurrenceViewController, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecurrencePicker {
    // MARK: - Helper
    fileprivate func commonInit() {
        navigationItem.title = LocalizedString("RecurrencePicker.navigation.title")
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
        if let backgroundColor = backgroundColor {
            tableView.backgroundColor = backgroundColor
        }
        if let separatorColor = separatorColor {
            tableView.separatorColor = separatorColor
        }
        updateSelectedIndexPath(withRule: recurrenceRule)
    }

    fileprivate func updateSelectedIndexPath(withRule recurrenceRule: RecurrenceRule?) {
        guard let recurrenceRule = recurrenceRule else {
            selectedIndexPath = IndexPath(row: 0, section: 0)
            return
        }
        if recurrenceRule.isDailyRecurrence() {
            selectedIndexPath = IndexPath(row: 1, section: 0)
        } else if recurrenceRule.isWeeklyRecurrence(occurrenceDate) {
            selectedIndexPath = IndexPath(row: 2, section: 0)
        } else if recurrenceRule.isBiWeeklyRecurrence(occurrenceDate) {
            selectedIndexPath = IndexPath(row: 3, section: 0)
        } else if recurrenceRule.isMonthlyRecurrence(occurrenceDate) {
            selectedIndexPath = IndexPath(row: 4, section: 0)
        } else if recurrenceRule.isYearlyRecurrence(occurrenceDate) {
            selectedIndexPath = IndexPath(row: 5, section: 0)
        } else if recurrenceRule.isWeekdayRecurrence() {
            selectedIndexPath = IndexPath(row: 6, section: 0)
        } else {
            selectedIndexPath = IndexPath(row: 0, section: 1)
        }
    }

    fileprivate func updateRecurrenceRule(withSelectedIndexPath indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section == 0 else {
            return
        }

        switch (indexPath as NSIndexPath).row {
        case 0:
            recurrenceRule = nil
        case 1:
            recurrenceRule = RecurrenceRule.dailyRecurrence()
        case 2:
            let occurrenceDateComponents = (calendar as Calendar).dateComponents([.weekday], from: occurrenceDate)
            let weekday = EKWeekday(rawValue: occurrenceDateComponents.weekday!)!
            recurrenceRule = RecurrenceRule.weeklyRecurrence(weekday)
        case 3:
            let occurrenceDateComponents = (calendar as Calendar).dateComponents([.weekday], from: occurrenceDate)
            let weekday = EKWeekday(rawValue: occurrenceDateComponents.weekday!)!
            recurrenceRule = RecurrenceRule.biWeeklyRecurrence(weekday)
        case 4:
            let occurrenceDateComponents = (calendar as Calendar).dateComponents([.day], from: occurrenceDate)
            let monthday = occurrenceDateComponents.day
            recurrenceRule = RecurrenceRule.monthlyRecurrence(monthday!)
        case 5:
            let occurrenceDateComponents = (calendar as Calendar).dateComponents([.month], from: occurrenceDate)
            let month = occurrenceDateComponents.month
            recurrenceRule = RecurrenceRule.yearlyRecurrence(month!)
        case 6:
            recurrenceRule = RecurrenceRule.weekdayRecurrence()
        default:
            break
        }
    }

    fileprivate func recurrenceRuleText() -> String? {
        return (selectedIndexPath as IndexPath).section == 1 ? recurrenceRule?.toText(occurrenceDate: occurrenceDate) : nil
    }

    fileprivate func updateRecurrenceRuleText() {
        let footerView = tableView.footerView(forSection: 1)

        tableView.beginUpdates()
        footerView?.textLabel?.text = recurrenceRuleText()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
}

extension RecurrencePicker: CustomRecurrenceViewControllerDelegate {
    func customRecurrenceViewController(_ controller: CustomRecurrenceViewController, didPickRecurrence recurrenceRule: RecurrenceRule) {
        self.recurrenceRule = recurrenceRule
        updateRecurrenceRuleText()
    }
}
