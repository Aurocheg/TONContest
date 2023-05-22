//
//  ReceivePresenter.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import UIKit
import WalletUI
import WalletUtils
import QrCode
import SwiftSignalKit

protocol ReceivePresenterProtocol: AnyObject {
    func closeButtonTapped()
    func generateQrCode()
    func shareTapped()
}

final class ReceivePresenter {
    weak var view: ReceiveViewProtocol!
    public var router: ReceiveRouter!
    
    required init(view: ReceiveViewProtocol) {
        self.view = view
    }
}

// MARK: - Private methods
private extension ReceivePresenter {
    func urlForMode(_ address: String) -> String {
        print(walletInvoiceUrl(address: address))
        return walletInvoiceUrl(address: address)
    }
}

// MARK: - ReceivePresenterProtocol
extension ReceivePresenter: ReceivePresenterProtocol {
    func closeButtonTapped() {
        router.dismiss()
    }
    
    func generateQrCode() {
        let _ = (qrCode(string: urlForMode(view.address), color: .black, backgroundColor: .white, icon: .custom(view.coinImage))
        |> map { _, generator -> UIImage? in
            let imageSize = CGSize(width: 768.0, height: 768.0)
            let context = generator(TransformImageArguments(corners: ImageCorners(), imageSize: imageSize, boundingSize: imageSize, intrinsicInsets: UIEdgeInsets(), scale: 1.0))
            return context?.generateImage()
        }
        |> deliverOnMainQueue).start(next: { image in
            guard let image = image else {
                return
            }
            self.view.addQrCodeAsImage(image)
        })
    }
    
    func shareTapped() {
        let _ = (qrCode(string: view.address, color: .black, backgroundColor: .white, icon: .custom(view.coinImage))
        |> map { _, generator -> UIImage? in
            let imageSize = CGSize(width: 768.0, height: 768.0)
            let context = generator(TransformImageArguments(corners: ImageCorners(), imageSize: imageSize, boundingSize: imageSize, intrinsicInsets: UIEdgeInsets(), scale: 1.0))
            return context?.generateImage()
        }
        |> deliverOnMainQueue).start(next: { image in
            guard let image = image else {
                return
            }

            self.router.showActivityController(image: image, address: self.urlForMode(self.view.address))
        })
    }
}
