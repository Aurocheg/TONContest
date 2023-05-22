//
//  ReceiveConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import Foundation

final class ReceiveConfigurator {
    func configure(with viewController: ReceiveViewController) {
        let presenter = ReceivePresenter(view: viewController)
        let router = ReceiveRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
    }
}

