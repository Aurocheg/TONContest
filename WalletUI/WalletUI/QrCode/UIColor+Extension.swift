//
//  UIColor+Extension.swift
//  WalletUtils
//
//  Created by Aurocheg on 21.05.23.
//

import UIKit

public extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0, green: CGFloat((rgb >> 8) & 0xff) / 255.0, blue: CGFloat(rgb & 0xff) / 255.0, alpha: 1.0)
    }
}
