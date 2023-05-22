//
//  TestRouter.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import WalletUI

protocol TestRouterProtocol: AnyObject {
    func showPasscode()
    func dismiss()
}

final class TestRouter {
    weak var viewController: TestViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: TestViewController) {
        self.viewController = viewController
    }
}

// MARK: - Private methods
private extension TestRouter {
    
}

// MARK: - TestRouterProtocol
extension TestRouter: TestRouterProtocol {
    func showPasscode() {
        let passcodeVC = PasscodeViewController()
        navigationController?.pushViewController(passcodeVC, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
