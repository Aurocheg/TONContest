//
//  PanelTransition.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    // MARK: - Presentation controller
    private let driver = TransitionDriver()
    
    public var height: CGFloat = 404
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.link(to: presented)
        
        let presentationController = DimmPresentationController(presentedViewController: presented, presenting: presenting ?? source)
        presentationController.height = height
        presentationController.driver = driver
        return presentationController
    }
    
    // MARK: - Animation
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
    
    // MARK: - Interaction
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
}
