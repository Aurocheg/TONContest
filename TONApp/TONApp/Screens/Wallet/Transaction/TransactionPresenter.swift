//
//  TransactionPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation
import SwiftyTON
import WalletEntity

protocol TransactionPresenterProtocol: AnyObject {
    func doneButtonTapped()
    func viewButtonTapped()
    func sendButtonTapped(
        address: String,
        amount: String,
        comment: String?
    )
}

final class TransactionPresenter {
    weak var view: TransactionViewProtocol!
    public var router: TransactionRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    private let walletManager = WalletManager.shared
    
    required init(view: TransactionViewProtocol) {
        self.view = view
    }
}

// MARK: - TransactionPresenterProtocol
extension TransactionPresenter: TransactionPresenterProtocol {
    func doneButtonTapped() {
        router.dismiss()
    }
    
    func viewButtonTapped() {
        
    }
    
    func sendButtonTapped(
        address: String,
        amount: String,
        comment: String? = nil
    ) {
        Task {
            do {
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
                    try await KeystoreManager.shared.save(wallet4: wallet as! Wallet4)
                }
                
                let currentBalance = Double(wallet.contract.info.balance.string(with: .maximum9minimum9))
                var sendingSum = Double(amount)
                
                if let unwrappedSendingSum = sendingSum, let currentBalance = currentBalance {
                    if unwrappedSendingSum > currentBalance {
                        return
                    } else if unwrappedSendingSum == currentBalance {
                        sendingSum = unwrappedSendingSum * 0.99
                    }
                } else {
                    return
                }
                
                guard let sendingSum = sendingSum else {
                    return
                }
                
                let sendingAmountString = String(sendingSum)
                
                let message: Message
                
                switch wallet {
                case is Wallet3:
                    message = try await walletManager.getMessage(
                        wallet: wallet as! Wallet3,
                        with: key,
                        to: address,
                        with: sendingAmountString,
                        comment: comment
                    )
                case is Wallet4:
                    message = try await walletManager.getMessage(
                        wallet: wallet as! Wallet4,
                        with: key,
                        to: address,
                        with: sendingAmountString,
                        comment: comment
                    )
                default:
                    return
                }
                                
                try await message.send()
            }
        }
    }
}
