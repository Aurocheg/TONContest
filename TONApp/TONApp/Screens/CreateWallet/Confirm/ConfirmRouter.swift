//
//  ConfirmRouter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import WalletUI
import LocalAuthentication

protocol ConfirmRouterProtocol: AnyObject {
    func showBiometry(
        with type: BiometricType
    )
    func showReady()
    func showImportSuccess()
    func pop()
}

final class ConfirmRouter {
    weak var viewController: ConfirmViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ConfirmViewController) {
        self.viewController = viewController
    }
}

// MARK: - ConfirmRouterProtocol
extension ConfirmRouter: ConfirmRouterProtocol {
    func showBiometry(
        with type: BiometricType
    ) {
        let biometryVC = BiometryViewController(
            biometricType: type
        )
        biometryVC.biometricType = type
        navigationController?.pushViewController(biometryVC, animated: true)
    }
    
    func showReady() {
        let readyVC = ReadyViewController()
        navigationController?.pushViewController(readyVC, animated: true)
    }
    
    func showImportSuccess() {
        let importSuccessVC = ImportSuccessViewController()
        navigationController?.pushViewController(importSuccessVC, animated: true)
    }
    
    func pop() {
        let settingVC = SettingViewController()
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
}
