//
//  LockConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import Foundation

final class LockConfigurator {
    func configure(with viewController: LockViewController) {
        let presenter = LockPresenter(view: viewController)
        let router = LockRouter(viewController: viewController)
        let databaseManager = DatabaseManager()
        let authManager = AuthManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.databaseManager = databaseManager
        presenter.authManager = authManager
    }
}

