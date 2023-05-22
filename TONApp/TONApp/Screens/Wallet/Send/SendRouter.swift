//
//  SendRouter.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import SwiftyTON

protocol SendRouterProtocol: AnyObject {
    func showEnter(address: String)
    func showCamera()
    func showCameraPermission()
}

final class SendRouter {
    weak var viewController: SendViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: SendViewController) {
        self.viewController = viewController
    }
}

// MARK: - SendRouterProtocol
extension SendRouter: SendRouterProtocol {
    func showEnter(address: String) {
        let enterVC = EnterViewController(address: address)
        navigationController?.pushViewController(enterVC, animated: true)
    }
    
    func showCamera() {
        let cameraVC = CameraViewController()
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    func showCameraPermission() {
        let cameraPermissionVC = CameraPermissionViewController()
        navigationController?.pushViewController(cameraPermissionVC, animated: true)
    }
}
