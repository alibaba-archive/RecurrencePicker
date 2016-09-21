//
//  LanguageViewController.swift
//  RecurrencePickerExample
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import RecurrencePicker

let languages: [RecurrencePickerLanguage] = [.english, .simplifiedChinese, .traditionalChinese, .korean, .japanese]
let languageStrings = ["English", "Simplified Chinese", "Traditional Chinese", "Korean", "Japanese"]
private let kLanguageViewControllerCellID = "LanguageViewControllerCell"

protocol LanguageViewControllerDelegate {
    func languageViewController(_ controller: LanguageViewController, didSelectLanguage language: RecurrencePickerLanguage)
}

class LanguageViewController: UITableViewController {
    var language: RecurrencePickerLanguage = .english
    var delegate: LanguageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(LanguageViewController.cancelButtonTapped))
    }

    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kLanguageViewControllerCellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: kLanguageViewControllerCellID)
        }

        cell?.textLabel?.text = languageStrings[(indexPath as NSIndexPath).row]
        if language == languages[indexPath.row] {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        language = languages[indexPath.row]
        tableView.reloadData()
        dismiss(animated: true, completion: { () -> Void in
            self.delegate?.languageViewController(self, didSelectLanguage: self.language)
        })
    }

}
