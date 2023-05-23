//
//  MainContentView.swift
//  WalletUI
//
//  Created by Aurocheg on 23.05.23.
//

import UIKit

public final class MainContentView: UIView {
    public convenience init() {
        self.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 15
        backgroundColor = .white
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
