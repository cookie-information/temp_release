//
//  UIView+Extension.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

extension UIView {
    static func separator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .privacyCenterSeparator
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separator
    }
}
