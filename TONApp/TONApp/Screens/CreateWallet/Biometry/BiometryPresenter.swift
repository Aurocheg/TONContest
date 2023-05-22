//
//  BiometryPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

protocol BiometryPresenterProtocol: AnyObject {
    func skipButtonTapped()
    func enableButtonTapped()
}

final class BiometryPresenter {
    weak var view: BiometryViewProtocol!
    public var router: BiometryRouterProtocol!
    public var authManager: AuthManagerProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    required init(view: BiometryViewProtocol) {
        self.view = view
    }
}

// MARK: - BiometryPresenterProtocol
extension BiometryPresenter: BiometryPresenterProtocol {
    func enableButtonTapped() {
        authManager.canEvaluate { canEvaluate, _, canEvaluateError in
            guard canEvaluate else {
                self.databaseManager.saveFaceIdState(false)
                return
            }
            
            authManager.evaluate { [weak self] success, error in
                guard let strongSelf = self else {
                    self?.databaseManager.saveFaceIdState(false)
                    return
                }
                guard success else {
                    strongSelf.databaseManager.saveFaceIdState(false)
                    return
                }
                
                strongSelf.databaseManager.saveFaceIdState(true)
                strongSelf.router.showReady()
            }
        }
    }
    
    func skipButtonTapped() {
        router.showReady()
    }
}
