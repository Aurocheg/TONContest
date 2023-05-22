//
//  UITextViewDelegate + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 24.04.23.
//

import UIKit

public extension UITextViewDelegate {
    func removePlaceholder(_ textView: UITextView) {
        if textView.textColor == ThemeColors.textSecondary {
            textView.text = nil
            textView.applyTextStyles()
        }
    }
    
    func addPlaceholder(_ textView: UITextView, text: String) {
        if textView.text.isEmpty {
            textView.text = text
            textView.applyPlaceholderStyles()
        }
    }
}
