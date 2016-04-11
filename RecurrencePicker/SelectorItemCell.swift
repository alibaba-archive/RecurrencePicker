//
//  SelectorItemCell.swift
//  RecurrencePicker
//
//  Created by Xin Hong on 16/4/7.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal class SelectorItemCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!

    internal private(set) var isItemSelected = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setItemSelected(false)
    }

    internal func setItemSelected(selected: Bool) {
        isItemSelected = selected
        backgroundColor = selected ? tintColor : UIColor.whiteColor()
        textLabel.textColor = selected ? UIColor.whiteColor() : UIColor.blackColor()
    }
}
