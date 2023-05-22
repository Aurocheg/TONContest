//
//  TransactionPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

protocol TransactionPresenterProtocol: AnyObject {
    func doneButtonTapped()
    func viewButtonTapped()
    func sendButtonTapped()
}

final class TransactionPresenter {
    weak var view: TransactionViewProtocol!
    public var router: TransactionRouterProtocol!
    
    required init(view: TransactionViewProtocol) {
        self.view = view
    }
}

// MARK: - TransactionPresenterProtocol
extension TransactionPresenter: TransactionPresenterProtocol {
    func doneButtonTapped() {
        router.dismiss()
    }
    
    func viewButtonTapped() {
        
    }
    
    func sendButtonTapped() {
        
    }
}
