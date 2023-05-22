//
//  UIView + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 29.03.23.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func transitionElement(with view: UIView?, duration: CGFloat, alpha: CGFloat) {
        guard let view = view else { return }
        
        UIView.transition(with: view, duration: duration) {
            view.alpha = alpha
        }
    }
    
    func applyMaskedCorners(with radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func removeCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 0, height: 0))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    func applyCorners(to: UIRectCorner, with rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: to, cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
}
