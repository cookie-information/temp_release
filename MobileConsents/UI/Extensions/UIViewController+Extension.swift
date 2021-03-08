//
//  UIViewController+Extension.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 05/03/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

extension UIViewController {
    var topViewController: UIViewController {
        presentedViewController?.topViewController ?? self
    }
}
