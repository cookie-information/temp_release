//
//  ConsentItemDetailsTableViewCell.swift
//  Example
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

protocol ConsentItemDetailsTableViewCellDelegate: AnyObject {
    func consentItemDetailsTableViewCellDidSelectCheckBox(_ cell: ConsentItemDetailsTableViewCell)
}

final class ConsentItemDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    
    weak var delegate: ConsentItemDetailsTableViewCellDelegate?

    func setup(withConsentItem item: ConsentItem, language: String) {
        contentLabel.text = item.translations.first(where: { $0.language == language })?.shortText
    }

    func setCheckboxSelected(_ selected: Bool) {
        checkboxButton.isSelected = selected
    }
    
    @IBAction private func checkBoxAction() {
        delegate?.consentItemDetailsTableViewCellDidSelectCheckBox(self)
    }
}
