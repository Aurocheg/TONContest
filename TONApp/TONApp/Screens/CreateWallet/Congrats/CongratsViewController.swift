//
//  CongratsViewController.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import UIKit
import Lottie
import WalletUtils
import WalletUI

protocol CongratsViewProtocol: AnyObject {}

final class CongratsViewController: UIViewController {
    // MARK: - Properties
    public var presenter: CongratsPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = CongratsConfigurator()
    
    private let words: [String]
    
    private lazy var congratulationsTopConstant = screenSize.height * 0.2
    private lazy var proceedBottomConstant = screenSize.height * 0.1
    private let topDescriptionText = "Your TON Wallet has just been created. Only you control it."
    private let bottomDescriptionText = "To be able to always have access to it, please write down secret words and set up a secure passcode."
    
    // MARK: - UI Elements
    private lazy var congratulationsView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .congratulations)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Congratulations")
    private lazy var topDescriptionLabel = DescriptionLabel(text: topDescriptionText)
    private lazy var bottomDescriptionLabel = DescriptionLabel(text: bottomDescriptionText)
    private let proceedButton = BackgroundButton(text: "Proceed")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    init(words: [String]) {
        self.words = words
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension CongratsViewController {
    func setupHierarchy() {
        view.addSubviews(congratulationsView, titleLabel, topDescriptionLabel, bottomDescriptionLabel, proceedButton)
    }
    
    func setupLayout() {
        congratulationsView.translatesAutoresizingMaskIntoConstraints = false
        congratulationsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        congratulationsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: congratulationsTopConstant).isActive = true
        congratulationsView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        congratulationsView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: congratulationsView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        topDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        topDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        topDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDescriptionLabel.topAnchor.constraint(equalTo: topDescriptionLabel.bottomAnchor, constant: 25).isActive = true
        bottomDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        
        if screenSize.height < 812 {
            proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -proceedBottomConstant).isActive = true
        } else {
            proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124).isActive = true
        }
        
        proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        proceedButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        proceedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
    }
    
    @objc func proceedButtonTapped() {
        presenter.proceedButtonTapped(words)
    }
}

// MARK: - CongratsViewProtocol
extension CongratsViewController: CongratsViewProtocol {}
