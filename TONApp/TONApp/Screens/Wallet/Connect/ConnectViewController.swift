//
//  ConnectViewController.swift
//  TONApp
//
//  Created by Aurocheg on 27.04.23.
//

import UIKit
import WalletUtils
import WalletUI

enum ConnectViewState {
    case start
    case pending
    case done
}

protocol ConnectViewProtocol: AnyObject {
    func setupDescriptionLabel(domen: String, walletAddress: String, walletContract: String)
    func setupButton(with state: ConnectViewState)
}

final class ConnectViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ConnectPresenterProtocol!
    public var configurator = ConnectConfigurator()
    
    private lazy var buttonBottomConstraint = connectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    private lazy var buttonLeadingConstraint = connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
    private lazy var buttonTrailingConstraint = connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    private lazy var buttonHeightConstraint = connectButton.heightAnchor.constraint(equalToConstant: 50)
    
    private lazy var buttonWidthConstraint = connectButton.widthAnchor.constraint(equalToConstant: 40)
    private lazy var buttonCenterConstraint = connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)

    // MARK: - UI Elements
    private let imageView = ImageView(image: UIImage(named: "connect-logo-80"))
    private let titleLabel = TitleLabel(text: "Connect to Fragment", fontSize: 22, textAlignment: .center)
    private let descriptionLabel = DescriptionLabel()
    private let checkLabel = DescriptionLabel(
        text: "Be sure to check the service address before connecting the wallet.",
        textColor: ThemeColors.textSecondary
    )
    private let connectButton = BackgroundButton(text: "Connect wallet")
    
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
        
        let closeAction = UIAction { _ in
            self.presenter.closeButtonTapped()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction)
    }
}

// MARK: - Private methods
private extension ConnectViewController {
    func setupHierarchy() {
        view.addSubviews(imageView, titleLabel, descriptionLabel, checkLabel, connectButton)
    }
    
    func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        buttonBottomConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        buttonTrailingConstraint.isActive = true
        buttonHeightConstraint.isActive = true
        
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        checkLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -24).isActive = true
        checkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        checkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = .white
        view.applyMaskedCorners(with: 10)
    }
    
    func setupTargets() {
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    @objc func connectButtonTapped() {
        presenter.connectButtonTapped()
    }
}

// MARK: - ConnectViewProtocol
extension ConnectViewController: ConnectViewProtocol {
    func setupDescriptionLabel(domen: String, walletAddress: String, walletContract: String) {
        let fullString = NSMutableAttributedString(string: "\(domen) is requesting access to your wallet address ")
        let walletString = NSMutableAttributedString(string: walletAddress)
        walletString.addAttribute(
            .font,
            value: UIFont.monospacedSystemFont(ofSize: 17, weight: .regular),
            range: NSRange(location: 0, length: walletString.length)
        )
        walletString.addAttribute(
            .foregroundColor,
            value: ThemeColors.textSecondary,
            range: NSRange(location: 0, length: walletString.length)
        )
        fullString.append(walletString)

        let contractString = NSAttributedString(string: " " + walletContract + ".")
        fullString.append(contractString)
        
        descriptionLabel.attributedText = fullString
    }
    
    func setupButton(with state: ConnectViewState) {
        connectButton.translatesAutoresizingMaskIntoConstraints = false

        switch state {
        case .start:
            buttonLeadingConstraint.isActive = true
            buttonTrailingConstraint.isActive = true
            buttonBottomConstraint.isActive = true
            buttonHeightConstraint.isActive = true
        case .pending:
            connectButton.addIndicatorView()
        case .done:
            connectButton.removeIndicatorView()
            
            UIView.animate(withDuration: 0.6) {
                self.buttonLeadingConstraint.isActive = false
                self.buttonTrailingConstraint.isActive = false
                self.buttonWidthConstraint.isActive = true
                self.buttonCenterConstraint.isActive = true
                self.buttonHeightConstraint.constant = 40
                self.view.layoutIfNeeded()
                
                self.connectButton.setTitle(nil, for: .normal)
                self.connectButton.layer.cornerRadius = 20
            }
            
            connectButton.addCheckmark()
        }
    }
}

