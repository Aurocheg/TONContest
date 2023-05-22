//
//  PasscodeRouter.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import WalletUI

protocol PasscodeRouterProtocol: AnyObject {
    func showConfirm(
        digits: Int,
        walletType: WalletType
    )
}

final class PasscodeRouter {
    weak var viewController: PasscodeViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: PasscodeViewController) {
        self.viewController = viewController
    }
}

// MARK: - PasscodeRouterProtocol
extension PasscodeRouter: PasscodeRouterProtocol {
    func showConfirm(
        digits: Int,
        walletType: WalletType
    ) {
        let confirmVC = ConfirmViewController(
            numberOfDigits: digits,
            walletType: walletType
        )
        navigationController?.pushViewController(confirmVC, animated: true)
    }
}
