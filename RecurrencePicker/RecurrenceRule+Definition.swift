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

    public func isWeeklyRecurrence(_ occurrenceDate: Date) -> Bool {
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
        let occurrenceDateComponents = calendar.dateComponents([.weekday], from: occurrenceDate)
        return occurrenceDateComponents.weekday == weekday.rawValue
    }

    public func isBiWeeklyRecurrence(_ occurrenceDate: Date) -> Bool {
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
        let occurrenceDateComponents = calendar.dateComponents([.weekday], from: occurrenceDate)
        return occurrenceDateComponents.weekday == weekday.rawValue
    }

    public func isMonthlyRecurrence(_ occurrenceDate: Date) -> Bool {
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
        let occurrenceDateComponents = calendar.dateComponents([.day], from: occurrenceDate)
        return occurrenceDateComponents.day == monthday
    }

    public func isYearlyRecurrence(_ occurrenceDate: Date) -> Bool {
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
        let occurrenceDateComponents = calendar.dateComponents([.month], from: occurrenceDate)
        return occurrenceDateComponents.month == month
    }

    public func isCustomRecurrence(_ occurrenceDate: Date) -> Bool {
        return !isDailyRecurrence() &&
            !isWeekdayRecurrence() &&
            !isWeeklyRecurrence(occurrenceDate) &&
            !isBiWeeklyRecurrence(occurrenceDate) &&
            !isMonthlyRecurrence(occurrenceDate) &&
            !isYearlyRecurrence(occurrenceDate)
    }
}
