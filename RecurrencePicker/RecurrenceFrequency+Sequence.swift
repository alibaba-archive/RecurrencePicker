//
//  RecurrenceFrequency+Sequence.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import RRuleSwift

internal extension RecurrenceFrequency {
    internal var number: Int {
        switch self {
        case .daily: return 0
        case .weekly: return 1
        case .monthly: return 2
        case .yearly: return 3
        case .hourly: return 4
        case .minutely: return 5
        case .secondly: return 6
        }
    }
}
