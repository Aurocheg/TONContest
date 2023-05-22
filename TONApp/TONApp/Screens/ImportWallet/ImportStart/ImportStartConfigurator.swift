//
//  ImportStartConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import Foundation

final class ImportStartConfigurator {
    func configure(with viewController: ImportStartViewController) {
        let presenter = ImportStartPresenter(view: viewController)
        let router = ImportStartRouter(viewController: viewController)
        let lottieManager = LottieManager()
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

