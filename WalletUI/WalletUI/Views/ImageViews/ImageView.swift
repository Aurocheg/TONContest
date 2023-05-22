//
//  ImageView.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import UIKit

public final class ImageView: UIImageView {
    public convenience init(
        contentMode: UIView.ContentMode = .scaleToFill,
        image: UIImage? = nil
    ) {
        self.init(frame: .zero)
        
        self.contentMode = contentMode
        self.image = image
    }
}
