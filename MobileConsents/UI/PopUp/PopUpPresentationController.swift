//
//  PopUpPresentationController.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 18/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpPresentationController: UIPresentationController {
    override var shouldPresentInFullscreen: Bool { false }
    
    override var shouldRemovePresentersView: Bool { false }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let superFrame = super.frameOfPresentedViewInContainerView
        let safeAreaInsets = presentingViewController.view.safeAreaInsets
        
        let hInset: CGFloat = 10
        let vInset: CGFloat = 10
        
        return CGRect(
            x: hInset,
            y: safeAreaInsets.top + vInset,
            width: superFrame.width - 2 * hInset,
            height: superFrame.height - safeAreaInsets.bottom - safeAreaInsets.top - 2 * vInset
        )
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .popUpOverlay
        presentedView?.layer.cornerRadius = 5
    }
}
