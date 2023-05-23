//
//  LockCircleView.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit

public final class LockCircleView: UIView {
    private lazy var fillingView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColors.backgroundContent
        view.layer.borderColor = layer.borderColor
        view.layer.borderWidth = layer.borderWidth
        view.layer.cornerRadius = layer.cornerRadius
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        return view
    }()
    
    public convenience init() {
        self.init(frame: .zero)
        
        layer.borderColor = ThemeColors.backgroundContent.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        addSubview(fillingView)
        
        fillingView.translatesAutoresizingMaskIntoConstraints = false
        fillingView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        fillingView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fillingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        fillingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

public extension LockCircleView {
    func applyFilling() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.fillingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func removeFilling() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.fillingView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    func scaleSelf() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.fillingView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear) {
            self.fillingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
