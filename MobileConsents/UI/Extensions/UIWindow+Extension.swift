//
//  UIWindow+Extension.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 05/03/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

extension UIWindow {
    var topViewController: UIViewController? {
        var viewController = rootViewController
        
        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }
        
        return viewController
    }
}
