//
//  PasscodeTextField.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit
import WalletUtils

public final class PasscodeTextField: UITextField {
    public var backspaceCalled: (() -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .clear
        textColor = .clear
        
        keyboardType = .decimalPad
        layer.borderWidth = 1
        layer.borderColor = ThemeColors.separatorColor.cgColor
        layer.cornerRadius = 8
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        backspaceCalled?()
    }
}
