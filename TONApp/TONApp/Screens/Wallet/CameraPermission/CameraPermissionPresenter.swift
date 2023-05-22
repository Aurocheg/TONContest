//
//  CameraPermissionPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 29.04.23.
//

import UIKit

protocol CameraPermissionPresenterProtocol: AnyObject {
    func openButtonTapped()
}

final class CameraPermissionPresenter {
    weak var view: CameraPermissionViewProtocol!
    public var router: CameraPermissionRouterProtocol!
    
    required init(view: CameraPermissionViewProtocol) {
        self.view = view
    }
}

    // MARK: - CameraPermissionPresenterProtocol
extension CameraPermissionPresenter: CameraPermissionPresenterProtocol {
    func openButtonTapped() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
