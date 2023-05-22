//
//  CongratsRouter.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import WalletUI

protocol CongratsRouterProtocol: AnyObject {
    func showRecovery(_ words: [String])
}

final class CongratsRouter {
    weak var viewController: CongratsViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: CongratsViewController) {
        self.viewController = viewController
    }
}

// MARK: - CongratsRouterProtocol
extension CongratsRouter: CongratsRouterProtocol {
    func showRecovery(_ words: [String]) {
        let recoveryVC = RecoveryViewController(words)
        navigationController?.pushViewController(recoveryVC, animated: true)
    }
}
