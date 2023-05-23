//
//  ImportSuccessViewController.swift
//  TONApp
//
//  Created by Aurocheg on 12.04.23.
//

import UIKit
import WalletUI
import Lottie

protocol ImportSuccessViewProtocol: AnyObject {}

final class ImportSuccessViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ImportSuccessPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public let configurator = ImportSuccessConfigurator()
    
    // MARK: - Constraints
    private lazy var successTopConstant = screenSize.height * 0.2
    private lazy var viewWalletBottomConstant = screenSize.height * 0.1
    
    // MARK: - UI Elements
    private lazy var successView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .congratulations)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Your wallet has just been imported!")
    private let viewWalletButton = BackgroundButton(text: "View my wallet")
    
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
private extension ImportSuccessViewController {
    func setupHierarchy() {
        view.addSubviews(successView, titleLabel, viewWalletButton)
    }
    
    func setupLayout() {
        successView.translatesAutoresizingMaskIntoConstraints = false
        successView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: successTopConstant).isActive = true
        successView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        successView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: successView.bottomAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -146).isActive = true
        
        viewWalletButton.translatesAutoresizingMaskIntoConstraints = false
        
        if screenSize.height < 812 {
            viewWalletButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -viewWalletBottomConstant).isActive = true
        } else {
            viewWalletButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124).isActive = true
        }
        
        viewWalletButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewWalletButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        viewWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }
    
    func setupTargets() {
        viewWalletButton.addTarget(self, action: #selector(viewWalletButtonTapped), for: .touchUpInside)
    }
    
    @objc func viewWalletButtonTapped() {
        presenter.viewWalletButtonTapped()
    }
}

// MARK: - ImportSuccessViewProtocol
extension ImportSuccessViewController: ImportSuccessViewProtocol {}

