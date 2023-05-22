//
//  DescriptionLabel.swift
//  TONApp
//
//  Created by Aurocheg on 29.03.23.
//

import UIKit
import WalletUtils

public final class DescriptionLabel: UILabel {
    public init(
        text: String? = nil,
        textColor: UIColor = ThemeColors.textPrimary,
        fontSize: CGFloat = 17,
        textAlignment: NSTextAlignment = .center,
        indent: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        
        if let indent = indent {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = indent
            
            if let text = text {
                let attributedString = NSAttributedString(string: text, attributes: [.paragraphStyle : paragraphStyle, .backgroundColor: UIColor.white])
                attributedText = attributedString
            }
        } else {
            self.text = text
        }
        
        self.textColor = textColor
        self.textAlignment = textAlignment
        font = .systemFont(ofSize: fontSize)
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
