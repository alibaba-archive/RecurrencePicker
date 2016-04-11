//
//  Constants.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
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
        return [internationalControl.localizedString(key: "TBRPHelper.presetRepeat.never"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyDay"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyWeek"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyTwoWeeks"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyMonth"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyYear"),
                internationalControl.localizedString(key: "TBRPHelper.presetRepeat.everyWeekday"),]
    }

    static func frequencyStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "TBRPHelper.frequencies.daily"),
                internationalControl.localizedString(key: "TBRPHelper.frequencies.weekly"),
                internationalControl.localizedString(key: "TBRPHelper.frequencies.monthly"),
                internationalControl.localizedString(key: "TBRPHelper.frequencies.yearly"),]
    }

    static func unitStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "TBRPHelper.units.day"),
                internationalControl.localizedString(key: "TBRPHelper.units.week"),
                internationalControl.localizedString(key: "TBRPHelper.units.month"),
                internationalControl.localizedString(key: "TBRPHelper.units.year"),]
    }

    static func pluralUnitStrings(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language) -> [String] {
        let internationalControl = InternationalControl(language: language)
        return [internationalControl.localizedString(key: "TBRPHelper.pluralUnits.days"),
                internationalControl.localizedString(key: "TBRPHelper.pluralUnits.weeks"),
                internationalControl.localizedString(key: "TBRPHelper.pluralUnits.months"),
                internationalControl.localizedString(key: "TBRPHelper.pluralUnits.years"),]
    }
}
