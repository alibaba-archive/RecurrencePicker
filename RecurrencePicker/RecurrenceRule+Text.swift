//
//  RecurrenceRule+Text.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import RRuleSwift

public extension RecurrenceRule {
    public func toText(language language: RecurrencePickerLanguage = .English, occurrenceDate: NSDate) -> String? {
        let internationalControl = InternationalControl(language: language)
        let unit = Constant.unitStrings(language: language)[frequency.number]
        let pluralUnit = Constant.pluralUnitStrings(language: language)[frequency.number]

        let unitString: String = {
            if language == .Korean || language == .Japanese {
                return "\(interval)" + pluralUnit
            } else {
                if interval == 1 {
                    return unit
                } else {
                    if language == .English {
                        return "\(interval)" + " " + pluralUnit
                    } else {
                        return "\(interval)" + pluralUnit
                    }
                }
            }
        }()

        switch frequency {
        case .Daily:
            return String(format: internationalControl.localizedString(key: "RecurrenceString.presetRepeat"), unitString)

        case .Weekly:
            guard let byweekday = byweekday?.sort(<) where byweekday.count > 0 else {
                return nil
            }

            if isWeekdayRecurrence() {
                return internationalControl.localizedString(key: "RecurrenceString.weekdayRecurrence")
            } else if interval == 1 && byweekday == [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday].sort(<) {
                return RecurrenceRule(frequency: .Daily).toText(language: language, occurrenceDate: occurrenceDate)
            } else if byweekday.count == 1 && calendar.components([.Weekday], fromDate: occurrenceDate).weekday == byweekday.first!.rawValue {
                return String(format: internationalControl.localizedString(key: "RecurrenceString.presetRepeat"), unitString)
            } else {
                var weekdaysString: String
                if language == .Korean {
                    weekdaysString = Constant.weekdaySymbols(language: language)[byweekday.first!.number]
                } else {
                    weekdaysString = internationalControl.localizedString(key: "RecurrenceString.element.on.weekly") + " " + Constant.weekdaySymbols(language: language)[byweekday.first!.number]
                }

                for index in 1..<byweekday.count {
                    var prefixString: String
                    if index == byweekday.count - 1 {
                        prefixString = " " + internationalControl.localizedString(key: "RecurrenceString.element.and")
                    } else {
                        prefixString = internationalControl.localizedString(key: "RecurrenceString.element.comma")
                    }
                    weekdaysString += prefixString + " " + Constant.weekdaySymbols(language: language)[byweekday[index].number]
                }

                if language != .English && language != .Korean {
                    weekdaysString.removeSubstring(" ")
                }

                if language == .Korean {
                    weekdaysString += internationalControl.localizedString(key: "RecurrenceString.element.on.weekly")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceString.specifiedDaysOrMonths"), unitString, weekdaysString)
            }

        case .Monthly:
            guard let bymonthday = bymonthday where bymonthday.count > 0 else {
                return nil
            }

            if bymonthday.count == 1 && calendar.components([.Day], fromDate: occurrenceDate).day == bymonthday.first! {
                return String(format: internationalControl.localizedString(key: "RecurrenceString.presetRepeat"), unitString)
            } else {
                var monthdaysString: String
                if language == .English {
                    monthdaysString = internationalControl.localizedString(key: "RecurrenceString.element.on.monthly") + " " + String.sequenceNumberString(bymonthday.first!)
                } else if language == .Korean {
                    monthdaysString = String(format: internationalControl.localizedString(key: "RecurrenceString.element.day"), String.sequenceNumberString(bymonthday.first!))
                } else {
                    monthdaysString = internationalControl.localizedString(key: "RecurrenceString.element.on.monthly") + String(format: internationalControl.localizedString(key: "RecurrenceString.element.day"), String.sequenceNumberString(bymonthday.first!))
                }

                for index in 1..<bymonthday.count {
                    var prefixStr: String
                    if index == bymonthday.count - 1 {
                        prefixStr = " " + internationalControl.localizedString(key: "RecurrenceString.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString(key: "RecurrenceString.element.comma")
                    }

                    if language == .English {
                        monthdaysString += prefixStr + " " + String.sequenceNumberString(bymonthday[index])
                    } else {
                        monthdaysString += prefixStr + " " + String(format: internationalControl.localizedString(key: "RecurrenceString.element.day"), String.sequenceNumberString(bymonthday[index]))
                    }
                }

                if language != .English && language != .Korean {
                    monthdaysString.removeSubstring(" ")
                } else if language == .Korean {
                    monthdaysString += internationalControl.localizedString(key: "RecurrenceString.element.on.monthly")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceString.specifiedDaysOrMonths"), unitString, monthdaysString)
            }

        case .Yearly:
            guard let bymonth = bymonth where bymonth.count > 0 else {
                return nil
            }

            if bymonth.count == 1 && calendar.components([.Month], fromDate: occurrenceDate).day == bymonth.first! {
                return String(format: internationalControl.localizedString(key: "RecurrenceString.presetRepeat"), unitString)
            } else {
                var monthsString: String
                if language == .English {
                    monthsString = internationalControl.localizedString(key: "RecurrenceString.element.on.yearlyMonths") + " " + Constant.monthSymbols(language: language)[bymonth.first! - 1]
                } else if language == .Korean {
                    monthsString = Constant.monthSymbols(language: language)[bymonth.first! - 1]
                } else {
                    monthsString = internationalControl.localizedString(key: "RecurrenceString.element.on.yearlyMonths") + Constant.monthSymbols(language: language)[bymonth.first! - 1]
                }

                for index in 1..<bymonth.count {
                    var prefixStr: String
                    if index == bymonth.count - 1 {
                        prefixStr = " " + internationalControl.localizedString(key: "RecurrenceString.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString(key: "RecurrenceString.element.comma")
                    }

                    if language == .English {
                        monthsString += prefixStr + " " + Constant.monthSymbols(language: language)[bymonth[index] - 1]
                    } else {
                        monthsString += prefixStr + " " + Constant.monthSymbols(language: language)[bymonth[index] - 1]
                    }
                }

                if language != .English && language != .Korean {
                    monthsString.removeSubstring(" ")
                }

                if language == .Korean {
                    monthsString += internationalControl.localizedString(key: "RecurrenceString.element.on.yearlyMonths")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceString.specifiedDaysOrMonths"), unitString, monthsString)
            }

        default:
            return nil
        }
    }
}
