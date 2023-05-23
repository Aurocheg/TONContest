//
//  ConnectPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import Foundation

protocol ConnectPresenterProtocol: AnyObject {
    func closeButtonTapped()
    func connectButtonTapped()
    var domen: String? { get }
    var walletContract: String? { get }
    var walletAddress: String? { get }
}

final class ConnectPresenter {
    weak var view: ConnectViewProtocol!
    var router: ConnectRouterProtocol!
    var domen: String?
    var walletAddress: String?
    var walletContract: String?
    
    required init(view: ConnectViewProtocol) {
        self.view = view
        
        domen = "fragment.io"
        walletAddress = "UQBFsF6_masda_3tE_yRUoqU96asdxuZSP8577EOvo_1234"
        walletContract = "v4R2"
        
        guard let domen = domen,
              let walletAddress = walletAddress,
              let walletContract = walletContract else { return }
        
        self.view?.setupDescriptionLabel(
            domen: domen,
            walletAddress: walletAddress.splitString(),
            walletContract: walletContract
        )
    }
}

// MARK: - ConnectPresenterProtocol
extension ConnectPresenter: ConnectPresenterProtocol {
    func closeButtonTapped() {
        router.dismiss()
    }
    
    func connectButtonTapped() {
        self.view?.setupButton(with: .pending)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.view?.setupButton(with: .done)
        }
    }
}
