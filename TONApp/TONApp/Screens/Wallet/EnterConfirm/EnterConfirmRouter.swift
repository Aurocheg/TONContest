//
//  EnterConfirmRouter.swift
//  TONApp
//
//  Created by Aurocheg on 22.04.23.
//

import Foundation

protocol EnterConfirmRouterProtocol: AnyObject {
    func showLock(
        address: String,
        amount: String,
        comment: String
    )
    func showSending(address: String, amount: String, comment: String)
}

final class EnterConfirmRouter {
    weak var viewController: EnterConfirmViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: EnterConfirmViewController) {
        self.viewController = viewController
    }
}

// MARK: - EnterConfirmRouterProtocol
extension EnterConfirmRouter: EnterConfirmRouterProtocol {
    func showLock(
        address: String,
        amount: String,
        comment: String
    ) {
        let lockVC = LockViewController(
            lockType: .beforeSending(address, amount, comment)
        )
        navigationController?.pushViewController(lockVC, animated: true)
    }
    
    func showSending(address: String, amount: String, comment: String) {
        let sendingVC = SendingViewController(
            address: address,
            amount: amount,
            comment: comment
        )
        navigationController?.pushViewController(sendingVC, animated: true)
    }
}
