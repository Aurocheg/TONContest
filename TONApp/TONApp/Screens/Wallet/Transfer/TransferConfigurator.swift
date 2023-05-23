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
        let router = TransferRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
    }
}

