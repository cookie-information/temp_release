//
//  Router.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func showPrivacyCenter(animated: Bool)
    func closePrivacyCenter()
    func closeAll()
}

final class Router: RouterProtocol {
    weak var rootViewController: UIViewController?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    private let accentColor: UIColor
    private var privacyCenterTransitionProvider: PrivacyCenterPushPopTransitionProvider?
    
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
    
    func showPrivacyCenter(animated: Bool) {
        let viewModel = PrivacyCenterViewModel(consentSolutionManager: consentSolutionManager)
        viewModel.router = self
        
        let viewController = UINavigationController(rootViewController: PrivacyCenterViewController(viewModel: viewModel))
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .privacyCenterBackground
            viewController.navigationBar.standardAppearance = appearance
        } else {
            viewController.navigationBar.backgroundColor = .privacyCenterBackground
        }
        
        rootViewController?.topViewController.present(viewController, animated: animated)
    }
    
    func closePrivacyCenter() {
        rootViewController?.topViewController.presentingViewController?.dismiss(animated: true) { [weak self] in
            self?.privacyCenterTransitionProvider = nil
        }
    }
    
    func closeAll() {
        rootViewController?.dismiss(animated: true) { [weak self] in
            self?.privacyCenterTransitionProvider = nil
        }
    }
}

private final class PrivacyCenterPushPopTransitionProvider: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PushModalTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PopModalTransition()
    }
}
