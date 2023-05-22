//
//  PasscodePresenter.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import Foundation

protocol PasscodePresenterProtocol: AnyObject {
    func savePassword(password: [String])
    func passwordEntered(numberOfDigits: Int, walletType: WalletType)
}

final class PasscodePresenter {
    weak var view: PasscodeViewProtocol!
    public var router: PasscodeRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    required init(view: PasscodeViewProtocol) {
        self.view = view
    }
}

// MARK: - PasscodePresenterProtocol
extension PasscodePresenter: PasscodePresenterProtocol {
    func savePassword(password: [String]) {
        databaseManager.savePassword(password: password)
    }
    
    func passwordEntered(numberOfDigits: Int, walletType: WalletType = .created) {
        router.showConfirm(
            digits: numberOfDigits,
            walletType: walletType
        )
    }
}
