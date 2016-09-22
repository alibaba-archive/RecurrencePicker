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
        return frequency == .daily && interval == 1
    }

    public func isWeekdayRecurrence() -> Bool {
        guard frequency == .weekly && interval == 1 else {
            return false
        }
        let byweekday = self.byweekday.sorted(by: <)
        return byweekday == [.monday, .tuesday, .wednesday, .thursday, .friday].sorted(by: <)
    }

    public func isWeeklyRecurrence(occurrence occurrenceDate: Date) -> Bool {
        guard frequency == .weekly && interval == 1 else {
            return false
        }
        guard byweekday.count == 1 else {
            if byweekday.count == 0 {
                return true
            }
            return false
        }
        let weekday = byweekday.first!
        return calendar.component(.weekday, from: occurrenceDate) == weekday.rawValue
    }

    public func isBiWeeklyRecurrence(occurrence occurrenceDate: Date) -> Bool {
        guard frequency == .weekly && interval == 2 else {
            return false
        }
        guard byweekday.count == 1 else {
            if byweekday.count == 0 {
                return true
            }
            return false
        }
        let weekday = byweekday.first!
        return calendar.component(.weekday, from: occurrenceDate) == weekday.rawValue
    }

    public func isMonthlyRecurrence(occurrence occurrenceDate: Date) -> Bool {
        guard frequency == .monthly && interval == 1 else {
            return false
        }
        guard bymonthday.count == 1 else {
            if bymonthday.count == 0 {
                return true
            }
            return false
        }
        let monthday = bymonthday.first!
        return calendar.component(.day, from: occurrenceDate) == monthday
    }

    public func isYearlyRecurrence(occurrence occurrenceDate: Date) -> Bool {
        guard frequency == .yearly && interval == 1 else {
            return false
        }
        guard bymonth.count == 1 else {
            if bymonth.count == 0 {
                return true
            }
            return false
        }
        let month = bymonth.first!
        return calendar.component(.month, from: occurrenceDate) == month
    }

    public func isCustomRecurrence(occurrence occurrenceDate: Date) -> Bool {
        return !isDailyRecurrence() &&
            !isWeekdayRecurrence() &&
            !isWeeklyRecurrence(occurrence: occurrenceDate) &&
            !isBiWeeklyRecurrence(occurrence: occurrenceDate) &&
            !isMonthlyRecurrence(occurrence: occurrenceDate) &&
            !isYearlyRecurrence(occurrence: occurrenceDate)
    }
}
