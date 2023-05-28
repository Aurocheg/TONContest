//
//  TransactionViewController.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import UIKit
import WalletUI
import WalletEntity
import SwiftyTON
import CryptoSwift

protocol TransactionViewProtocol: AnyObject {}

final class TransactionViewController: UIViewController {
    // MARK: - Properties
    public var presenter: TransactionPresenterProtocol!
    public var configurator = TransactionConfigurator()
    
    private let cellType: TransactionType
    private let entity: Transaction
        
    // MARK: - UI Elements
    private let amountStackView = StackView()
    private let coinImageView = ImageView(image: UIImage(named: "coin-56"))
    private let amountLabel = AmountLabel()
    private let feeLabel = DescriptionLabel(
        textColor: ThemeColors.textSecondary
    )
    private let dateLabel = DescriptionLabel(
        textColor: ThemeColors.textSecondary
    )
    private var messageView: BubbleImageView?
    private var messageLabel: DescriptionLabel?
    private let detailsTableView = TransactionDetailsTableView()
    private let viewButton = NonBackgroundButton(
        text: "View in explorer",
        fontWeight: .regular
    )
    private let sendButton = BackgroundButton(text: "Send TON to this address")
    
    // MARK: - Init
    init(cellType: TransactionType, entity: Transaction) {
        self.cellType = cellType
        self.entity = entity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Transaction"
        
        let doneAction = UIAction { _ in
            self.presenter.doneButtonTapped()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
    }
}

// MARK: - Private methods
private extension TransactionViewController {
    func setupHierarchy() {
        view.addSubviews(amountStackView, feeLabel, dateLabel, detailsTableView, viewButton, sendButton)
        amountStackView.addArrangedSubviews(coinImageView, amountLabel)
    }
    
    func setupLayout() {
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        amountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        amountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        amountStackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        feeLabel.topAnchor.constraint(equalTo: amountStackView.bottomAnchor, constant: 6).isActive = true
        feeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: feeLabel.bottomAnchor, constant: 4).isActive = true
        
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        if let message = entity.in?.body {
            switch message {
            case .text(let value):
                makeMessage(with: value)
                
                guard let messageView = messageView else { return }
                detailsTableView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 24).isActive = true
            default:
                detailsTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
            }
        } else {
            detailsTableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
        }
        
        detailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailsTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true
        
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        viewButton.topAnchor.constraint(equalTo: detailsTableView.bottomAnchor, constant: 11).isActive = true
        viewButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = .white
        view.applyMaskedCorners(with: 10)
        
        var amount: Double?
        var fees: Decimal?
        
        switch cellType {
        case .incoming:
            amount = Double(entity.in?.value.string(with: .maximum9minimum9) ?? "0.0")
            fees = entity.in?.fees.value.fromNano()
        case .outgoing:
            if !entity.out.isEmpty {
                amount = Double(entity.out[0].value.string(with: .maximum9minimum9))
                fees = entity.out[0].fees.value.fromNano()
            }
        }
        
        if let amount = amount {
            amountLabel.configureAttributedString(with: .large, amount: amount)
        }
        amountLabel.textColor = cellType.sumLabelColor
        
        if let fees = fees {
            feeLabel.text = "\(fees) transaction fee"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: entity.date)
        
        if let year = components.year,
           let month = components.month,
           let day = components.day,
           let hour = components.hour,
           let minute = components.minute {
            
            let monthString = DateFormatter().monthSymbols[month - 1]
            
            if minute < 10 {
                dateLabel.text = "\(monthString) \(day), \(year) at \(hour):0\(minute)"
            } else {
                dateLabel.text = "\(monthString) \(day), \(year) at \(hour):\(minute)"
            }
        }
    }
    
    func setupTargets() {
        detailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailsTableCell")
        detailsTableView.dataSource = self
        
        viewButton.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    func makeMessage(with text: String) {
        messageView = BubbleImageView()
        guard let messageView = messageView else { return }

        view.addSubview(messageView)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
        messageView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width - 32).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        messageLabel = DescriptionLabel(text: text, fontSize: 15)
        guard let messageLabel = messageLabel else { return }
        
        messageView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc func viewButtonTapped() {
        presenter.viewButtonTapped()
    }
    
    @objc func sendButtonTapped() {
        switch cellType {
        case .incoming:
            if let inEntity = entity.in,
               let address = inEntity.destinationAccountAddress {
                presenter.sendButtonTapped(
                    address: address.displayName,
                    amount: inEntity.value.string(with: .maximum9minimum9),
                    comment: nil
                )
            }

        case .outgoing:
            if !entity.out.isEmpty,
                let address = entity.out[0].destinationAccountAddress {
                presenter.sendButtonTapped(
                    address: address.displayName,
                    amount: entity.out[0].value.string(with: .maximum9minimum9),
                    comment: nil
                )
            }
        }

    }
}

// MARK: - TransactionViewProtocol
extension TransactionViewController: TransactionViewProtocol {}

// MARK: - UITableViewDataSource
extension TransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableCell") else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true
        contentConfiguration.secondaryTextProperties.font = .systemFont(ofSize: 17)
        contentConfiguration.secondaryTextProperties.color = ThemeColors.textSecondary
        
        switch cellType {
        case .incoming:
            switch indexPath.row {
            case 0:
                contentConfiguration.text = "Sender address"
                
                if let sourceAddress = entity.in?.sourceAccountAddress?.displayName {
                    contentConfiguration.secondaryText = sourceAddress.splitString()
                }
            case 1:
                contentConfiguration.text = "Transaction"
                contentConfiguration.secondaryText = entity.id.hash.hexString().splitString()
            default: break
            }
        case .outgoing:
            switch indexPath.row {
            case 0:
                contentConfiguration.text = "Recipient address"
                
                if !entity.out.isEmpty {
                    if let destinationAddress = entity.out[0].destinationAccountAddress?.displayName {
                        contentConfiguration.secondaryText = destinationAddress.splitString()
                    }
                }
                

            case 1:
                contentConfiguration.text = "Transaction"
                contentConfiguration.secondaryText = entity.id.hash.hexString().splitString()
                print(entity.id.hash.hexString())
            default: break
            }
        }

        cell.contentConfiguration = contentConfiguration

        return cell
    }
}
