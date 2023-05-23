//
//  TransferViewController.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import UIKit
import WalletUI

enum TransferViewState {
    case start
    case pending
    case done
}

protocol TransferViewProtocol: AnyObject {
    func setupButton(with state: ConnectViewState)
}

final class TransferViewController: UIViewController {
    // MARK: - Properties
    public var presenter: TransferPresenterProtocol!
    public var configurator = TransferConfigurator()
    
    private lazy var buttonsLeadingConstraint = buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
    private lazy var buttonsTrailingConstraint = buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    private lazy var buttonsHeightConstraint = buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
    private lazy var buttonsBottomConstraint = buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    private lazy var buttonsWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 40)
    private lazy var buttonsCenterConstraint = buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
    // MARK: - UI Elements
    private let amountStackView = StackView()
    private let coinImageView = ImageView(image: UIImage(named: "coin-56"))
    private let amountLabel = AmountLabel(
        amount: 2,
        with: .large,
        textColor: ThemeColors.textPrimary
    )
    private let transferTableView = TransferTableView()
    private let buttonsStackView = StackView(spacing: 10, distribution: .fillEqually)
    private let cancelButton = BackgroundButton(
        text: "Cancel",
        titleColor: ThemeColors.accent,
        background: UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.1)
    )
    private let confirmButton = BackgroundButton(text: "Confirm")
    
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
        
        title = "TON Transfer"
        
        let doneAction = UIAction { _ in
            self.presenter.doneButtonTapped()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
    }
}

// MARK: - Private methods
private extension TransferViewController {
    func setupHierarchy() {
        view.addSubviews(amountStackView, transferTableView, buttonsStackView)
        amountStackView.addArrangedSubviews(coinImageView, amountLabel)
        buttonsStackView.addArrangedSubviews(cancelButton, confirmButton)
    }
    
    func setupLayout() {
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        amountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        amountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 99).isActive = true
        amountStackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        transferTableView.translatesAutoresizingMaskIntoConstraints = false
        transferTableView.topAnchor.constraint(equalTo: amountStackView.bottomAnchor).isActive = true
        transferTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        transferTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        transferTableView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsLeadingConstraint.isActive = true
        buttonsTrailingConstraint.isActive = true
        buttonsBottomConstraint.isActive = true
        buttonsHeightConstraint.isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = .white
        view.applyMaskedCorners(with: 10)
        buttonsStackView.backgroundColor = .clear
    }
    
    func setupTargets() {
        transferTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransferTableCell")
        transferTableView.dataSource = self
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    @objc func confirmButtonTapped() {
        presenter.confirmButtonTapped()
    }
}

// MARK: - TransferViewProtocol
extension TransferViewController: TransferViewProtocol {
    func setupButton(with state: ConnectViewState) {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        switch state {
        case .pending:
            confirmButton.addIndicatorView()
        case .done:
            confirmButton.removeIndicatorView()
            
            UIView.animate(withDuration: 0.6) {
                self.buttonsLeadingConstraint.isActive = false
                self.buttonsTrailingConstraint.isActive = false
                self.buttonsCenterConstraint.isActive = true
                self.buttonsWidthConstraint.isActive = true
                self.buttonsHeightConstraint.constant = 40
                
                self.buttonsStackView.spacing = 0
                self.buttonsStackView.distribution = .equalCentering
                
                self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
                self.confirmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                self.cancelButton.alpha = 0
                self.view.layoutIfNeeded()
                
                self.confirmButton.setTitle(nil, for: .normal)
                self.confirmButton.layer.cornerRadius = 20
            }
            
            confirmButton.addCheckmark()
        default: break
        }
    }
}

// MARK: - UITableViewDataSource
extension TransferViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferTableCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true

        switch indexPath.row {
        case 0:
            contentConfiguration.text = "Recipient"
            contentConfiguration.secondaryText = presenter.recipientAddress
            contentConfiguration.secondaryTextProperties.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        case 1:
            contentConfiguration.text = "Fee"
            contentConfiguration.secondaryText = presenter.fee
            contentConfiguration.secondaryTextProperties.font = .systemFont(ofSize: 17, weight: .regular)
        default: break
        }
        
        cell.contentConfiguration = contentConfiguration
        cell.selectionStyle = .none

        return cell
    }
}
