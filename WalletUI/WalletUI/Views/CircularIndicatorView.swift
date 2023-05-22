//
//  CircularIndicatorView.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import UIKit

public final class CircularIndicatorView: UIView {
    private var rotationAngle: CGFloat = 0.0

    private let shapeLayer = CAShapeLayer()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // TODO: fix this
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                radius: min(bounds.width, bounds.height) / 2 - 2,
                                startAngle: -.pi / 2,
                                endAngle: .pi * 2 - .pi / 2,
                                clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.33
        shapeLayer.lineCap = .round
        
        shapeLayer.strokeEnd = 0.6
        
        layer.addSublayer(shapeLayer)

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = rotationAngle
        rotationAnimation.toValue = rotationAngle + CGFloat.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.delegate = self
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

extension CircularIndicatorView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            rotationAngle += CGFloat.pi * 2
        }
    }
}
