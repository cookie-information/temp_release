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
    
    func closeAll()
}

final class Router: RouterProtocol {
    weak var rootViewController: UIViewController?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    
    private var privacyCenterTransitioningDelegate: PushPopPrivacyCenterTransitioningDelegate?
    
    init(consentSolutionManager: ConsentSolutionManagerProtocol) {
        self.consentSolutionManager = consentSolutionManager
    }
    
    func showPrivacyCenter() {
        let viewModel = PrivacyCenterViewModel(
            consentSolutionManager: consentSolutionManager
        )
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
        
        privacyCenterTransitioningDelegate = PushPopPrivacyCenterTransitioningDelegate()
        viewController.transitioningDelegate = privacyCenterTransitioningDelegate
        
        rootViewController?.present(viewController, animated: true)
    }
    
    func closePrivacyCenter() {
        rootViewController?.dismiss(animated: true) { [weak self] in
            self?.privacyCenterTransitioningDelegate = nil
        }
    }
    
    func closeAll() {
        rootViewController?.presentingViewController?.dismiss(animated: true)
    }
}

private final class PushPopPrivacyCenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PushModalTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PopModalTransition()
    }
}
