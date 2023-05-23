//
//  AmountLabel.swift
//  TONApp
//
//  Created by Aurocheg on 13.04.23.
//

import UIKit

public final class AmountLabel: UILabel {
    public enum LabelType {
        case large
        case small
        
        public var wholeFont: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 48, weight: .semibold)
            case .small:
                return .systemFont(ofSize: 19, weight: .medium)
            }
        }
        
        public var decimalFont: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 30, weight: .semibold)
            case .small:
                return .systemFont(ofSize: 15)
            }
        }
    }
    
    public convenience init(
        amount: Double? = nil,
        with type: LabelType = .large,
        textColor: UIColor = ThemeColors.textOverlay
    ) {
        self.init(frame: .zero)
        
        if let amount = amount {
            configureAttributedString(with: type, amount: amount)
        }
        
        self.textColor = textColor
    }
}

public extension AmountLabel {
    func configureAttributedString(with type: LabelType, amount: Double) {
        let (whole, decimal) = parseAmount(amount: amount)
        
        if decimal == "0" {
            text = whole
            font = type.wholeFont
        } else {
            let attrString = NSMutableAttributedString(string: whole + ".", attributes: [NSAttributedString.Key.font: type.wholeFont])
            let decimalString = NSMutableAttributedString(string: decimal, attributes: [NSAttributedString.Key.font: type.decimalFont])
            attrString.append(decimalString)
            
            attributedText = attrString
        }
    }
}

private extension AmountLabel {
    func parseAmount(amount: Double) -> (String, String) {
        let decimal = amount.truncatingRemainder(dividingBy: 1.0)
        let rounded = Double(round(10000 * decimal) / 10000)
        let decimalString = String(String(rounded).dropFirst(2))
        let wholePart = String(Int(amount.rounded(.down)))
        
        return (wholePart, decimalString)
    }
}
