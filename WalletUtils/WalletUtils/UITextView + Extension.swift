//
//  UITextView + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 24.04.23.
//

import UIKit

public extension UITextView {    
    func applyPlaceholderStyles() {
        textColor = ThemeColors.textSecondary
    }
    
    func applyTextStyles() {
        textColor = ThemeColors.textPrimary
    }
    
    func resize() {
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        frame.size = CGSize(width: fixedWidth, height: newSize.height)
    }
}

