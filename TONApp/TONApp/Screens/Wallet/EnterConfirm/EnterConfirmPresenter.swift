//
//  EnterConfirmPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 22.04.23.
//

import Foundation
import SwiftyTON

protocol EnterConfirmPresenterProtocol: AnyObject {
    var fee: String? { get }
    func sendButtonTapped(
        address: String,
        amount: String,
        comment: String
    )
}

final class EnterConfirmPresenter {
    weak var view: EnterConfirmViewProtocol!
    public var router: EnterConfirmRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    public var authManager: AuthManagerProtocol!
    
    public var fee: String?
    
    private let walletManager = WalletManager.shared
    
    required init(view: EnterConfirmViewProtocol) {
        self.view = view
        
        fee = "≈ 0.007"
    }
}

// MARK: - EnterConfirmPresenterProtocol
extension EnterConfirmPresenter: EnterConfirmPresenterProtocol {
    func sendButtonTapped(
        address: String,
        amount: String,
        comment: String
    ) {
        authManager.canEvaluate { canEvaluate, _, canEvaluateError in
            guard canEvaluate else {
                self.router.showLock(address: address, amount: amount, comment: comment)
                return
            }
            
            authManager.evaluate { success, error in
                guard success else {
                    self.router.showLock(address: address, amount: amount, comment: comment)
                    return
                }
                
                self.router.showSending(address: address, amount: amount, comment: comment)
            }
        }
    }
}
