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
    public func toText(language language: RecurrencePickerLanguage = InternationalControl.sharedControl.language, occurrenceDate: NSDate) -> String? {
        let internationalControl = InternationalControl(language: language)
        let unit = Constant.unitStrings(language: language)[frequency.number]
        let pluralUnit = Constant.pluralUnitStrings(language: language)[frequency.number]

        let unitString: String = {
            var unitString: String
            if language == .Korean || language == .Japanese {
                unitString = "\(interval)" + pluralUnit
            } else {
                if interval == 1 {
                    unitString = unit
                } else {
                    if language == .English {
                        unitString = "\(interval)" + " " + pluralUnit
                    } else {
                        unitString = "\(interval)" + pluralUnit
                    }
                }
            }
            return unitString.lowercaseString
        }()

        switch frequency {
        case .Daily:
            return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.basicRecurrence"), unitString)

        case .Weekly:
            let byweekday = self.byweekday.sort(<)
            guard byweekday.count > 0 else {
                return nil
            }

            if isWeekdayRecurrence() {
                return internationalControl.localizedString(key: "RecurrenceRuleText.everyWeekday")
            } else if interval == 1 && byweekday == [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday].sort(<) {
                return RecurrenceRule(frequency: .Daily).toText(language: language, occurrenceDate: occurrenceDate)
            } else if byweekday.count == 1 && calendar.components([.Weekday], fromDate: occurrenceDate).weekday == byweekday.first!.rawValue {
                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var weekdaysString: String
                if language == .Korean {
                    weekdaysString = Constant.weekdaySymbols(language: language)[byweekday.first!.number]
                } else {
                    weekdaysString = internationalControl.localizedString(key: "RecurrenceRuleText.element.on.weekly") + " " + Constant.weekdaySymbols(language: language)[byweekday.first!.number]
                }

                for index in 1..<byweekday.count {
                    var prefixString: String
                    if index == byweekday.count - 1 {
                        prefixString = " " + internationalControl.localizedString(key: "RecurrenceRuleText.element.and")
                    } else {
                        prefixString = internationalControl.localizedString(key: "RecurrenceRuleText.element.comma")
                    }
                    weekdaysString += prefixString + " " + Constant.weekdaySymbols(language: language)[byweekday[index].number]
                }

                if language != .English && language != .Korean {
                    weekdaysString.removeSubstring(" ")
                }

                if language == .Korean {
                    weekdaysString += internationalControl.localizedString(key: "RecurrenceRuleText.element.on.weekly")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, weekdaysString)
            }

        case .Monthly:
            let bymonthday = self.bymonthday.sort(<)
            guard bymonthday.count > 0 else {
                return nil
            }

            if bymonthday.count == 1 && calendar.components([.Day], fromDate: occurrenceDate).day == bymonthday.first! {
                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var monthdaysString: String
                if language == .English {
                    monthdaysString = internationalControl.localizedString(key: "RecurrenceRuleText.element.on.monthly") + " " + String.sequenceNumberString(bymonthday.first!)
                } else if language == .Korean {
                    monthdaysString = String(format: internationalControl.localizedString(key: "RecurrenceRuleText.element.day"), bymonthday.first!)
                } else {
                    monthdaysString = internationalControl.localizedString(key: "RecurrenceRuleText.element.on.monthly") + String(format: internationalControl.localizedString(key: "RecurrenceRuleText.element.day"), bymonthday.first!)
                }

                for index in 1..<bymonthday.count {
                    var prefixStr: String
                    if index == bymonthday.count - 1 {
                        prefixStr = " " + internationalControl.localizedString(key: "RecurrenceRuleText.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString(key: "RecurrenceRuleText.element.comma")
                    }

                    if language == .English {
                        monthdaysString += prefixStr + " " + String.sequenceNumberString(bymonthday[index])
                    } else {
                        monthdaysString += prefixStr + " " + String(format: internationalControl.localizedString(key: "RecurrenceRuleText.element.day"), bymonthday[index])
                    }
                }

                if language != .English && language != .Korean {
                    monthdaysString.removeSubstring(" ")
                } else if language == .Korean {
                    monthdaysString += internationalControl.localizedString(key: "RecurrenceRuleText.element.on.monthly")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, monthdaysString)
            }

        case .Yearly:
            let bymonth = self.bymonth.sort(<)
            guard bymonth.count > 0 else {
                return nil
            }

            if bymonth.count == 1 && calendar.components([.Month], fromDate: occurrenceDate).month == bymonth.first! {
                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var monthsString: String
                if language == .English {
                    monthsString = internationalControl.localizedString(key: "RecurrenceRuleText.element.on.yearly") + " " + Constant.monthSymbols(language: language)[bymonth.first! - 1]
                } else if language == .Korean {
                    monthsString = Constant.monthSymbols(language: language)[bymonth.first! - 1]
                } else {
                    monthsString = internationalControl.localizedString(key: "RecurrenceRuleText.element.on.yearly") + Constant.shortMonthSymbols(language: language)[bymonth.first! - 1]
                }

                for index in 1..<bymonth.count {
                    var prefixStr: String
                    if index == bymonth.count - 1 {
                        prefixStr = " " + internationalControl.localizedString(key: "RecurrenceRuleText.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString(key: "RecurrenceRuleText.element.comma")
                    }

                    if language == .English {
                        monthsString += prefixStr + " " + Constant.monthSymbols(language: language)[bymonth[index] - 1]
                    } else {
                        monthsString += prefixStr + " " + Constant.shortMonthSymbols(language: language)[bymonth[index] - 1]
                    }
                }

                if language != .English && language != .Korean {
                    monthsString.removeSubstring(" ")
                }

                if language == .Korean {
                    monthsString += internationalControl.localizedString(key: "RecurrenceRuleText.element.on.yearly")
                }

                return String(format: internationalControl.localizedString(key: "RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, monthsString)
            }

        default:
            return nil
        }
    }
}
