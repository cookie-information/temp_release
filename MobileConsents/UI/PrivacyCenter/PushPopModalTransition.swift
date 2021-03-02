//
//  PushPopModalTransition.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 27/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PushModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static let animationDuration = 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        toView.transform = .init(translationX: toView.frame.width, y: 0)
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                toView.transform = .identity
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.animationDuration
    }
}

final class PopModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static let animationDuration = 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                fromView.transform = .init(translationX: fromView.frame.width, y: 0)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.animationDuration
    }
}
