//
//  ReadyConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

final class ReadyConfigurator {
    func configure(with viewController: ReadyViewController) {
        let presenter = ReadyPresenter(view: viewController)
        let router = ReadyRouter(viewController: viewController)
        let lottieManager = LottieManager()
        
        viewController.presenter = presenter
        viewController.lottieManager = lottieManager
        presenter.router = router
    }
}

