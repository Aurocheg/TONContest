//
//  TransferRouter.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

protocol TransferRouterProtocol: AnyObject {
    func dismiss()
}

final class TransferRouter {
    weak var viewController: TransferViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: TransferViewController) {
        self.viewController = viewController
    }
}

// MARK: - TransferRouterProtocol
extension TransferRouter: TransferRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
