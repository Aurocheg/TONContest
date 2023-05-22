//
//  ImportStartPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import WalletUI

protocol ImportStartPresenterProtocol: AnyObject {
    func noWordsButtonTapped()
    func continueButtonTapped()
    func seeWordsTapped()
}

final class ImportStartPresenter {
    weak var view: ImportStartViewProtocol!
    public var router: ImportStartRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    private let walletManager = WalletManager.shared
        
    required init(view: ImportStartViewProtocol) {
        self.view = view
    }
}

// MARK: - ImportStartPresenterProtocol
extension ImportStartPresenter: ImportStartPresenterProtocol {
    func noWordsButtonTapped() {
        router.showBad()
    }
    
    func continueButtonTapped() {
        Task {
            do {
                let key = try await walletManager.importWallet(view.enteredWords)
                try await KeystoreManager.shared.save(key: key)
                databaseManager.saveWords(view.enteredWords)
 
                DispatchQueue.main.async {
                    self.router.showPasscode()
                }
            } catch {
                DispatchQueue.main.async {
                    self.view.showAlert()
                }
            }
        }
    }

    func seeWordsTapped() {
        router.dismiss()
    }
}
