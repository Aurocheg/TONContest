//
//  StartViewController.swift
//  TONApp
//
//  Created by Aurocheg on 24.03.23.
//

import UIKit
import WalletUI
import Lottie

protocol StartViewProtocol: AnyObject {}

final class StartViewController: UIViewController {
    // MARK: - Properties
    public var presenter: StartPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = StartConfigurator()
    
    private lazy var diamondTopConstant = screenSize.height * 0.2
    
    // MARK: - UI Elements
    private lazy var diamondView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .start)
        return view
    }()
    private let titleLabel = TitleLabel(text: "TON Wallet")
    private let descriptionLabel = DescriptionLabel(
        text: "TON Wallet allows you to make fast and secure blockchain-based payments without intermediaries."
    )
    private let createButton = BackgroundButton(text: "Create my wallet")
    private let importButton = NonBackgroundButton(text: "Import existing wallet")
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
}

// MARK: - Private methods
private extension StartViewController {
    func setupHierarchy() {
        view.addSubviews(diamondView, titleLabel, descriptionLabel, createButton, importButton)
    }
    
    func setupLayout() {
        diamondView.translatesAutoresizingMaskIntoConstraints = false
        diamondView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        diamondView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: diamondTopConstant).isActive = true
        diamondView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        diamondView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: diamondView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -58).isActive = true
        importButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        importButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        importButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.bottomAnchor.constraint(equalTo: importButton.topAnchor, constant: -16).isActive = true
        createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        importButton.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
    }
    
    @objc func createButtonTapped() {
        presenter.createButtonTapped()
    }
    
    @objc func importButtonTapped() {
        presenter.importButtonTapped()
    }
}

// MARK: - StartViewProtocol
extension StartViewController: StartViewProtocol {}
