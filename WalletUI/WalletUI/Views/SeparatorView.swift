//
//  SeparatorView.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import UIKit

public final class SeparatorView: UIView {
    public convenience init() {
        self.init(frame: .zero)
        
        backgroundColor = ThemeColors.separatorColor
    }
}
