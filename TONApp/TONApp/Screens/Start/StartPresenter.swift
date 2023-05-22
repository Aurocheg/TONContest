//
//  StartPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 24.03.23.
//

import Foundation
import SwiftyTON

protocol StartPresenterProtocol: AnyObject {
    func createButtonTapped()
    func importButtonTapped()
}

final class StartPresenter {
    weak var view: StartViewProtocol!
    public var router: StartRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    private let walletManager = WalletManager.shared
    
    required init(view: StartViewProtocol) {
        self.view = view
    }
}

extension StartPresenter: StartPresenterProtocol {
    func createButtonTapped() {
        Task {
            do {
                var words: [String]?
                
                if let key = try await KeystoreManager.shared.loadKey() {
                    words = try await walletManager.getWords(key: key)
                } else {
                    let key = try await walletManager.createKey()
                    try await KeystoreManager.shared.save(key: key)
                    
                    words = try await walletManager.getWords(key: key)
                }
                                
                if let words = words {
                    databaseManager.saveWords(words)
                    DispatchQueue.main.async {
                        self.router.showCongrats(with: words)
                    }
                }
            } catch {
//                self.view.showAlert()
            }
        }
        
    }
    
    func importButtonTapped() {
        router.showImportStart()
    }
}
