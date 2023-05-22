//
//  MainRouter.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import UIKit
import WalletUI
import WalletEntity
import SwiftyTON

protocol MainRouterProtocol: AnyObject {
    func showSetting()
    func showCamera()
    func showCameraPermission()
    func showReceive(_ address: String)
    func showSend()
    func showTransaction(cellType: TransactionType, entity: Transaction)
    func showConnect()
    func showTransfer()
}

final class MainRouter {
    weak var viewController: MainViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
}

// MARK: - MainRouterProtocol
extension MainRouter: MainRouterProtocol {
    func showSetting() {
        let settingVC = SettingViewController()
        let navigationController = UINavigationController(rootViewController: settingVC)
        viewController.present(navigationController, animated: true)
    }
    
    func showReceive(_ address: String) {
        let receiveVC = ReceiveViewController(address: address)
        let navigationController = UINavigationController(rootViewController: receiveVC)
        viewController.present(navigationController, animated: true)
    }
    
    func showSend() {
        let sendVC = SendViewController()
        let navigationController = UINavigationController(rootViewController: sendVC)
        viewController.present(navigationController, animated: true)
    }
    
    func showTransaction(cellType: TransactionType, entity: Transaction) {
        let transactionVC = TransactionViewController(
            cellType: cellType,
            entity: entity
        )
        let navigationController = UINavigationController(rootViewController: transactionVC)
        let transition = PanelTransition()
        transition.height = 56
        navigationController.transitioningDelegate = transition
        navigationController.modalPresentationStyle = .custom
        
        viewController.present(navigationController, animated: true)
    }
    
    func showConnect() {
        let connectVC = ConnectViewController()
        let navigationController = UINavigationController(rootViewController: connectVC)
        let transition = PanelTransition()
        transition.height = -36
        navigationController.transitioningDelegate = transition
        navigationController.modalPresentationStyle = .custom
        
        viewController.present(navigationController, animated: true)
    }
    
    func showTransfer() {
        let transferVC = TransferViewController()
        let navigationController = UINavigationController(rootViewController: transferVC)
        let transition = PanelTransition()
        transition.height = 0
        navigationController.transitioningDelegate = transition
        navigationController.modalPresentationStyle = .custom
        
        viewController.present(navigationController, animated: true)
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
