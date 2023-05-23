//
//  ReceiveRouter.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import UIKit

protocol ReceiveRouterProtocol: AnyObject {
    func dismiss()
    func showActivityController(image: UIImage, address: String)
}

final class ReceiveRouter {
    weak var viewController: ReceiveViewController!
    private lazy var navigationController = viewController.navigationController
    
    init(viewController: ReceiveViewController) {
        self.viewController = viewController
    }
}

// MARK: - ReceiveRouterProtocol
extension ReceiveRouter: ReceiveRouterProtocol {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
    
    func showActivityController(image: UIImage, address: String) {
        let url = URL(string: address)!

        let activityController = UIActivityViewController(activityItems: [image, url], applicationActivities: nil)
        viewController.present(activityController, animated: true)
    }
}
