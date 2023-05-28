//
//  TransactionTableCell.swift
//  TONApp
//
//  Created by Aurocheg on 15.04.23.
//

import UIKit
import WalletEntity
import SwiftyTON

public final class TransactionTableCell: UITableViewCell {
    // MARK: - Properties
    public static let reuseIdentifier = "TransactionTableCell"

    private let screenSize = UIScreen.main.bounds
    
    // MARK: - UI Elements
    private let coinImageView = ImageView(image: UIImage(named: "coin-icon"))
    private let sumLabel = AmountLabel()
    private let descriptionLabel = DescriptionLabel(textColor: ThemeColors.textSecondary, fontSize: 15)
    private let timeLabel = DescriptionLabel(textColor: ThemeColors.textSecondary, fontSize: 15)
    private let addressLabel: DescriptionLabel = {
        let label = DescriptionLabel()
        label.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    private let feeLabel = DescriptionLabel(textColor: ThemeColors.textSecondary, fontSize: 15)
    private let messageView = BubbleImageView()
    private let messageLabel = DescriptionLabel(fontSize: 15)
    private let separatorView = SeparatorView()

    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        sumLabel.text = nil
        descriptionLabel.text = nil
        timeLabel.text = nil
        addressLabel.text = nil
        feeLabel.text = nil
        messageView.alpha = 0
        messageLabel.text = nil
    }
}

// MARK: - Private methods
private extension TransactionTableCell {
    func setupHierarchy() {
        contentView.addSubviews(coinImageView, sumLabel, descriptionLabel, timeLabel, addressLabel, feeLabel, messageView, separatorView)
        messageView.addSubview(messageLabel)
    }
    
    func setupLayout() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        coinImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.leftAnchor.constraint(equalTo: coinImageView.rightAnchor, constant: 1).isActive = true
        sumLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.bottomAnchor.constraint(equalTo: coinImageView.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: sumLabel.rightAnchor, constant: 3).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: coinImageView.bottomAnchor, constant: 6).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        feeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        feeLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor).isActive = true
        feeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16).isActive = true
        feeLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.topAnchor.constraint(equalTo: feeLabel.bottomAnchor, constant: 8).isActive = true
        messageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        messageView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width - 32).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
    }
    
    func setupProperties() {
        selectionStyle = .default
        let selectedView = UIView()
        selectedView.backgroundColor = ThemeColors.selectionColor
        selectedBackgroundView = selectedView
        
        backgroundColor = .clear
        
        addressLabel.textAlignment = .left
        feeLabel.textAlignment = .left
        messageView.alpha = 0
    }
    
    func setupTargets() {
        
    }
    
    func setupSumLabel(value: Double?) {
        guard let value = value else {
            return
        }
        sumLabel.configureAttributedString(with: .small, amount: value)
    }
    
    func setupTimeLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func setupAddressLabel(address: String?) {
        guard let address = address else {
            return
        }
        addressLabel.text = address.splitString()
    }
    
    func configureMessage(with text: String?) {
        messageView.alpha = 1
        messageLabel.text = text
    }
    
    func addConstraintsToSeparator(relative: UIView) {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: relative.bottomAnchor, constant: 16).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.33).isActive = true
    }
}

// MARK: - Public methods
public extension TransactionTableCell {
    func configureCell(with type: TransactionType, entity: Transaction) {
        sumLabel.textColor = type.sumLabelColor
        descriptionLabel.text = type.descriptionText
        setupTimeLabel(date: entity.date)
        
        switch type {
        case .incoming:
            setupAddressLabel(address: entity.in?.sourceAccountAddress?.displayName)
            
            if let value = entity.in?.value.string(with: .maximum9minimum9) {
                setupSumLabel(value: Double(value))
            }
            
        case .outgoing:
            setupAddressLabel(address: entity.in?.destinationAccountAddress?.displayName)
            
            if !entity.out.isEmpty {
                let value = entity.out[0].value.string(with: .maximum9minimum9)
                setupSumLabel(value: Double(value))
            }
        }
        
        feeLabel.text = "\(entity.storageFee.value.fromNano()) storage fee"

        if let body = entity.in?.body {
            switch body {
            case .text(let value):
                configureMessage(with: value)
                addConstraintsToSeparator(relative: messageView)
            default:
                addConstraintsToSeparator(relative: messageView)
            }
        } else {
            addConstraintsToSeparator(relative: feeLabel)
        }
    }
}
