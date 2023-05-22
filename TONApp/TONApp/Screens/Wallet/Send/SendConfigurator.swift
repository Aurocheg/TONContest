//
//  SendConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import Foundation

final class SendConfigurator {
    func configure(with viewController: SendViewController) {
        let presenter = SendPresenter(view: viewController)
        let router = SendRouter(viewController: viewController)
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

