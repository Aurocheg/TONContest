//
//  ConnectInteractor.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import Foundation

protocol ConnectInteractorProtocol: AnyObject {
    
}

final class ConnectInteractor {
    weak var presenter: ConnectPresenterProtocol!
    
    required init(presenter: ConnectPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Private methods
private extension ConnectInteractor {
    
}

// MARK: - ConnectInteractorProtocol
extension ConnectInteractor: ConnectInteractorProtocol {
    
}

