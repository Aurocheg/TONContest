//
//  StackVIew.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit

public final class StackView: UIStackView {
    public convenience init(
        spacing: CGFloat = 0,
        aligment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        axis: NSLayoutConstraint.Axis = .horizontal
    ) {
        self.init(frame: .zero)
        
        backgroundColor = .clear
        self.spacing = spacing
        self.alignment = aligment
        self.distribution = distribution
        self.axis = axis
    }
}
