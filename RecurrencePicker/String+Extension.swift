//
//  String+Extension.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

internal extension String {
    mutating func removeSubstring(_ substring: String) {
        self = replacingOccurrences(of: substring, with: "", options: .literal, range: nil)
    }

    static func sequenceNumberString(of number: Int) -> String {
        var suffix = "th"
        let ones = number % 10
        let tens = (number / 10) % 10

        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "\(number)\(suffix)"
    }
}
