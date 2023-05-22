//
//  SettingConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import Foundation

final class SettingConfigurator {
    func configure(with viewController: SettingViewController) {
        let presenter = SettingPresenter(view: viewController)
        let router = SettingRouter(viewController: viewController)
        let databaseManager = DatabaseManager()
        let authManager = AuthManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.authManager = authManager
        presenter.databaseManager = databaseManager
    }
}

