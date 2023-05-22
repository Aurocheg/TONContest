//
//  StartAssembly.swift
//  TONApp
//
//  Created by Aurocheg on 24.03.23.
//

import UIKit

final class StartConfigurator {
    func configure(with viewController: StartViewController) {
        let presenter = StartPresenter(view: viewController)
        let router = StartRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}
