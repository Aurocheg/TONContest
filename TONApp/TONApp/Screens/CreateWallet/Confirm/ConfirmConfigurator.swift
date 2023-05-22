//
//  ConfirmConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

final class ConfirmConfigurator {
    func configure(with viewController: ConfirmViewController) {
        let presenter = ConfirmPresenter(view: viewController)
        let router = ConfirmRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

