//
//  MainConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import Foundation

final class MainConfigurator {
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter(view: viewController)
        let router = MainRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        let processTransactionsManager = ProcessTransactionsManager()
        let exchangeManager = ExchangeManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
        presenter.processTransactionsManager = processTransactionsManager
        presenter.exchangeManager = exchangeManager
    }
}

