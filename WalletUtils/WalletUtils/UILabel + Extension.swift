//
//  UILabel + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit

public extension UILabel {
    func addCharactersSpacing(spacing: CGFloat, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: spacing,
            range: NSMakeRange(0, text.count - 1)
        )
        attributedText = attributedString
    }
}
