//
//  TransferPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import Foundation

protocol TransferPresenterProtocol: AnyObject {
    var recipientAddress: String? { get }
    var fee: String? { get }
    func doneButtonTapped()
    func cancelButtonTapped()
    func confirmButtonTapped()
}

final class TransferPresenter {
    weak var view: TransferViewProtocol!
    var interactor: TransferInteractorProtocol!
    var router: TransferRouterProtocol!
    var recipientAddress: String?
    var fee: String?
    
    required init(view: TransferViewProtocol) {
        self.view = view
        
        recipientAddress = "UQBFsF6_masda_3tE_yRUoqU96asdxuZSP8577EOvo_1234".splitString()
        fee = "≈0.004 TON"
    }
}

// MARK: - TransferPresenterProtocol
extension TransferPresenter: TransferPresenterProtocol {
    func doneButtonTapped() {
        router.dismiss()
    }
    
    func cancelButtonTapped() {
        router.dismiss()
    }
    
    func confirmButtonTapped() {
        self.view?.setupButton(with: .pending)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.view?.setupButton(with: .done)
        }
    }
}
