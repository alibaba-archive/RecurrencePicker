//
//  RecurrenceRule+Generator.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit
import RRuleSwift

public extension RecurrenceRule {
    static func dailyRecurrence() -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .daily)
        recurrenceRule.interval = 1
        return recurrenceRule
    }

    static func weekdayRecurrence() -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .weekly)
        recurrenceRule.interval = 1
        recurrenceRule.byweekday = [.monday, .tuesday, .wednesday, .thursday, .friday]
        return recurrenceRule
    }

    static func weeklyRecurrence(withWeekday weekday: EKWeekday) -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .weekly)
        recurrenceRule.interval = 1
        recurrenceRule.byweekday = [weekday]
        return recurrenceRule
    }

    static func biWeeklyRecurrence(withWeekday weekday: EKWeekday) -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .weekly)
        recurrenceRule.interval = 2
        recurrenceRule.byweekday = [weekday]
        return recurrenceRule
    }

    static func monthlyRecurrence(withMonthday monthday: Int) -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .monthly)
        recurrenceRule.interval = 1
        if (-31...31 ~= monthday) && (monthday != 0) {
            recurrenceRule.bymonthday = [monthday]
        }
        return recurrenceRule
    }

    static func yearlyRecurrence(withMonth month: Int) -> RecurrenceRule {
        var recurrenceRule = RecurrenceRule(frequency: .yearly)
        recurrenceRule.interval = 1
        if 1...12 ~= month {
            recurrenceRule.bymonth = [month]
        }
        return recurrenceRule
    }
}
