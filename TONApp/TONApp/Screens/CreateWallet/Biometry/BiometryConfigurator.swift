//
//  FaceConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

final class BiometryConfigurator {
    func configure(with viewController: BiometryViewController) {
        let presenter = BiometryPresenter(view: viewController)
        let router = BiometryRouter(viewController: viewController)
        let authManager = AuthManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.authManager = authManager
        presenter.databaseManager = databaseManager
    }
}

