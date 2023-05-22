//
//  ConfirmPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import WalletUI
import LocalAuthentication

protocol ConfirmPresenterProtocol: AnyObject {
    func getPassword() -> [String]?
    func showBiometry(with type: BiometricType)
    func showImportSuccess()
    func pop()
}

final class ConfirmPresenter {
    weak var view: ConfirmViewProtocol!
    public var router: ConfirmRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    private let walletManager = WalletManager.shared
    
    required init(view: ConfirmViewProtocol) {
        self.view = view
    }
}

private extension ConfirmPresenter {
    func createWallet(completion: @escaping () -> ()) {
        Task(priority: .high) {
            guard let key = try await KeystoreManager.shared.loadKey() else {
                return
            }
            let wallet = try await walletManager.createWallet4(key: key, revision: .r2)
            try await KeystoreManager.shared.save(wallet4: wallet)
            
            completion()
        }
    }
    
    func saveAppState(isWalletCreated: Bool) {
        databaseManager.saveAppState(isWalletCreated: isWalletCreated)
    }
}

// MARK: - ConfirmPresenterProtocol
extension ConfirmPresenter: ConfirmPresenterProtocol {
    func getPassword() -> [String]? {
        databaseManager.getPassword()
    }
    
    func showBiometry(with type: BiometricType) {
        createWallet {
            DispatchQueue.main.async {
                self.saveAppState(isWalletCreated: true)
                self.router.showBiometry(with: type)
            }
        }
    }
    
    func showImportSuccess() {
        saveAppState(isWalletCreated: true)
        router.showImportSuccess()
    }
    
    func pop() {
        router.pop()
    }
}
