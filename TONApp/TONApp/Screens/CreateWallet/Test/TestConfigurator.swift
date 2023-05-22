//
//  TestConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import Foundation

final class TestConfigurator {
    func configure(with viewController: TestViewController) {
        let presenter = TestPresenter(view: viewController)
        let router = TestRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

