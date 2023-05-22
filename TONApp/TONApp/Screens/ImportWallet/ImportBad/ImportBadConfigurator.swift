//
//  ImportBadConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import Foundation

final class ImportBadConfigurator {
    func configure(with viewController: ImportBadViewController) {
        let presenter = ImportBadPresenter(view: viewController)
        let router = ImportBadRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

