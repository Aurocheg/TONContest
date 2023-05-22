//
//  ImportSuccessRouter.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import WalletUI

protocol ImportSuccessRouterProtocol: AnyObject {
    func showMain()
}

final class ImportSuccessRouter {
    weak var viewController: ImportSuccessViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ImportSuccessViewController) {
        self.viewController = viewController
    }
}

// MARK: - ImportSuccessRouterProtocol
extension ImportSuccessRouter: ImportSuccessRouterProtocol {
    func showMain(
    ) {
        let mainVC = MainViewController()
        navigationController?.viewControllers = [mainVC]
    }
}
