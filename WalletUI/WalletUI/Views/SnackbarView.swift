//
//  SnackbarView.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import UIKit
import WalletUtils

public final class SnackbarView: UIView {
    // MARK: - Properties
    private let bgColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 0.8)
    private let contentColor = ThemeColors.textOverlay
    
    // MARK: - UI Elements
    private lazy var imageView = ImageView(
        image: UIImage(systemName: "exclamationmark.octagon.fill")?
            .withTintColor(contentColor, renderingMode: .alwaysOriginal)
    )
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = contentColor
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = contentColor
        return label
    }()
    
    public convenience init(title: String, subtitle: String) {
        self.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupProperties(title: title, subtitle: subtitle)
    }
}

public extension SnackbarView {
    func changeVisibility(to alpha: CGFloat) {
        transitionElement(with: self, duration: 0.3, alpha: alpha)
    }
}

private extension SnackbarView {
    func setupHierarchy() {
        addSubviews(imageView, titleLabel, subtitleLabel)
    }
    
    func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    func setupProperties(title: String, subtitle: String) {
        alpha = 0
        layer.cornerRadius = 10
        backgroundColor = bgColor
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
