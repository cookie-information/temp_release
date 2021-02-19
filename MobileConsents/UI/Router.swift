//
//  Router.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func showPrivacyCenter()
    
    func closePrivacyCenter()
}

final class Router: RouterProtocol {
    weak var rootViewController: UIViewController?
    
    func showPrivacyCenter() {
        let viewModel = PrivacyCenterViewModel()
        viewModel.router = self
        let viewController = UINavigationController(rootViewController: PrivacyCenterViewController(viewModel: viewModel))
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            viewController.navigationBar.standardAppearance = appearance
        } else {
            viewController.navigationBar.backgroundColor = .white
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        
        rootViewController?.present(viewController, animated: true)
    }
    
    func closePrivacyCenter() {
        rootViewController?.dismiss(animated: true)
    }
}
