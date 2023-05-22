//
//  SendingConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import Foundation

final class SendingConfigurator {
    func configure(with viewController: SendingViewController) {
        let presenter = SendingPresenter(view: viewController)
        let router = SendingRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

