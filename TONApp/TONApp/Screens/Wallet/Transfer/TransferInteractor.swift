//
//  TransferInteractor.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

protocol TransferInteractorProtocol: AnyObject {
    
}

final class TransferInteractor {
    weak var presenter: TransferPresenterProtocol!
    
    required init(presenter: TransferPresenterProtocol) {
        self.presenter = presenter
    }
}

    // MARK: - Private methods
private extension TransferInteractor {
    
}

    // MARK: - TransferInteractorProtocol
extension TransferInteractor: TransferInteractorProtocol {
    
}

