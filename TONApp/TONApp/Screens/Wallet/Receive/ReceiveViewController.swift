//
//  ReceiveViewController.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import UIKit
import WalletUI
import QrCode

protocol ReceiveViewProtocol: AnyObject {
    var address: String { get }
    var coinImage: UIImage? { get }
    func addQrCodeAsImage(_ image: UIImage)
}

final class ReceiveViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ReceivePresenterProtocol!
    public var configurator = ReceiveConfigurator()
        
    public var address: String
    public var coinImage = UIImage(named: "coin-56")
    
    private let descriptionText = "Send only Toncoin (TON) to this address. Sending other coins may result in permanent loss."
    private let boldDescriptionText = "Toncoin (TON)"
    
    // MARK: - UI Elements
    private let titleLabel = TitleLabel(text: "Receive Toncoin")
    private let descriptionLabel = DescriptionLabel()
    private let qrCodeImageView = ImageView()
    private let walletLabel = DescriptionLabel()
    private let addressLabel = DescriptionLabel(text: "Your wallet address", textColor: ThemeColors.textSecondary)
    private let shareButton: BackgroundButton = {
        let icon = UIImage(named: "share-24")
        let button = BackgroundButton(text: "Share Wallet Address", icon: icon)
        return button
    }()
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
    
    init(address: String) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReceiveViewController {
    func setupHierarchy() {
        view.addSubviews(titleLabel, descriptionLabel, qrCodeImageView, walletLabel, addressLabel, shareButton)
    }
    
    func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        qrCodeImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50).isActive = true
        qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrCodeImageView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        qrCodeImageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        walletLabel.translatesAutoresizingMaskIntoConstraints = false
        walletLabel.topAnchor.constraint(equalTo: qrCodeImageView.bottomAnchor, constant: 74).isActive = true
        walletLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 69).isActive = true
        walletLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -69).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: walletLabel.bottomAnchor, constant: 6).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
        qrCodeImageView.isUserInteractionEnabled = true
        
        descriptionLabel.attributedText = attributedText(
            withString: descriptionText,
            boldString: boldDescriptionText,
            font: .systemFont(ofSize: 17, weight: .regular)
        )
        walletLabel.text = address
    }
    
    func setupTargets() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrCodeTapped))
        qrCodeImageView.addGestureRecognizer(tapGesture)
        shareButton.addTarget(self, action: #selector(qrCodeTapped), for: .touchUpInside)
        
        presenter.generateQrCode()
    }
    
    @objc func closeButtonTapped() {
        presenter.closeButtonTapped()
    }
    
    @objc func qrCodeTapped() {
        presenter.shareTapped()
    }
}

// MARK: - ReceiveViewProtocol
extension ReceiveViewController: ReceiveViewProtocol {
    func addQrCodeAsImage(_ image: UIImage) {
        qrCodeImageView.image = image
    }
}

