//
//  LockPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import Foundation
import WalletEntity

protocol LockPresenterProtocol: AnyObject {
    var lockItems: [[LockEntity]]? { get }
    var userPassword: [String]? { get }
    func setupLockItems()
    func getUserPassword() -> [String]?
    func faceIdTapped(
        lockType: LockType,
        deepLinkAddress: String?
    )
    func finishTyping(
        lockType: LockType,
        passcodeArray: [String],
        deepLinkAddress: String?
    )
}

final class LockPresenter {
    weak var view: LockViewProtocol!
    public var router: LockRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    public var authManager: AuthManagerProtocol!
    
    public var lockItems: [[LockEntity]]?
    public var userPassword: [String]?
    
    required init(view: LockViewProtocol) {
        self.view = view
    }
}

// MARK: - LockPresenterProtocol
extension LockPresenter: LockPresenterProtocol {
    func setupLockItems() {
        lockItems = Lock.getItems()
    }
    
    func getUserPassword() -> [String]? {
        userPassword = databaseManager.getPassword()
        return userPassword
    }
    
    func faceIdTapped(lockType: LockType, deepLinkAddress: String? = nil) {
        authManager.canEvaluate { canEvaluate, _, canEvaluateError in
            guard canEvaluate else {
                return
            }
            
            authManager.evaluate { success, error in
                guard success else {
                    return
                }
                switch lockType {
                case .beforeSending(let address, let amount, let comment):
                    self.router.showSending(address: address, amount: amount, comment: comment)
                case .beforeMain:
                    self.router.showMain(deepLinkAddress: deepLinkAddress)
                case .beforeChangingPassword:
                    self.router.showPasscode()
                case .beforeShowingRecoveryPhrases(let words):
                    self.router.showRecovery(words)
                }
            }
        }
    }
    
    func finishTyping(lockType: LockType, passcodeArray: [String], deepLinkAddress: String? = nil) {
        guard let userPassword = userPassword else {
            view.removeCirclesFilling()
            return
        }
        
        if passcodeArray == userPassword {
            switch lockType {
            case .beforeMain:
                self.router.showMain(deepLinkAddress: deepLinkAddress)
            case .beforeSending(let address, let amount, let comment):
                self.router.showSending(address: address, amount: amount, comment: comment)
            case .beforeChangingPassword:
                self.router.showPasscode()
            case .beforeShowingRecoveryPhrases(let words):
                self.router.showRecovery(words)
            }
        }
    }
}
