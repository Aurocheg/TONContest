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
        let interactor = ConnectInteractor(presenter: presenter)
        let router = ConnectRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}

