//
//  TitleLabel.swift
//  TONApp
//
//  Created by Aurocheg on 29.03.23.
//

import UIKit
import WalletUtils

public final class TitleLabel: UILabel {
    public init(
        text: String? = nil,
        fontSize: CGFloat = 28.0,
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor = ThemeColors.textPrimary
    ) {
        super.init(frame: .zero)
        
        self.textColor = textColor
        font = .systemFont(ofSize: fontSize, weight: .semibold)
        self.text = text
        self.textAlignment = textAlignment
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
