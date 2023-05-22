//
//  SendingRouter.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import Foundation

protocol SendingRouterProtocol: AnyObject {
    func dismiss()
}

final class SendingRouter {
    weak var viewController: SendingViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: SendingViewController) {
        self.viewController = viewController
    }
}

// MARK: - Private methods
private extension SendingRouter {
    
}

// MARK: - SendingRouterProtocol
extension SendingRouter: SendingRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
