//
//  ImportBadRouter.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import Foundation

protocol ImportBadRouterProtocol: AnyObject {
    func pop()
    func popToRoot()
}

final class ImportBadRouter {
    weak var viewController: ImportBadViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ImportBadViewController) {
        self.viewController = viewController
    }
}

// MARK: - ImportBadRouterProtocol
extension ImportBadRouter: ImportBadRouterProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
