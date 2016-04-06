//
//  LanguageViewController.swift
//  RecurrencePickerExample
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import RecurrencePicker

let languages: [RecurrencePickerLanguage] = [.English, .SimplifiedChinese, .TraditionalChinese, .Korean, .Japanese]
let languageStrings = ["English", "Simplified Chinese", "Traditional Chinese", "Korean", "Japanese"]
private let kLanguageViewControllerCellID = "LanguageViewControllerCell"

protocol LanguageViewControllerDelegate {
    func languageViewController(controller: LanguageViewController, didSelectLanguage language: RecurrencePickerLanguage)
}

class LanguageViewController: UITableViewController {
    var language: RecurrencePickerLanguage = .English
    var delegate: LanguageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(LanguageViewController.cancelButtonTapped))
    }

    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kLanguageViewControllerCellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: kLanguageViewControllerCellID)
        }

        cell?.textLabel?.text = languageStrings[indexPath.row]
        if language == languages[indexPath.row] {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }

        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        language = languages[indexPath.row]
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate?.languageViewController(self, didSelectLanguage: self.language)
        })
    }

}
