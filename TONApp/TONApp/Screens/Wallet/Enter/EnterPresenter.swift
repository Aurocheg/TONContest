//
//  EnterPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import Foundation
import SwiftyTON
import WalletEntity

protocol EnterPresenterProtocol: AnyObject {
    var balance: Double? { get }
    func setupBalance()
    func editButtonTapped()
    func continueButtonTapped(amount: String, address: String)
}

final class EnterPresenter {
    weak var view: EnterViewProtocol!
    public var router: EnterRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    public var balance: Double?
    
    private let walletManager = WalletManager.shared
    
    required init(view: EnterViewProtocol) {
        self.view = view
    }
}

// MARK: - EnterPresenterProtocol
extension EnterPresenter: EnterPresenterProtocol {
    func setupBalance() {
        Task {
            guard let key = try await KeystoreManager.shared.loadKey() else {
                throw WalletManagerErrors.keyNotFoundInMemory
            }
            let wallet: Wallet
                        
            if let currentContract = databaseManager.getCurrentContract() {
                switch currentContract {
                case ContractConstants.v4R2.rawValue:
                    wallet = try await walletManager.getWallet4(key: key, revision: .r2)
                case ContractConstants.v3R2.rawValue:
                    wallet = try await walletManager.getWallet3(key: key, revision: .r2)
                case ContractConstants.v3R1.rawValue:
                    wallet = try await walletManager.getWallet3(key: key, revision: .r1)
                default:
                    return
                }
            } else {
                wallet = try await walletManager.getWallet4(key: key, revision: .r2)
            }
            
            balance = Double(wallet.contract.info.balance.string(with: .maximum9minimum9))
            
            DispatchQueue.main.async {
                self.view.setupSendAll(with: self.balance!)
            }
        }
    }
    
    func editButtonTapped() {
        router.pop()
    }
    
    func continueButtonTapped(amount: String, address: String) {
        guard let balance = balance else {
            return
        }
        guard let doubleAmount = Double(amount) else {
            return
        }
        if doubleAmount <= balance {
            router.showEnterConfirm(amount: amount, address: address)
        } else if doubleAmount == balance {
            router.showEnterConfirm(
                amount: String(Double(doubleAmount) * 0.99),
                address: address
            )
        }
    }
}
