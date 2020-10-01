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

class ConsentItemDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkbox: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    
    weak var delegate: ConsentItemDetailsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withConsentItem item: ConsentItem, language: String) {
        contentLabel.text = item.translations.first(where: { $0.language == language })?.shortText
    }

    func setCheckboxSelected(_ selected: Bool) {
        checkbox.isSelected = selected
    }
    
    @IBAction private func checkBoxAction() {
        delegate?.consentItemDetailsTableViewCellDidSelectCheckBox(self)
    }
}
