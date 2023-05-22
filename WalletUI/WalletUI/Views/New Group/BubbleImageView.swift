//
//  BubbleImageView.swift
//  WalletUI
//
//  Created by Aurocheg on 21.05.23.
//

import UIKit

public final class BubbleImageView: UIImageView {
    private let fillColor = UIColor(red: 0.937, green: 0.937, blue: 0.953, alpha: 1)
    
    convenience init() {
        self.init(frame: .zero)
        
        image = messageBubbleImage(incoming: true, fillColor: fillColor, strokeColor: fillColor)
        contentMode = .scaleToFill
    }
    
    private func messageBubbleImage(incoming: Bool, fillColor: UIColor, strokeColor: UIColor) -> UIImage {
        let diameter: CGFloat = 36.0
        let corner: CGFloat = 7.0
        
        return generateImage(CGSize(width: 42.0, height: diameter), contextGenerator: { size, context in
            context.clear(CGRect(origin: CGPoint(), size: size))
            
            context.translateBy(x: size.width / 2.0, y: size.height / 2.0)
            context.scaleBy(x: incoming ? 1.0 : -1.0, y: -1.0)
            context.translateBy(x: -size.width / 2.0 + 0.5, y: -size.height / 2.0 + 0.5)
            
            let lineWidth: CGFloat = 1.0
            context.setFillColor(fillColor.cgColor)
            context.setLineWidth(lineWidth)
            context.setStrokeColor(strokeColor.cgColor)
            
            let _ = try? drawSvgPath(context, path: "M6,17.5 C6,7.83289181 13.8350169,0 23.5,0 C33.1671082,0 41,7.83501688 41,17.5 C41,27.1671082 33.1649831,35 23.5,35 C19.2941198,35 15.4354328,33.5169337 12.4179496,31.0453367 C9.05531719,34.9894816 -2.41102995e-08,35 0,35 C5.972003,31.5499861 6,26.8616169 6,26.8616169 L6,17.5 L6,17.5 ")
            context.strokePath()
            
            let _ = try? drawSvgPath(context, path: "M6,17.5 C6,7.83289181 13.8350169,0 23.5,0 C33.1671082,0 41,7.83501688 41,17.5 C41,27.1671082 33.1649831,35 23.5,35 C19.2941198,35 15.4354328,33.5169337 12.4179496,31.0453367 C9.05531719,34.9894816 -2.41102995e-08,35 0,35 C5.972003,31.5499861 6,26.8616169 6,26.8616169 L6,17.5 L6,17.5 ")
            context.fillPath()
        })!.stretchableImage(withLeftCapWidth: incoming ? Int(corner + diameter / 2.0) : Int(diameter / 2.0), topCapHeight: Int(diameter / 2.0))
    }

}
