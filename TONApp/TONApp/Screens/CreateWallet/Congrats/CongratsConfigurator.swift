//
//  CongratsConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import Foundation

final class CongratsConfigurator {
    func configure(with viewController: CongratsViewController) {
        let presenter = CongratsPresenter(view: viewController)
        let router = CongratsRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

