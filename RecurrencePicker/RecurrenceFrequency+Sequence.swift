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
        case .Daily: return 0
        case .Weekly: return 1
        case .Monthly: return 2
        case .Yearly: return 3
        case .Hourly: return 4
        case .Minutely: return 5
        case .Secondly: return 6
        }
    }
}
