//
//  ImportBadPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import Foundation

protocol ImportBadPresenterProtocol: AnyObject {
    func enterWordsButtonTapped()
    func createWalletButtonTapped()
}

final class ImportBadPresenter {
    weak var view: ImportBadViewProtocol!
    public var router: ImportBadRouterProtocol!
    
    required init(view: ImportBadViewProtocol) {
        self.view = view
    }
}

// MARK: - ImportBadPresenterProtocol
extension ImportBadPresenter: ImportBadPresenterProtocol {
    func enterWordsButtonTapped() {
        router.pop()
    }
    
    func createWalletButtonTapped() {
        router.popToRoot()
    }
}
