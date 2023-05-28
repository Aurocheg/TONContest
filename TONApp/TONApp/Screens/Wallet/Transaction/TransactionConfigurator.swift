//
//  TransactionConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

final class TransactionConfigurator {
    func configure(with viewController: TransactionViewController) {
        let presenter = TransactionPresenter(view: viewController)
        let router = TransactionRouter(viewController: viewController)
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

