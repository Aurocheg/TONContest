//
//  ConnectRouter.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import Foundation

protocol ConnectRouterProtocol: AnyObject {
    func dismiss()
}

final class ConnectRouter {
    weak var viewController: ConnectViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ConnectViewController) {
        self.viewController = viewController
    }
}

// MARK: - Private methods
private extension ConnectRouter {
    
}

// MARK: - ConnectRouterProtocol
extension ConnectRouter: ConnectRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
