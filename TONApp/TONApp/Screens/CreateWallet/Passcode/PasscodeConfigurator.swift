//
//  PasscodeConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import Foundation

final class PasscodeConfigurator {
    func configure(with viewController: PasscodeViewController) {
        let presenter = PasscodePresenter(view: viewController)
        let router = PasscodeRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

