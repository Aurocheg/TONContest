//
//  ImportSuccessConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import Foundation

final class ImportSuccessConfigurator {
    func configure(with viewController: ImportSuccessViewController) {
        let presenter = ImportSuccessPresenter(view: viewController)
        let router = ImportSuccessRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

