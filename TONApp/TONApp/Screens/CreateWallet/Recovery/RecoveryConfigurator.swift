//
//  RecoveryConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import Foundation

final class RecoveryConfigurator {
    func configure(with viewController: RecoveryViewController) {
        let presenter = RecoveryPresenter(view: viewController)
        let router = RecoveryRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.lottieManager = lottieManager
        viewController.presenter = presenter
        presenter.router = router
    }
}

