//
//  LockRouter.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import Foundation
import WalletUI
import UIKit

protocol LockRouterProtocol: AnyObject {
    func showMain(deepLinkAddress: String?)
    func showSending(address: String, amount: String, comment: String)
    func showPasscode()
    func showRecovery(_ words: [String])
}

final class LockRouter {
    weak var viewController: LockViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: LockViewController) {
        self.viewController = viewController
    }
}

// MARK: - LockRouterProtocol
extension LockRouter: LockRouterProtocol {
    func showMain(deepLinkAddress: String? = nil) {
        let mainVC = MainViewController()
        navigationController?.viewControllers = [mainVC]
        
        if let deepLinkAddress = deepLinkAddress {
            let sendVC = SendViewController(deepLinkAddress: deepLinkAddress)
            let sendNavigationController = UINavigationController(rootViewController: sendVC)
            mainVC.present(sendNavigationController, animated: true)
        }
    }
    
    func showSending(address: String, amount: String, comment: String) {
        let sendingVC = SendingViewController(address: address, amount: amount, comment: comment)
        navigationController?.viewControllers = [sendingVC]
    }
    
    func showPasscode() {
        let passcodeVC = PasscodeViewController()
        navigationController?.pushViewController(passcodeVC, animated: true)
    }
    
    func showRecovery(_ words: [String]) {
        let recoveryVC = RecoveryViewController(words)
        navigationController?.pushViewController(recoveryVC, animated: true)
    }
}
