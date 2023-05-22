//
//  UINavigationController+Extension.swift
//  WalletUtils
//
//  Created by Aurocheg on 21.05.23.
//

import UIKit

public extension UINavigationController {
    public var previousViewController: UIViewController? {
       viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
