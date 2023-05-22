//
//  CameraPermissionConfigurator.swift
//  TONApp
//
//  Created by Aurocheg on 29.04.23.
//

import Foundation

final class CameraPermissionConfigurator {
    func configure(with viewController: CameraPermissionViewController) {
        let presenter = CameraPermissionPresenter(view: viewController)
        let router = CameraPermissionRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
    }
}

