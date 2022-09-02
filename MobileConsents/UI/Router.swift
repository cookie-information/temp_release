//
//  Router.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func closeAll()
}

final class Router: RouterProtocol {
    weak var rootViewController: UIViewController?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    private let accentColor: UIColor
    
    init(consentSolutionManager: ConsentSolutionManagerProtocol, accentColor: UIColor? = nil) {
        self.consentSolutionManager = consentSolutionManager
        self.accentColor = accentColor ?? .popUpButtonEnabled
    }
    
    func showPrivacyPopUp(animated: Bool) {
        let viewModel = PrivacyPopUpViewModel(consentSolutionManager: consentSolutionManager, accentColor: accentColor)
        viewModel.router = self
        
        let viewController = PrivacyPopUpViewController(viewModel: viewModel, accentColor: accentColor)
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }
        rootViewController?.topViewController.present(viewController, animated: animated)
    }
    
    func closeAll() {
        rootViewController?.dismiss(animated: true)
    }
}
