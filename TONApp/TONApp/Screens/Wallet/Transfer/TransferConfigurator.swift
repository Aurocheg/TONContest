//
//  TransferConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

final class TransferConfigurator {
    func configure(with viewController: TransferViewController) {
        let presenter = TransferPresenter(view: viewController)
        let interactor = TransferInteractor(presenter: presenter)
        let router = TransferRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}

