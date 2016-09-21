//
//  ExampleViewController.swift
//  RecurrencePickerExample
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import RRuleSwift
import RecurrencePicker

private let kTBBlueColor = UIColor(red: 3.0 / 255.0, green: 169.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)

class ExampleViewController: UIViewController {
    var recurrenceRule: RecurrenceRule?
    var language: RecurrencePickerLanguage = .english
    var occurrenceDate: Date {
        return datePicker.date
    }

    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLanguageButtonTitle()
        updateResultTextView()
    }

    // MARK: - Helper
    fileprivate func updateLanguageButtonTitle() {
        guard let index = languages.index(of: language) else {
            return
        }
        let languageTitle = languageStrings[index]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: languageTitle, style: .plain, target: self, action: #selector(ExampleViewController.switchLanguageButtonTapped(_:)))
    }

    fileprivate func updateResultTextView() {
        if let recurrenceRule = recurrenceRule {
            resultTextView.text = recurrenceRule.toRRuleString() + "\r\r" + (recurrenceRule.toText(language: language, occurrenceDate: occurrenceDate) ?? "")
        } else {
            resultTextView.text = nil
        }
    }

    // MARK: - Actions
    @IBAction func pickButtonTapped(_ sender: UIButton) {
        let recurrencePicker = RecurrencePicker(recurrenceRule: recurrenceRule)
        recurrencePicker.tintColor = kTBBlueColor
        recurrencePicker.language = language
        recurrencePicker.occurrenceDate = occurrenceDate
        recurrencePicker.backgroundColor = UIColor(white: 242 / 255, alpha: 1)
        recurrencePicker.separatorColor = UIColor(white: 221 / 255, alpha: 1)
        recurrencePicker.delegate = self
        navigationController?.pushViewController(recurrencePicker, animated: true)
    }

    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        print("Occurrence Date: \(sender.date)")
        updateResultTextView()
    }

    func switchLanguageButtonTapped(_ sender: UIBarButtonItem) {
        let languageViewController = LanguageViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: languageViewController)
        languageViewController.language = language
        languageViewController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
}

extension ExampleViewController: LanguageViewControllerDelegate {
    func languageViewController(_ controller: LanguageViewController, didSelectLanguage language: RecurrencePickerLanguage) {
        self.language = language
        updateLanguageButtonTitle()
        updateResultTextView()
    }
}

extension ExampleViewController: RecurrencePickerDelegate {
    func recurrencePicker(_ picker: RecurrencePicker, didPickRecurrence recurrenceRule: RecurrenceRule?) {
        self.recurrenceRule = recurrenceRule
        updateResultTextView()
    }
}
