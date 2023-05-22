//
//  NonBackgroundButton.swift
//  TONApp
//
//  Created by Aurocheg on 29.03.23.
//

import UIKit
import WalletUtils

public final class NonBackgroundButton: UIButton {
    public enum IconAlignment {
        case left
        case right
    }
    
    public init(
        text: String? = nil,
        fontWeight: UIFont.Weight = .semibold,
        fontSize: CGFloat = 17,
        primaryAction: UIAction? = nil,
        icon: UIImage? = nil,
        iconAlignment: IconAlignment = .left
    ) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        setTitleColor(ThemeColors.accent, for: .normal)
        titleLabel?.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        titleLabel?.textAlignment = .center
        
        if let icon = icon {
            setImage(icon.withTintColor(ThemeColors.accent, renderingMode: .alwaysOriginal), for: .normal)
            imageView?.contentMode = .scaleAspectFit
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

            if iconAlignment == .right {
                semanticContentAttribute = .forceRightToLeft
            }
        }
        
        if let action = primaryAction {
            addAction(action, for: .touchUpInside)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
