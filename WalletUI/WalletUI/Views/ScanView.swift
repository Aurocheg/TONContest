//
//  ScanView.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import UIKit

public final class ScanView: UIView {
    private let whiteLayer = CAShapeLayer()
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 258, height: 258))
                
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 6)
//        let topLeftCorner = CGPoint(x: bounds.minX, y: bounds.minY)
//        let topRightCorner = CGPoint(x: bounds.maxX, y: bounds.minY)
//        let bottomLeftCorner = CGPoint(x: bounds.minX, y: bounds.maxY)
//        let bottomRightCorner = CGPoint(x: bounds.maxX, y: bounds.maxY)
//        path.move(to: topLeftCorner)
//        path.addLine(to: topRightCorner)
//        path.addLine(to: bottomRightCorner)
//        path.addLine(to: bottomLeftCorner)
//        path.addLine(to: topLeftCorner)
//
//        whiteLayer.path = path.cgPath
//        whiteLayer.fillColor = UIColor.white.cgColor
//        whiteLayer.strokeColor = UIColor.clear.cgColor
        
//        layer.addSublayer(whiteLayer)
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}
