//
//  DateHeaderLabel.swift
//  TONApp
//
//  Created by Aurocheg on 15.04.23.
//

import UIKit
import WalletUtils

public final class DateHeaderLabel: UILabel {
    public convenience init(with text: String? = nil, indent: CGFloat = 16) {
        self.init(frame: .zero)
        
        font = .systemFont(ofSize: 17, weight: .semibold)
        textColor = ThemeColors.textPrimary
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        
        if let text = text {
            let attributedString = NSAttributedString(string: text, attributes: [.paragraphStyle : paragraphStyle, .backgroundColor: UIColor.white])
            attributedText = attributedString
        }
    }
}
