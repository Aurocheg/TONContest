//
//  AmountTextField.swift
//  TONApp
//
//  Created by Aurocheg on 22.04.23.
//

import UIKit

public final class AmountTextField: UITextField {
    public convenience init() {
        self.init(frame: .zero)
        
        placeholder = "0"
        keyboardType = .decimalPad
        font = .systemFont(ofSize: 48, weight: .semibold)
        textColor = .black
    }
}
