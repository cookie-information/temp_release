//
//  ConsentItemTableViewCell.swift
//  Example
//
//  Created by Jan Lipmann on 29/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

protocol ConsentItemTableViewCellDelegate: AnyObject {
    func consentItemTableViewCellDidSelectCheckBox(_ cell: ConsentItemTableViewCell)
}

class ConsentItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkbox: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    
    weak var delegate: ConsentItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withConsentItem item: ConsentItem) {
        contentLabel.text = item.translations.first(where: {$0.language == "EN"})?.shortText
    }

    func setCheckboxSelected(_ selected: Bool) {
        checkbox.isSelected = selected
    }
    
    @IBAction private func checkBoxAction() {
        delegate?.consentItemTableViewCellDidSelectCheckBox(self)
    }
}
