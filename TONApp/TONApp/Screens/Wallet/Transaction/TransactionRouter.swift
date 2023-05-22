//
//  TransactionRouter.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

protocol TransactionRouterProtocol: AnyObject {
    func dismiss()
}

final class TransactionRouter {
    weak var viewController: TransactionViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: TransactionViewController) {
        self.viewController = viewController
    }
}

// MARK: - Private methods
private extension TransactionRouter {
    
}

// MARK: - TransactionRouterProtocol
extension TransactionRouter: TransactionRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
