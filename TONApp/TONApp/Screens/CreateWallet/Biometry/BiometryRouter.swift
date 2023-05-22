//
//  FaceRouter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import UIKit

protocol BiometryRouterProtocol: AnyObject {
    func showReady()
}

final class BiometryRouter {
    weak var viewController: BiometryViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: BiometryViewController) {
        self.viewController = viewController
    }
}

// MARK: - BiometryRouterProtocol
extension BiometryRouter: BiometryRouterProtocol {
    func showReady() {
        let readyVC = ReadyViewController()
        navigationController?.pushViewController(readyVC, animated: true)
    }
}
