//
//  RecoveryPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import WalletUI

protocol RecoveryPresenterProtocol: AnyObject {
    func doneButtonTapped(wordIndices: [Int], words: [String])
}

final class RecoveryPresenter {
    weak var view: RecoveryViewProtocol!
    public var router: RecoveryRouterProtocol!
            
    required init(view: RecoveryViewProtocol) {
        self.view = view
    }
}

// MARK: - RecoveryPresenterProtocol
extension RecoveryPresenter: RecoveryPresenterProtocol {
    func doneButtonTapped(wordIndices: [Int], words: [String]) {
        router.showTest(wordIndices: wordIndices, words: words)
    }
}
