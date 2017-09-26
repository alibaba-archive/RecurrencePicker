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
    public func toText(of language: RecurrencePickerLanguage = InternationalControl.shared.language, occurrenceDate: Date) -> String? {
        let internationalControl = InternationalControl(language: language)
        let unit = Constant.unitStrings(of: language)[frequency.number]
        let pluralUnit = Constant.pluralUnitStrings(of: language)[frequency.number]

        let unitString: String = {
            var unitString: String
            if language == .korean || language == .japanese {
                unitString = "\(interval)" + pluralUnit
            } else {
                if interval == 1 {
                    unitString = unit
                } else {
                    if language == .english {
                        unitString = "\(interval)" + " " + pluralUnit
                    } else {
                        unitString = "\(interval)" + pluralUnit
                    }
                }
            }
            return unitString.lowercased()
        }()

        switch frequency {
        case .daily:
            return String(format: internationalControl.localizedString("RecurrenceRuleText.basicRecurrence"), unitString)

        case .weekly:
            let byweekday = self.byweekday.sorted(by: <)
            guard byweekday.count > 0 else {
                return nil
            }

            if isWeekdayRecurrence() {
                return internationalControl.localizedString("RecurrenceRuleText.everyWeekday")
            } else if interval == 1 && byweekday == [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday].sorted(by: <) {
                return RecurrenceRule(frequency: .daily).toText(of: language, occurrenceDate: occurrenceDate)
            } else if byweekday.count == 1 && calendar.component(.weekday, from: occurrenceDate) == byweekday.first!.rawValue {
                return String(format: internationalControl.localizedString("RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var weekdaysString: String
                if language == .korean {
                    weekdaysString = Constant.weekdaySymbols(of: language)[byweekday.first!.number]
                } else {
                    weekdaysString = internationalControl.localizedString("RecurrenceRuleText.element.on.weekly") + " " + Constant.weekdaySymbols(of: language)[byweekday.first!.number]
                }

                for index in 1..<byweekday.count {
                    var prefixString: String
                    if index == byweekday.count - 1 {
                        prefixString = " " + internationalControl.localizedString("RecurrenceRuleText.element.and")
                    } else {
                        prefixString = internationalControl.localizedString("RecurrenceRuleText.element.comma")
                    }
                    weekdaysString += prefixString + " " + Constant.weekdaySymbols(of: language)[byweekday[index].number]
                }

                if language != .english && language != .korean {
                    weekdaysString.removeSubstring(" ")
                }

                if language == .korean {
                    weekdaysString += internationalControl.localizedString("RecurrenceRuleText.element.on.weekly")
                }

                return String(format: internationalControl.localizedString("RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, weekdaysString)
            }

        case .monthly:
            let bymonthday = self.bymonthday.sorted(by: <)
            guard bymonthday.count > 0 else {
                return nil
            }

            if bymonthday.count == 1 && calendar.component(.day, from: occurrenceDate) == bymonthday.first! {
                return String(format: internationalControl.localizedString("RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var monthdaysString: String
                if language == .english {
                    monthdaysString = internationalControl.localizedString("RecurrenceRuleText.element.on.monthly") + " " + String.sequenceNumberString(of: bymonthday.first!)
                } else if language == .korean {
                    monthdaysString = String(format: internationalControl.localizedString("RecurrenceRuleText.element.day"), bymonthday.first!)
                } else {
                    monthdaysString = internationalControl.localizedString("RecurrenceRuleText.element.on.monthly") + String(format: internationalControl.localizedString("RecurrenceRuleText.element.day"), bymonthday.first!)
                }

                for index in 1..<bymonthday.count {
                    var prefixStr: String
                    if index == bymonthday.count - 1 {
                        prefixStr = " " + internationalControl.localizedString("RecurrenceRuleText.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString("RecurrenceRuleText.element.comma")
                    }

                    if language == .english {
                        monthdaysString += prefixStr + " " + String.sequenceNumberString(of: bymonthday[index])
                    } else {
                        monthdaysString += prefixStr + " " + String(format: internationalControl.localizedString("RecurrenceRuleText.element.day"), bymonthday[index])
                    }
                }

                if language != .english && language != .korean {
                    monthdaysString.removeSubstring(" ")
                } else if language == .korean {
                    monthdaysString += internationalControl.localizedString("RecurrenceRuleText.element.on.monthly")
                }

                return String(format: internationalControl.localizedString("RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, monthdaysString)
            }

        case .yearly:
            let bymonth = self.bymonth.sorted(by: <)
            guard bymonth.count > 0 else {
                return nil
            }

            if bymonth.count == 1 && calendar.component(.month, from: occurrenceDate) == bymonth.first! {
                return String(format: internationalControl.localizedString("RecurrenceRuleText.basicRecurrence"), unitString)
            } else {
                var monthsString: String
                if language == .english {
                    monthsString = internationalControl.localizedString("RecurrenceRuleText.element.on.yearly") + " " + Constant.monthSymbols(of: language)[bymonth.first! - 1]
                } else if language == .korean {
                    monthsString = Constant.monthSymbols(of: language)[bymonth.first! - 1]
                } else {
                    monthsString = internationalControl.localizedString("RecurrenceRuleText.element.on.yearly") + Constant.shortMonthSymbols(of: language)[bymonth.first! - 1]
                }

                for index in 1..<bymonth.count {
                    var prefixStr: String
                    if index == bymonth.count - 1 {
                        prefixStr = " " + internationalControl.localizedString("RecurrenceRuleText.element.and")
                    } else {
                        prefixStr = internationalControl.localizedString("RecurrenceRuleText.element.comma")
                    }

                    if language == .english {
                        monthsString += prefixStr + " " + Constant.monthSymbols(of: language)[bymonth[index] - 1]
                    } else {
                        monthsString += prefixStr + " " + Constant.shortMonthSymbols(of: language)[bymonth[index] - 1]
                    }
                }

                if language != .english && language != .korean {
                    monthsString.removeSubstring(" ")
                }

                if language == .korean {
                    monthsString += internationalControl.localizedString("RecurrenceRuleText.element.on.yearly")
                }

                return String(format: internationalControl.localizedString("RecurrenceRuleText.byWeekdaysOrMonthdaysOrMonths"), unitString, monthsString)
            }

        default:
            return nil
        }
    }
}
