//
//  SendPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import Foundation
import AVFoundation
import WalletEntity
import SwiftyTON

protocol SendPresenterProtocol: AnyObject {
    var recentTransactions: [RecentTransactionEntity]? { get }
    func pasteQrDeepLinkIfNeeded()
    func pasteDeepLinkAddress(address: String?)
    func scanButtonTapped()
    func getRecentTransactions()
    func continueButtonTapped(address: String)
}

final class SendPresenter {
    weak var view: SendViewProtocol!
    public var router: SendRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    public var recentTransactions: [RecentTransactionEntity]?
        
    required init(view: SendViewProtocol) {
        self.view = view
    }
}

private extension SendPresenter {
    func changeSnackbarVisibility() {
        DispatchQueue.main.async {
            self.view.changeSnackbarVisibility(to: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.view.changeSnackbarVisibility(to: 0)
            }
        }
    }
    
    func changeButtonIndicatorVisibility(isHidden: Bool) {
        DispatchQueue.main.async {
            self.view.changeIndicatorVisibility(isHidden)
        }
    }
}

private extension SendPresenter {
    func parseDeepLinkAddress(address: String) -> String? {
        if let range = address.range(of: "transfer/") {
            return String(address[range.upperBound...])
        }
        return nil
    }
}

// MARK: - SendPresenterProtocol
extension SendPresenter: SendPresenterProtocol {
    func pasteQrDeepLinkIfNeeded() {
        guard let tempAddress = databaseManager.getTempDeepLink() else {
            return
        }
        databaseManager.deleteTempDeepLink()

        let parsedAddress = parseDeepLinkAddress(address: tempAddress)
        
        if let parsedAddress = parsedAddress {
            view.pasteAddress(parsedAddress)
        } else {
            view.pasteAddress(tempAddress)
        }
    }
    
    func pasteDeepLinkAddress(address: String? = nil) {
        guard let address = address else {
            return
        }
        let parsedAddress = parseDeepLinkAddress(address: address)
        
        if let parsedAddress = parsedAddress {
            view.pasteAddress(parsedAddress)
        } else {
            view.pasteAddress(address)
        }
    }
    
    func scanButtonTapped() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .authorized:
            self.router.showCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.router.showCamera()
                } else {
                    self.router.showCameraPermission()
                }
            }
        case .denied, .restricted:
            self.router.showCameraPermission()
        @unknown default:
            break
        }
    }
    
    func getRecentTransactions() {

    }
    
    func continueButtonTapped(address: String) {
        Task {
            guard let _ = await DisplayableAddress(string: address) else {
                self.changeSnackbarVisibility()
                self.changeButtonIndicatorVisibility(isHidden: true)
                return
            }
            
            self.changeButtonIndicatorVisibility(isHidden: true)
            
            DispatchQueue.main.async {
                self.router.showEnter(address: address)
            }
        }
    }
}
