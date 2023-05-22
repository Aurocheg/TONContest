//
//  TestPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import WalletUI

protocol TestPresenterProtocol: AnyObject {
    func continueButtonTapped()
    func seeWordsTapped()
}

final class TestPresenter {
    weak var view: TestViewProtocol!
    var router: TestRouterProtocol!
    
    required init(view: TestViewProtocol) {
        self.view = view
    }
}

// MARK: - TestPresenterProtocol
extension TestPresenter: TestPresenterProtocol {
    func continueButtonTapped() {
        router.showPasscode()
    }
    
    func seeWordsTapped() {
        router.dismiss()
    }
}
