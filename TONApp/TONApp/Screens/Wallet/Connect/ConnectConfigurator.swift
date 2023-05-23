//
//  ConnectConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import Foundation

final class ConnectConfigurator {
    func configure(with viewController: ConnectViewController) {
        let presenter = ConnectPresenter(view: viewController)
        let router = ConnectRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
    }
}

