//
//  EnterConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import Foundation

final class EnterConfigurator {
    func configure(with viewController: EnterViewController) {
        let presenter = EnterPresenter(view: viewController)
        let router = EnterRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

