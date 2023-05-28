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
    
    func checkForNetwork()
    func loadWallet()
    func refreshWallet()
    func getExchanges(completion: @escaping (_ success: Bool) -> Void)
    func handleCurrencyChanged()
    
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
    public var exchangeManager: ExchangeManagerProtocol!
    
    private let walletManager = WalletManager.shared
    private let connectionService = ConnectionService.shared
    
    private var isWalletLoaded = false
    
    public var address: String?
    public var balance: Double?
    public var transactions: [TransactionEntity] = []
    private var exchanges: ExchangeEntity?
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
}

private extension MainPresenter {
    func updateTransactions(completion: @escaping (_ isTransactionsEnabled: Bool) -> ()) {
        Task(priority: .high) {
            guard let key = try await KeystoreManager.shared.loadKey() else { return }
            let wallet: Wallet
                        
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
            
            isWalletLoaded = true
                        
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
    
    func handleSuccessExchange() {
        guard let balance = balance else {
            return
        }
        guard let currentCurrency = databaseManager.getCurrentCurrency() else {
            return
        }
        guard let exchanges = exchanges else {
            return
        }
        
        let currency: String
        var exchangeValue: Double
        
        switch currentCurrency {
        case CurrencyConstants.dollar.rawValue:
            currency = CurrencyConstants.dollar.indication
            exchangeValue = exchanges.usd * balance
        case CurrencyConstants.euro.rawValue:
            currency = CurrencyConstants.euro.indication
            exchangeValue = exchanges.eur * balance
        case CurrencyConstants.rub.rawValue:
            currency = CurrencyConstants.rub.indication
            exchangeValue = exchanges.rub * balance
        default:
            return
        }
        
        exchangeValue = floor(exchangeValue * 100) / 100.0
        print(exchangeValue)
        
        DispatchQueue.main.async {
            self.view.configureTitleNavBar(
                with: balance,
                currency: currency,
                exchangeValue: exchangeValue
            )
        }
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func checkForNetwork() {
        Task {
            for await isConnected in await connectionService.monitorNetwork() {
                if isConnected {
                    DispatchQueue.main.async {
                        self.view.configureStatus(with: .connecting)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.view.configureStatus(with: .updating)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        self.view.configureStatus(with: .connected)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.configureStatus(with: .waitingForNetwork)
                    }
                }
            }
        }
    }
    
    func loadWallet() {
        updateTransactions { isTransactionsEnabled in
            DispatchQueue.main.async {
                if isTransactionsEnabled {
                    self.view.configureViews(with: .transactions)
                } else {
                    self.view.configureViews(with: .created)
                }
                self.view.reloadTransactions()
                self.view.updateBalance(with: self.balance)
                self.view.updateAddress(with: self.address)
                
                self.handleCurrencyChanged()
            }
        }
    }
    
    func refreshWallet() {
        isWalletLoaded = false
        updateTransactions { _ in
            DispatchQueue.main.async {
                self.view.updateBalance(with: self.balance)
                self.view.updateAddress(with: self.address)
                self.view.reloadTransactions()
                
                self.handleCurrencyChanged()
            }
        }
    }
    
    func getExchanges(completion: @escaping (_ success: Bool) -> Void) {
        exchangeManager.getCurrenciesExchange { result in
            switch result {
            case .success(let exchanges):
                self.exchanges = exchanges
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func handleCurrencyChanged() {
        self.getExchanges { [weak self] success in
            guard let strongSelf = self else {
                return
            }
            if success {
                strongSelf.handleSuccessExchange()
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
        guard isWalletLoaded else {
            return
        }
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
