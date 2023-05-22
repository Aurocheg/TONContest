//
//  CameraRouter.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import UIKit
import WalletUtils

protocol CameraRouterProtocol: AnyObject {
    func dismiss()
}

final class CameraRouter {
    weak var viewController: CameraViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: CameraViewController) {
        self.viewController = viewController
    }
}


// MARK: - CameraRouterProtocol
extension CameraRouter: CameraRouterProtocol {
    func dismiss() {
        var controllerToPush: UIViewController?
        let previousVC = navigationController?.previousViewController
        var shouldPresenting = false
        
        switch previousVC {
        case is MainViewController:
            controllerToPush = SendViewController()
            shouldPresenting = true
        default:
            break
        }
        
        navigationController?.popViewController(animated: true)
        
        if shouldPresenting, let controllerToPush = controllerToPush {
            let navController = UINavigationController(rootViewController: controllerToPush)
            previousVC?.present(navController, animated: true)
        }
    }
}
