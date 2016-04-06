//
//  EKWeekday+Sequence.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit

internal extension EKWeekday {
    internal var number: Int {
        switch self {
        case .Monday: return 0
        case .Tuesday: return 1
        case .Wednesday: return 2
        case .Thursday: return 3
        case .Friday: return 4
        case .Saturday: return 5
        case .Sunday: return 6
        }
    }
}
