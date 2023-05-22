//
//  EnterRouter.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import SwiftyTON

protocol EnterRouterProtocol: AnyObject {
    func pop()
    func showEnterConfirm(amount: String, address: String)
}

final class EnterRouter {
    weak var viewController: EnterViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: EnterViewController) {
        self.viewController = viewController
    }
}

// MARK: - EnterRouterProtocol
extension EnterRouter: EnterRouterProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showEnterConfirm(amount: String, address: String) {
        let enterConfirmVC = EnterConfirmViewController(amount: amount, address: address)
        navigationController?.pushViewController(enterConfirmVC, animated: true)
    }
}
