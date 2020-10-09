//
//  SavedItemTableViewCell.swift
//  MobileConsent
//
//  Created by Jan Lipmann on 08/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

class SavedItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var consentItemIdLabel: UILabel!
    @IBOutlet private weak var consentGivenLabel: UILabel!
    
    func setup(with savedConsent: SavedConsent) {
        consentItemIdLabel.text = savedConsent.consentItemId
        consentGivenLabel.text = savedConsent.consentGiven ? "TRUE" : "FALSE"
    }
}
