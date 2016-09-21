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
    static let detailTextColor = UIColor.gray

    static let selectorVerticalPadding: CGFloat = 1
    static let gridLineWidth: CGFloat = 0.5
    static let gridLineColor = UIColor(white: 187.0 / 255.0, alpha: 1)
    static let gridLineName = "RecurrencePicker.GridSelectorViewGridLine"
}

internal extension Constant {
    static var frequencies: [RecurrenceFrequency] {
        return [.daily, .weekly, .monthly, .yearly]
    }
    static var weekdays: [EKWeekday] {
        return [EKWeekday.monday, EKWeekday.tuesday, EKWeekday.wednesday, EKWeekday.thursday, EKWeekday.friday, EKWeekday.saturday, EKWeekday.sunday]
    }
    static func weekdaySymbols(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language.identifier)
        var weekdaySymbols = dateFormatter.weekdaySymbols!
        weekdaySymbols.insert(weekdaySymbols.remove(at: 0), at: 6)
        return weekdaySymbols
    }

    static func shortMonthSymbols(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language.identifier)
        return dateFormatter.shortMonthSymbols
    }

    static func monthSymbols(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language.identifier)
        return dateFormatter.monthSymbols
    }

    static func basicRecurrenceStrings(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString("basicRecurrence.never"),
                internationalControl.localizedString("basicRecurrence.everyDay"),
                internationalControl.localizedString("basicRecurrence.everyWeek"),
                internationalControl.localizedString("basicRecurrence.everyTwoWeeks"),
                internationalControl.localizedString("basicRecurrence.everyMonth"),
                internationalControl.localizedString("basicRecurrence.everyYear"),
                internationalControl.localizedString("basicRecurrence.everyWeekday"),]
    }

    static func frequencyStrings(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString("frequency.daily"),
                internationalControl.localizedString("frequency.weekly"),
                internationalControl.localizedString("frequency.monthly"),
                internationalControl.localizedString("frequency.yearly"),]
    }

    static func unitStrings(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString("unit.day"),
                internationalControl.localizedString("unit.week"),
                internationalControl.localizedString("unit.month"),
                internationalControl.localizedString("unit.year"),]
    }

    static func pluralUnitStrings(_ language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString("pluralUnit.day"),
                internationalControl.localizedString("pluralUnit.week"),
                internationalControl.localizedString("pluralUnit.month"),
                internationalControl.localizedString("pluralUnit.year"),]
    }
}
