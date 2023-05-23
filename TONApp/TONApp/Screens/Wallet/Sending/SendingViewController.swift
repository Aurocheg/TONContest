//
//  SendingViewController.swift
//  TONApp
//
//  Created by Aurocheg on 25.04.23.
//

import UIKit
import WalletUI
import Lottie
import SwiftyTON

protocol SendingViewProtocol: AnyObject {
    var address: String { get }
    var amount: String { get }
    var comment: String { get }
    func updateToSuccess(sendWalletAddress: String)
}

final class SendingViewController: UIViewController {
    // MARK: - Properties
    public var presenter: SendingPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = SendingConfigurator()
    
    public var address: String
    public var amount: String
    public var comment: String
    
    private let sendingDescription = "Please wait a few seconds for your transaction to be processed…"
    private let doneDescription = "2.2 Toncoin have been sent to"
    
    // MARK: - UI Elements
    private lazy var lottieView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .waitingTon)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Sending TON")
    private lazy var descriptionLabel = DescriptionLabel(text: sendingDescription)
    private let viewWalletButton = BackgroundButton(text: "View my wallet")
    private var walletLabel: DescriptionLabel?
    
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
        changeNavBarBackground(to: ThemeColors.backgroundContent)
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    init(address: String, amount: String, comment: String) {
        self.address = address
        self.amount = amount
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension SendingViewController {
    func setupHierarchy() {
        view.addSubviews(lottieView, titleLabel, descriptionLabel, viewWalletButton)
    }
    
    func setupLayout() {
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height * 0.186).isActive = true
        lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lottieView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        lottieView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: 26).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        viewWalletButton.translatesAutoresizingMaskIntoConstraints = false
        viewWalletButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        viewWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        viewWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        viewWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        viewWalletButton.addTarget(self, action: #selector(viewWalletButtonTapped), for: .touchUpInside)
        
        presenter.sendTransaction()
    }
    
    func createWalletLabel(text: String) {
        walletLabel = DescriptionLabel(text: text)
        guard let walletLabel = walletLabel else { return }
        walletLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        walletLabel.alpha = 0
        
        view.addSubview(walletLabel)
        
        walletLabel.translatesAutoresizingMaskIntoConstraints = false
        walletLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24).isActive = true
        walletLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 39).isActive = true
        walletLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -39).isActive = true
    }
    
    @objc func doneButtonTapped() {
        presenter.doneButtonTapped()
    }
    
    @objc func viewWalletButtonTapped() {
        presenter.viewWalletButtonTapped()
    }
}

// MARK: - SendingViewProtocol
extension SendingViewController: SendingViewProtocol {
    func updateToSuccess(sendWalletAddress: String) {
        createWalletLabel(text: sendWalletAddress)
        UIView.animate(withDuration: 0.3) {
            self.lottieView.stop()
            self.lottieManager.applyAnimation(for: self.lottieView, lottieType: .success)
            
            self.titleLabel.text = "Done!"
            self.descriptionLabel.text = self.doneDescription
            self.walletLabel?.alpha = 1
        }
    }
}

