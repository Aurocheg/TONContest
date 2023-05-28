//
//  AddressLabel.swift
//  WalletUI
//
//  Created by Aurocheg on 27.05.23.
//

import UIKit

public final class AddressLabel: UILabel {
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public convenience init(
        text: String? = nil,
        textColor: UIColor = ThemeColors.textOverlay,
        textAlignment: NSTextAlignment = .center,
        fontSize: CGFloat = 17,
        fontWeight: UIFont.Weight = .regular
    ) {
        self.init(frame: .zero)
        
        setupProperties(
            text: text,
            textColor: textColor,
            textAlignment: textAlignment,
            fontSize: fontSize,
            fontWeight: fontWeight
        )
        setupTargets()
    }

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    @objc private func showMenu(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            becomeFirstResponder()
            
            let menuController = UIMenuController.shared
            if !menuController.isMenuVisible {
                let targetRect = bounds
                menuController.showMenu(from: self, rect: targetRect)
            }
        }
    }
}

private extension AddressLabel {
    func setupProperties(
        text: String?,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight
    ) {
        isUserInteractionEnabled = true
        
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        font = .systemFont(ofSize: fontSize, weight: fontWeight)
        
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    func setupTargets() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu(_:))
        )
        addGestureRecognizer(longPressGesture)
    }
}
