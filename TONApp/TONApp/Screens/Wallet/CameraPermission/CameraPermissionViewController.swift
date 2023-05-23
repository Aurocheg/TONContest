//
//  CameraPermissionViewController.swift
//  TONApp
//
//  Created by Aurocheg on 29.04.23.
//

import UIKit
import WalletUI

protocol CameraPermissionViewProtocol: AnyObject {
    
}

final class CameraPermissionViewController: UIViewController {
    // MARK: - Properties
    public var presenter: CameraPermissionPresenterProtocol!
    public var configurator = CameraPermissionConfigurator()
    
    private let descriptionText = "TON Wallet doesn’t have access to the camera. Please enable camera access to scan QR codes."
    
    // MARK: - UI Elements
    private let titleLabel = TitleLabel(
        text: "No Camera Access",
        textColor: ThemeColors.textOverlay
    )
    private lazy var descriptionLabel = DescriptionLabel(
        text: descriptionText,
        textColor: ThemeColors.textOverlay
    )
    private let openButton = BackgroundButton(text: "Open Settings")
    
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
        
        navigationController?.navigationBar.tintColor = ThemeColors.textOverlay
        changeNavBarBackground(to: UIColor.black)
    }
}

// MARK: - Private methods
private extension CameraPermissionViewController {
    func setupHierarchy() {
        view.addSubviews(titleLabel, descriptionLabel, openButton)
    }
    
    func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height * 0.26).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -screenSize.height * 0.146).isActive = true
        openButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        openButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        
    }
    
    func setupTargets() {
        openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
    }
    
    @objc func openButtonTapped() {
        presenter.openButtonTapped()
    }
}

// MARK: - CameraPermissionViewProtocol
extension CameraPermissionViewController: CameraPermissionViewProtocol {
    
}

