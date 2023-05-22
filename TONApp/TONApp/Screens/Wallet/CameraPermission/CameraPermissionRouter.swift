//
//  CameraPermissionRouter.swift
//  TONApp
//
//  Created by Aurocheg on 29.04.23.
//

import Foundation

protocol CameraPermissionRouterProtocol: AnyObject {
    
}

final class CameraPermissionRouter {
    weak var viewController: CameraPermissionViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: CameraPermissionViewController) {
        self.viewController = viewController
    }
}

// MARK: - Private methods
private extension CameraPermissionRouter {
    
}

// MARK: - CameraPermissionRouterProtocol
extension CameraPermissionRouter: CameraPermissionRouterProtocol {
    
}
