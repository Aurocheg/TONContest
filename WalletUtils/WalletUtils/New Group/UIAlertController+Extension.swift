//
//  UIAlertController + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit

private func createAlertAction(
    alert: UIAlertController,
    with title: String,
    style: UIAlertAction.Style,
    isPrefferedAction: Bool = false,
    handler: ((UIAlertAction) -> Void)? = nil
) {
    let action = UIAlertAction(title: title, style: style) { action in
        handler?(action)
    }
    alert.addAction(action)
    
    if isPrefferedAction {
        alert.preferredAction = action
    }
}

public extension UIAlertController {
    enum AlertType {
        case tooFastRecovery
        case tooFastRecoveryDouble
        case incorrectWords
        case error
        
        var title: String {
            switch self {
            case .tooFastRecovery:
                return "Sure done?"
            case .tooFastRecoveryDouble:
                return "Sure done?"
            case .incorrectWords:
                return "Incorrect words"
            case .error:
                return "Error"
            }
        }
        
        var message: String {
            switch self {
            case .tooFastRecovery:
                return "You didn’t have enough time to write these words down."
            case .tooFastRecoveryDouble:
                return "You didn’t have enough time to write these words down."
            case .incorrectWords:
                return "The secret words you have entered do not match the ones in the list."
            default:
                return "There's an error."
            }
        }
    }
    static func makeAlert(
        with type: AlertType,
        style: UIAlertController.Style = .alert,
        firstCompletion: (() -> Void)? = nil,
        secondCompletion: (() -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(title: type.title, message: type.message, preferredStyle: style)
        
        switch type {
        case .tooFastRecovery:
            createAlertAction(alert: alertController, with: "OK, sorry", style: .default, isPrefferedAction: true) { _ in
                firstCompletion?()
            }
        case .tooFastRecoveryDouble:
            createAlertAction(alert: alertController, with: "OK, sorry                                    ", style: .default, isPrefferedAction: true) { _ in
                firstCompletion?()
            }
            createAlertAction(alert: alertController, with: "Skip", style: .default) { _ in
                secondCompletion?()
            }
        case .incorrectWords:
            createAlertAction(alert: alertController, with: "See words", style: .default) { _ in
                firstCompletion?()
            }
            createAlertAction(alert: alertController, with: "Try again", style: .default) { _ in
                secondCompletion?()
            }
        case .error:
            createAlertAction(alert: alertController, with: "OK", style: .default) { _ in
                firstCompletion?()
            }
        }
        
        return alertController
    }
}
