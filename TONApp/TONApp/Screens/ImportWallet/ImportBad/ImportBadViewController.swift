//
//  ImportBadViewController.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import UIKit
import WalletUI
import Lottie

protocol ImportBadViewProtocol: AnyObject {
    
}

final class ImportBadViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ImportBadPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = ImportBadConfigurator()
    
    private let descriptionText = "Without the secret words you can’t restore access to the wallet."
    
    // MARK: - UI Elements
    private lazy var badView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .tooBad)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Too Bad!")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
    private let enterWordsButton = BackgroundButton(text: "Enter 24 secret words")
    private let createWalletButton = NonBackgroundButton(text: "Create a new empty wallet instead")

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
private extension ImportBadViewController {
    func setupHierarchy() {
        view.addSubviews(badView, titleLabel, descriptionLabel, enterWordsButton, createWalletButton)
    }
    
    func setupLayout() {
        badView.translatesAutoresizingMaskIntoConstraints = false
        badView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130).isActive = true
        badView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        badView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        badView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: badView.bottomAnchor, constant: 20).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        createWalletButton.translatesAutoresizingMaskIntoConstraints = false
        createWalletButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -58).isActive = true
        createWalletButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createWalletButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        createWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        enterWordsButton.translatesAutoresizingMaskIntoConstraints = false
        enterWordsButton.bottomAnchor.constraint(equalTo: createWalletButton.topAnchor, constant: -16).isActive = true
        enterWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterWordsButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        enterWordsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        
    }
}

// MARK: - ImportBadViewProtocol
extension ImportBadViewController: ImportBadViewProtocol {}

