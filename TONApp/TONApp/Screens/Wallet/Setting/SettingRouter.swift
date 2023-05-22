//
//  SettingRouter.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import Foundation

protocol SettingRouterProtocol: AnyObject {
    func dismiss()
    func showRecovery(_ words: [String])
    func showPasscode()
    func showLock(lockType: LockType)
}

final class SettingRouter {
    weak var viewController: SettingViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: SettingViewController) {
        self.viewController = viewController
    }
}

// MARK: - SettingRouterProtocol
extension SettingRouter: SettingRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
    
    func showRecovery(_ words: [String]) {
        let recoveryVC = RecoveryViewController(words)
        navigationController?.pushViewController(recoveryVC, animated: true)
    }
    
    func showPasscode() {
        let passcodeVC = PasscodeViewController(walletType: .change)
        navigationController?.pushViewController(passcodeVC, animated: true)
    }
    
    func showLock(lockType: LockType) {
        let lockVC = LockViewController(lockType: lockType)
        navigationController?.pushViewController(lockVC, animated: true)
    }
}
