//
//  UIStackView + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
    
    func removeArrangedSubviews(_ views: UIView...) {
        views.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
