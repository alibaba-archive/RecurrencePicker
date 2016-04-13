//
//  RecurrenceRule+Generator.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import RRuleSwift

public extension RecurrenceRule {
    public func isDailyRecurrence() -> Bool {
        return frequency == .Daily && interval == 1
    }

    public func isWeekdayRecurrence() -> Bool {
        guard frequency == .Weekly && interval == 1 else {
            return false
        }
        let byweekday = self.byweekday.sort(<)
        return byweekday == [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday].sort(<)
    }

    public func isWeeklyRecurrence(occurrenceDate occurrenceDate: NSDate) -> Bool {
        guard frequency == .Weekly && interval == 1 else {
            return false
        }
        guard byweekday.count == 1 else {
            return false
        }
        let weekday = byweekday.first!
        let occurrenceDateComponents = calendar.components([.Weekday], fromDate: occurrenceDate)
        return occurrenceDateComponents.weekday == weekday.rawValue
    }

    public func isBiWeeklyRecurrence(occurrenceDate occurrenceDate: NSDate) -> Bool {
        guard frequency == .Weekly && interval == 2 else {
            return false
        }
        guard byweekday.count == 1 else {
            return false
        }
        let weekday = byweekday.first!
        let occurrenceDateComponents = calendar.components([.Weekday], fromDate: occurrenceDate)
        return occurrenceDateComponents.weekday == weekday.rawValue
    }

    public func isMonthlyRecurrence(occurrenceDate occurrenceDate: NSDate) -> Bool {
        guard frequency == .Monthly && interval == 1 else {
            return false
        }
        guard bymonthday.count == 1 else {
            return false
        }
        let monthday = bymonthday.first!
        let occurrenceDateComponents = calendar.components([.Day], fromDate: occurrenceDate)
        return occurrenceDateComponents.day == monthday
    }

    public func isYearlyRecurrence(occurrenceDate occurrenceDate: NSDate) -> Bool {
        guard frequency == .Yearly && interval == 1 else {
            return false
        }
        guard bymonth.count == 1 else {
            return false
        }
        let month = bymonth.first!
        let occurrenceDateComponents = calendar.components([.Month], fromDate: occurrenceDate)
        return occurrenceDateComponents.month == month
    }

    public func isCustomRecurrence(occurrenceDate occurrenceDate: NSDate) -> Bool {
        return !isDailyRecurrence() &&
            !isWeekdayRecurrence() &&
            !isWeeklyRecurrence(occurrenceDate: occurrenceDate) &&
            !isBiWeeklyRecurrence(occurrenceDate: occurrenceDate) &&
            !isMonthlyRecurrence(occurrenceDate: occurrenceDate) &&
            !isYearlyRecurrence(occurrenceDate: occurrenceDate)
    }
}
