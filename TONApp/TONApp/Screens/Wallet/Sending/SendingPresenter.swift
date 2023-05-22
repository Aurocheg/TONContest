//
//  SendingPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import Foundation
import SwiftyTON

protocol SendingPresenterProtocol: AnyObject {
    func sendTransaction()
    func doneButtonTapped()
    func viewWalletButtonTapped()
}

final class SendingPresenter {
    weak var view: SendingViewProtocol!
    public var router: SendingRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    private let walletManager = WalletManager.shared
    
    required init(view: SendingViewProtocol) {
        self.view = view
    }
}

// MARK: - SendingPresenterProtocol
extension SendingPresenter: SendingPresenterProtocol {
    func sendTransaction() {
        Task {
            do {
                guard let key = try await KeystoreManager.shared.loadKey() else {
                    throw WalletManagerErrors.keyNotFoundInMemory
                }
                
                let wallet: Wallet
                
                if let currentContract = databaseManager.getCurrentContract() {
                    switch currentContract {
                    case "v4R2":
                        wallet = try await walletManager.getWallet4(key: key, revision: .r2)
                        try await KeystoreManager.shared.save(wallet4: wallet as! Wallet4)
                    case "v3R2":
                        wallet = try await walletManager.getWallet3(key: key, revision: .r2)
                        try await KeystoreManager.shared.save(wallet3: wallet as! Wallet3)
                    case "v3R1":
                        wallet = try await walletManager.getWallet3(key: key, revision: .r1)
                        try await KeystoreManager.shared.save(wallet3: wallet as! Wallet3)
                    default:
                        return
                    }
                } else {
                    wallet = try await walletManager.getWallet4(key: key, revision: .r2)
                    try await KeystoreManager.shared.save(wallet4: wallet as! Wallet4)
                }
                
                let message: Message
                
                switch wallet {
                case is Wallet3:
                    message = try await walletManager.getMessage(
                        wallet: wallet as! Wallet3,
                        with: key,
                        to: view.address,
                        with: String(view.amount),
                        comment: view.comment
                    )
                case is Wallet4:
                    message = try await walletManager.getMessage(
                        wallet: wallet as! Wallet4,
                        with: key,
                        to: view.address,
                        with: String(view.amount),
                        comment: view.comment
                    )
                default:
                    return
                }
                
                try await message.send()
                
                DispatchQueue.main.async {
                    self.view.updateToSuccess(sendWalletAddress: self.view.address)
                }
            } catch {
            }
        }
    }
    
    func doneButtonTapped() {
        router.dismiss()
    }
    
    func viewWalletButtonTapped() {
        router.dismiss()
    }
}
