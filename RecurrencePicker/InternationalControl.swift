//
//  InternationalControl.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public enum RecurrencePickerLanguage {
    case english
    case simplifiedChinese
    case traditionalChinese
    case korean
    case japanese

    internal var identifier: String {
        switch self {
        case .english: return "en"
        case .simplifiedChinese: return "zh-Hans"
        case .traditionalChinese: return "zh-Hant"
        case .korean: return "ko"
        case .japanese: return "ja"
        }
    }
}

internal func LocalizedString(_ key: String, comment: String? = nil) -> String {
    return InternationalControl.sharedControl.localizedString(key, comment: comment)
}

internal struct InternationalControl {
    internal static var sharedControl = InternationalControl()
    internal var language: RecurrencePickerLanguage = .english

    internal func localizedString(_ key: String, comment: String? = nil) -> String {
        let path = Bundle(identifier: "Teambition.RecurrencePicker")?.path(forResource: language.identifier, ofType: "lproj") ?? Bundle.main.path(forResource: language.identifier, ofType: "lproj")
        guard let localizationPath = path else {
            return key
        }
        let bundle = Bundle(path: localizationPath)
        return bundle?.localizedString(forKey: key, value: nil, table: "RecurrencePicker") ?? key
    }
}
