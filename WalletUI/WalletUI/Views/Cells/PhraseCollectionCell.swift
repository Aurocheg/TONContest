//
//  PhraseCollectionCell.swift
//  TONApp
//
//  Created by Aurocheg on 5.04.23.
//

import UIKit

public final class PhraseCollectionCell: UICollectionViewCell {
    public static let reuseIdentifier = "PhraseCollectionCell"
    
    // MARK: - UI Elements
    public let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        return label
    }()
    
    public let wordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        numberLabel.text = nil
        wordLabel.text = nil
    }
    
    public func alignCell(isSecondColumn: Bool, isDoubleDigit: Bool) {
        let leftNumberConstraint = numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        let leftWordConstraint = wordLabel.leftAnchor.constraint(equalTo: numberLabel.rightAnchor, constant: 6)
        
        let rightWordConstraint = wordLabel.rightAnchor.constraint(equalTo: rightAnchor)
        let rightNumberConstraint = numberLabel.rightAnchor.constraint(equalTo: wordLabel.leftAnchor, constant: -6)
        
        if isDoubleDigit {
            leftNumberConstraint.constant = 0
        }
        
//        if !isSecondColumn {
            leftNumberConstraint.isActive = true
            leftWordConstraint.isActive = true
//        } else {
//            rightWordConstraint.isActive = true
//            rightNumberConstraint.isActive = true
//        }
    }
    
    public func configureCell(_ data: (number: UInt, word: String)?) {
        let currentNumber = data?.number
        let currentWord = data?.word
        
        if let currentNumber = currentNumber {
            numberLabel.text = "\(currentNumber)."
        }
        
        wordLabel.text = currentWord
    }
        
}

// MARK: - Private methods
private extension PhraseCollectionCell {
    func setupHierarchy() {
        contentView.addSubviews(numberLabel, wordLabel)
    }
    
    func setupLayout() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
