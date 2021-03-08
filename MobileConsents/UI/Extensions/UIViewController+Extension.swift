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
    
    func setInteractionEnabled(_ enabled: Bool) {
        (tabBarController ?? navigationController ?? self).view.isUserInteractionEnabled = enabled
    }
}

extension UIViewController {
    func showErrorAlert(retryCallback: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "errorAlert.title".localized,
            message: "errorAlert.message".localized,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(
            title: "errorAlert.retryButtonTitle".localized,
            style: .default,
            handler: { _ in retryCallback() }
        )
        
        alert.addAction(retryAction)
        
        present(alert, animated: true)
    }
}
