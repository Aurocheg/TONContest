//
//  CameraPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import Foundation

protocol CameraPresenterProtocol: AnyObject {
    func qrCodeFound(_ string: String)
}

final class CameraPresenter {
    weak var view: CameraViewProtocol!
    public var router: CameraRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    
    required init(view: CameraViewProtocol) {
        self.view = view
    }
}

// MARK: - CameraPresenterProtocol
extension CameraPresenter: CameraPresenterProtocol {
    func qrCodeFound(_ string: String) {
        databaseManager.saveTempDeepLink(string)
        router.dismiss()
    }
}
