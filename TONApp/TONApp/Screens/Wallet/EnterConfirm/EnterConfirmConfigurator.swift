//
//  EnterConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 22.04.23.
//

import Foundation

final class EnterConfirmConfigurator {
    func configure(with viewController: EnterConfirmViewController) {
        let presenter = EnterConfirmPresenter(view: viewController)
        let router = EnterConfirmRouter(viewController: viewController)
        let authManager = AuthManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.databaseManager = databaseManager
        presenter.authManager = authManager
    }
}

