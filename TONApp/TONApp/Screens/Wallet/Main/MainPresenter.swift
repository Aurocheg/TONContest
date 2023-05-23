//
//  MainPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import WalletEntity
import WalletUI
import AVFoundation
import SwiftyTON

protocol MainPresenterProtocol: AnyObject {
    var address: String? { get }
    var balance: Double? { get }
    var transactions: [TransactionEntity] { get }
    
    func loadWallet()
    func refreshWallet()
    
    func scanButtonTapped()
    func settingButtonTapped()
    func receiveButtonTapped()
    func sendButtonTapped()
    func transactionTapped(cellType: TransactionType, entity: Transaction)
    func presentConnect()
    func presentTransfer()
}

final class MainPresenter {
    weak var view: MainViewProtocol!
    public var router: MainRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    public var processTransactionsManager: ProcessTransactionsManagerProtocol!
    
    public var transactions: [TransactionEntity] = []
    public var address: String?
    public var balance: Double?
    
    private let walletManager = WalletManager.shared

    required init(view: MainViewProtocol) {
        self.view = view
    }
}

private extension MainPresenter {
    func updateTransactions(completion: @escaping (_ isTransactionsEnabled: Bool) -> ()) {
        Task(priority: .high) {
            guard let key = try await KeystoreManager.shared.loadKey() else { return }
            let wallet: Wallet
            
            print(databaseManager.getCurrentContract())
            
            if let currentContract = databaseManager.getCurrentContract() {
                switch currentContract {
                case ContractConstants.v4R2.rawValue:
                    wallet = try await walletManager.getWallet4(key: key, revision: .r2)
                    try await KeystoreManager.shared.save(wallet4: wallet as! Wallet4)
                case ContractConstants.v3R2.rawValue:
                    wallet = try await walletManager.getWallet3(key: key, revision: .r2)
                    try await KeystoreManager.shared.save(wallet3: wallet as! Wallet3)
                case ContractConstants.v3R1.rawValue:
                    wallet = try await walletManager.getWallet3(key: key, revision: .r1)
                    try await KeystoreManager.shared.save(wallet3: wallet as! Wallet3)
                default:
                    return
                }
            } else {
                wallet = try await walletManager.getWallet4(key: key, revision: .r2)
                try await KeystoreManager.shared.save(wallet4: wallet as! Wallet4)
            }
                        
            address = ConcreteAddress(address: wallet.contract.address).displayName
            balance = Double(wallet.contract.info.balance.string(with: .maximum9minimum9))
            
            if let lastTransactionID = wallet.contract.info.lastTransactionID {
                transactions = processTransactionsManager.distributeTransactionsByDate(
                    try await wallet.contract.transactions(startingFrom: lastTransactionID)
                )
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func loadWallet() {
        updateTransactions { isTransactionsEnabled in
            DispatchQueue.main.async {
                if isTransactionsEnabled {
                    self.view.configureViews(with: .transactions)
                } else {
                    self.view.configureViews(with: .created)
                }
                self.view.configureTitleNavBar(with: self.balance)
                self.view.reloadTransactions()
                self.view.updateBalance(with: self.balance)
                self.view.updateAddress(with: self.address)
            }
        }
    }
    
    func refreshWallet() {
        updateTransactions { _ in
            DispatchQueue.main.async {
                self.view.configureTitleNavBar(with: self.balance)
                self.view.updateBalance(with: self.balance)
                self.view.updateAddress(with: self.address)
                self.view.reloadTransactions()
            }
        }
    }

    func scanButtonTapped() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .authorized:
            self.router.showCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.router.showCamera()
                } else {
                    self.router.showCameraPermission()
                }
            }
        case .denied, .restricted:
            self.router.showCameraPermission()
        @unknown default:
            break
        }
    }
    
    func settingButtonTapped() {
        router.showSetting()
    }
    
    func receiveButtonTapped() {
        guard let address = address else {
            return
        }
        router.showReceive(address)
    }
    
    func sendButtonTapped() {
        router.showSend()
    }
    
    func transactionTapped(cellType: TransactionType, entity: Transaction) {
        router.showTransaction(cellType: cellType, entity: entity)
    }
    
    func presentConnect() {
        router.showConnect()
    }
    
    func presentTransfer() {
        router.showTransfer()
    }
}
