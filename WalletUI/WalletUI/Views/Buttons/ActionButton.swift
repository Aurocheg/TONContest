//
//  ActionButton.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import UIKit

public final class ActionButton: UIButton {
    public enum ActionType {
        case gallery
        case flashlight
        
        static let tintColor: UIColor = .black
        
        public var normalImage: UIImage? {
            switch self {
            case .gallery:
                return UIImage(systemName: "photo.on.rectangle.angled")?
                    .withTintColor(Self.tintColor, renderingMode: .alwaysOriginal)
            case .flashlight:
                return UIImage(systemName: "flashlight.off.fill")?
                    .withTintColor(Self.tintColor, renderingMode: .alwaysOriginal)
            }
        }
        
        public var selectedImage: UIImage? {
            switch self {
            case .gallery:
                return UIImage(systemName: "photo.on.rectangle.fill")?
                    .withTintColor(Self.tintColor, renderingMode: .alwaysOriginal)
            case .flashlight:
                return UIImage(systemName: "flashlight.on.fill")?
                    .withTintColor(Self.tintColor, renderingMode: .alwaysOriginal)
            }
        }
        
        var imageInsets: UIEdgeInsets {
            switch self {
            case .gallery:
                return UIEdgeInsets(top: 20, left: 16, bottom: 12, right: 16)
            case .flashlight:
                return UIEdgeInsets(top: 21, left: 16, bottom: 11, right: 16)
            }
        }
    }
    
    public convenience init(with actionType: ActionType) {
        self.init(frame: .zero)
        
        clipsToBounds = true
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        setImage(actionType.normalImage, for: .normal)
        setImage(actionType.selectedImage, for: .selected)
        imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
    }
}
