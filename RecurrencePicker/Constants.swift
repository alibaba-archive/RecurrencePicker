//
//  Constants.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import EventKit
import RRuleSwift

internal struct CellID {
    static let commonCell = "CommonCell"
    static let basicRecurrenceCell = "BasicRecurrenceCell"
    static let customRecurrenceViewCell = "CustomRecurrenceViewCell"
    static let pickerViewCell = "PickerViewCell"
    static let selectorItemCell = "SelectorItemCell"
    static let monthOrDaySelectorCell = "MonthOrDaySelectorCell"
}

internal struct Constant {
    static let defaultRowHeight: CGFloat = 44
    static let pickerViewCellHeight: CGFloat = 215
    static let pickerRowHeight: CGFloat = 40
    static let pickerMaxRowCount = 999
    static let detailTextColor = UIColor.grayColor()

    static let selectorVerticalPadding: CGFloat = 1
    static let gridLineWidth: CGFloat = 0.5
    static let gridLineColor = UIColor(white: 187.0 / 255.0, alpha: 1)
    static let gridLineName = "RecurrencePicker.GridSelectorViewGridLine"
}

internal extension Constant {
    static var frequencies: [RecurrenceFrequency] {
        return [.Daily, .Weekly, .Monthly, .Yearly]
    }
    static var weekdays: [EKWeekday] {
        return [EKWeekday.Monday, EKWeekday.Tuesday, EKWeekday.Wednesday, EKWeekday.Thursday, EKWeekday.Friday, EKWeekday.Saturday, EKWeekday.Sunday]
    }
    static func weekdaySymbols(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: language.identifier)
        var weekdaySymbols = dateFormatter.weekdaySymbols
        weekdaySymbols.insert(weekdaySymbols.removeAtIndex(0), atIndex: 6)
        return weekdaySymbols
    }

    static func shortMonthSymbols(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: language.identifier)
        return dateFormatter.shortMonthSymbols
    }

    static func monthSymbols(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: language.identifier)
        return dateFormatter.monthSymbols
    }

    static func basicRecurrenceStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "basicRecurrence.never"),
                internationalControl.localizedString(key: "basicRecurrence.everyDay"),
                internationalControl.localizedString(key: "basicRecurrence.everyWeek"),
                internationalControl.localizedString(key: "basicRecurrence.everyTwoWeeks"),
                internationalControl.localizedString(key: "basicRecurrence.everyMonth"),
                internationalControl.localizedString(key: "basicRecurrence.everyYear"),
                internationalControl.localizedString(key: "basicRecurrence.everyWeekday"),]
    }

    static func frequencyStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "frequency.daily"),
                internationalControl.localizedString(key: "frequency.weekly"),
                internationalControl.localizedString(key: "frequency.monthly"),
                internationalControl.localizedString(key: "frequency.yearly"),]
    }

    static func unitStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "unit.day"),
                internationalControl.localizedString(key: "unit.week"),
                internationalControl.localizedString(key: "unit.month"),
                internationalControl.localizedString(key: "unit.year"),]
    }

    static func pluralUnitStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "pluralUnit.day"),
                internationalControl.localizedString(key: "pluralUnit.week"),
                internationalControl.localizedString(key: "pluralUnit.month"),
                internationalControl.localizedString(key: "pluralUnit.year"),]
    }
}
