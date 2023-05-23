//
//  ReadyViewController.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import UIKit
import WalletUI
import Lottie

protocol ReadyViewProtocol: AnyObject {

}

final class ReadyViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ReadyPresenterProtocol!
    public var configurator = ReadyConfigurator()
    public var lottieManager: LottieManagerProtocol!
    
    private let descriptionText = """
        You are all set. Now you have a wallet that only you control — directly, without middlemen or bankers.
    """
    private lazy var diamondTopConstant = screenSize.height * 0.2
    private lazy var viewWalletBottomConstant = screenSize.height * 0.1
    
    // MARK: - UI Elements
    private lazy var diamondView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .start)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Ready to go!")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
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
private extension ReadyViewController {
    func setupHierarchy() {
        view.addSubviews(diamondView, titleLabel, descriptionLabel, viewWalletButton)
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
    }
    
    func setupTargets() {
        viewWalletButton.addTarget(self, action: #selector(viewWalletButtonTapped), for: .touchUpInside)
    }
    
    @objc func viewWalletButtonTapped() {
        presenter.viewWalletButtonTapped()
    }
}

// MARK: - ReadyViewProtocol
extension ReadyViewController: ReadyViewProtocol {
    
}

