//
//  ImportSuccessPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import WalletUI

protocol ImportSuccessPresenterProtocol: AnyObject {
    func viewWalletButtonTapped()
}

final class ImportSuccessPresenter {
    weak var view: ImportSuccessViewProtocol!
    public var router: ImportSuccessRouterProtocol!
        
    required init(view: ImportSuccessViewProtocol) {
        self.view = view
    }
}

// MARK: - ImportSuccessPresenterProtocol
extension ImportSuccessPresenter: ImportSuccessPresenterProtocol {
    func viewWalletButtonTapped() {
        router.showMain()
    }
}
