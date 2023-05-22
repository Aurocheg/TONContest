//
//  ReadyPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

protocol ReadyPresenterProtocol: AnyObject {
    func viewWalletButtonTapped()
}

final class ReadyPresenter {
    weak var view: ReadyViewProtocol!
    public var router: ReadyRouterProtocol!
    
    required init(view: ReadyViewProtocol) {
        self.view = view
    }
}

// MARK: - ReadyPresenterProtocol
extension ReadyPresenter: ReadyPresenterProtocol {
    func viewWalletButtonTapped() {
        router.showMain()
    }
}
