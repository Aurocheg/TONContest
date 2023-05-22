//
//  ReadyRouter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation
import WalletUI

protocol ReadyRouterProtocol: AnyObject {
    func showMain()
}

final class ReadyRouter {
    weak var viewController: ReadyViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ReadyViewController) {
        self.viewController = viewController
    }
}

// MARK: - ReadyRouterProtocol
extension ReadyRouter: ReadyRouterProtocol {
    func showMain() {
        let mainVC = MainViewController()
        navigationController = NavigationController(rootViewController: mainVC)
        navigationController?.viewControllers = [mainVC]
    }
}
