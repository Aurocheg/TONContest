//
//  ImportStartRouter.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import WalletUI

protocol ImportStartRouterProtocol: AnyObject {
    func showBad()
    func showPasscode()
    func dismiss()
}

final class ImportStartRouter {
    weak var viewController: ImportStartViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ImportStartViewController) {
        self.viewController = viewController
    }
}

// MARK: - ImportStartRouterProtocol
extension ImportStartRouter: ImportStartRouterProtocol {
    func showBad() {
        let importBadVC = ImportBadViewController()
        navigationController?.pushViewController(importBadVC, animated: true)
    }
    
    func showPasscode() {
        let passcodeVC = PasscodeViewController(walletType: .imported)
        navigationController?.pushViewController(passcodeVC, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
