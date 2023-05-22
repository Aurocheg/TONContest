//
//  StartRouter.swift
//  TONApp
//
//  Created by Aurocheg on 3.04.23.
//

import Foundation
import WalletUI

protocol StartRouterProtocol: AnyObject {
    func showCongrats(with: [String])
    func showImportStart()
}

final class StartRouter {
    weak var viewController: StartViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: StartViewController) {
        self.viewController = viewController
    }
}

// MARK: - StartRouterProtocol
extension StartRouter: StartRouterProtocol {
    func showCongrats(with words: [String]) {
        let congratsVC = CongratsViewController(words: words)
        navigationController?.pushViewController(congratsVC, animated: true)
    }
    
    func showImportStart() {
        let importStartVC = ImportStartViewController()
        navigationController?.pushViewController(importStartVC, animated: true)
    }
}
