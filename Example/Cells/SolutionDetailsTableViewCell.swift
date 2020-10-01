//
//  SolutionDetailsTableViewCell.swift
//  Example
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit
import MobileConsentsSDK

final class SolutionDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var identifierLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!

    func setup(withConsentsSolution solution: ConsentSolution) {
        identifierLabel.text = solution.id
        versionLabel.text = solution.versionId
    }
}
