//
//  CheckmarkView.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import UIKit

public final class CheckmarkView: UIView {
    private let checkmarkLayer = CAShapeLayer()
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        checkmarkLayer.frame = bounds
        
        drawCheckmark()
        
        layer.addSublayer(checkmarkLayer)
    }
    
    private func drawCheckmark() {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.width * 0.25, y: bounds.height * 0.5))
        path.addLine(to: CGPoint(x: bounds.width * 0.4, y: bounds.height * 0.7))
        path.addLine(to: CGPoint(x: bounds.width * 0.7, y: bounds.height * 0.3))
        
        checkmarkLayer.path = path.cgPath
        
        checkmarkLayer.strokeColor = UIColor.white.cgColor
        checkmarkLayer.lineWidth = 3
        checkmarkLayer.lineCap = .round
        checkmarkLayer.fillColor = UIColor.clear.cgColor
    }
    
    public func animateCheckmark() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        checkmarkLayer.add(animation, forKey: "strokeEndAnimation")
    }
}
