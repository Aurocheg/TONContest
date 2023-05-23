//
//  LockCollectionCell.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit
import WalletEntity

public final class LockCollectionCell: UICollectionViewCell {
    // MARK: - Properties
    public static let reuseIdentifier = "LockCollectionCell"
    
    // MARK: - UI Elements
    private var numberLabel: UILabel?
    private var textLabel: UILabel?
    private var imageView: ImageView?
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProperties()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension LockCollectionCell {
    func configure(with type: LockCellConfiguration, entity: LockEntity) {
        switch type {
        case .number:
            configureNumber(number: entity.number)
        case .numberWithText:
            configureNumber(number: entity.number)
            configureText(text: entity.text)
        case .faceId, .backspace:
            configureImage(type)
        }
    }
}

private extension LockCollectionCell {
    func setupProperties() {
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
        layer.cornerRadius = 39
    }
    
    func configureNumber(number: Int?) {
        guard let number = number else { return }
        numberLabel = UILabel()
        guard let numberLabel = numberLabel else { return }
        numberLabel.font = .systemFont(ofSize: 37)
        numberLabel.textColor = ThemeColors.textOverlay
        numberLabel.text = String(number)
        
        contentView.addSubview(numberLabel)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    func configureText(text: String?) {
        guard let text = text else { return }
        textLabel = UILabel()
        guard let numberLabel = numberLabel,
              let textLabel = textLabel else {
            return
        }
        textLabel.addCharactersSpacing(spacing: 4, text: text)
        textLabel.textColor = ThemeColors.textOverlay
        
        contentView.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if text == "+" {
            textLabel.font = .systemFont(ofSize: 16, weight: .medium)
            textLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: -10).isActive = true
        } else {
            textLabel.font = .systemFont(ofSize: 10, weight: .medium)
            textLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor).isActive = true
        }
                        
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func configureImage(_ type: LockCellConfiguration) {
        imageView = ImageView(image: type.image)
        guard let imageView = imageView else { return }
        
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}
