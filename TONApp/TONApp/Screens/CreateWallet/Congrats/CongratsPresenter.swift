//
//  CongratsPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import WalletUI

protocol CongratsPresenterProtocol: AnyObject {
    func proceedButtonTapped(_ words: [String])
}

final class CongratsPresenter {
    weak var view: CongratsViewProtocol!
    public var router: CongratsRouterProtocol!
    
    required init(view: CongratsViewProtocol) {
        self.view = view
    }
}

// MARK: - CongratsPresenterProtocol
extension CongratsPresenter: CongratsPresenterProtocol {
    func proceedButtonTapped(_ words: [String]) {
        router.showRecovery(words)
    }
}
