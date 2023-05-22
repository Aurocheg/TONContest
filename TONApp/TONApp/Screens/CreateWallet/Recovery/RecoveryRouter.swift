//
//  RecoveryRouter.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import WalletUI

protocol RecoveryRouterProtocol: AnyObject {
    func showTest(wordIndices: [Int], words: [String])
}

final class RecoveryRouter {
    weak var viewController: RecoveryViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: RecoveryViewController) {
        self.viewController = viewController
    }
}

// MARK: - RecoveryRouterProtocol
extension RecoveryRouter: RecoveryRouterProtocol {
    func showTest(wordIndices: [Int], words: [String]) {
        let testVC = TestViewController(wordIndices: wordIndices, words: words)
        navigationController?.pushViewController(testVC, animated: true)
    }
}
