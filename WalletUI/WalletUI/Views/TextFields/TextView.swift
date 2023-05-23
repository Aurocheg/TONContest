//
//  TextView.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import UIKit

public final class TextView: UITextView {
    public convenience init(
        placeholder: String? = nil,
        background: UIColor = ThemeColors.backgroundGrouped
    ) {
        self.init(frame: .zero)
        
        text = placeholder
        
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        
        textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 42)
        
        backgroundColor = background
        layer.cornerRadius = 10
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        
        font = .systemFont(ofSize: 17)
        
        applyPlaceholderStyles()
    }
}
