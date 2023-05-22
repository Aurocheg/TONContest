//
//  CameraConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import Foundation

final class CameraConfigurator {
    func configure(with viewController: CameraViewController) {
        let presenter = CameraPresenter(view: viewController)
        let router = CameraRouter(viewController: viewController)
        let databaseManager = DatabaseManager()
        
        viewController.presenter = presenter
        presenter.router = router
        presenter.databaseManager = databaseManager
    }
}

