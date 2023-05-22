//
//  EnterPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import Foundation
import SwiftyTON

protocol EnterPresenterProtocol: AnyObject {
    var balance: Double? { get }
    func setupBalance()
    func editButtonTapped()
    func continueButtonTapped(amount: String, address: String)
}

final class EnterPresenter {
    weak var view: EnterViewProtocol!
    public var router: EnterRouterProtocol!
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
            guard let wallet = try await KeystoreManager.shared.loadWallet4() else {
                throw WalletManagerErrors.walletNotFoundInMemory
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
        }
    }
}
