//
//  UIViewController + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import UIKit

public extension UIViewController {
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    func makeBackBarButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func changeNavBarBackground(
        to color: UIColor?,
        shadowImage: UIImage? = nil,
        shadowColor: UIColor? = nil
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = shadowImage
        appearance.shadowColor = shadowColor
        appearance.backgroundColor = color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    func changeConstraintOnVisibleKeyboard(
        notification: Notification,
        constraint: NSLayoutConstraint,
        constant: CGFloat = -12
    ) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            view.setNeedsLayout()
            constraint.constant = -keyboardHeight - constant
            view.updateConstraints()
            view.layoutIfNeeded()
        }
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font.pointSize, weight: .semibold)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
