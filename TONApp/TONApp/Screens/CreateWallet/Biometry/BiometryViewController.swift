//
//  BiometryViewController.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import UIKit
import WalletUtils
import WalletUI
import LocalAuthentication

protocol BiometryViewProtocol: AnyObject {
    var biometricType: BiometricType { get }
}

final class BiometryViewController: UIViewController {
    // MARK: - Properties
    public var presenter: BiometryPresenterProtocol!
    public var configurator = BiometryConfigurator()
    
    public var biometricType: BiometricType = .none
    
    private let faceImage = UIImage(named: "face-id")
    private let touchImage = UIImage(named: "touch-id")
    
    private let faceTitleText = "Enable Face ID"
    private let touchTitleText = "Enable Touch ID"
    
    private let faceDescriptionText = """
        Face ID allows you to open your wallet faster without having to enter your password.
    """
    private let touchDescriptionText = """
        Touch ID allows you to open your wallet faster without having to enter your password.
    """
    
    private lazy var faceTopConstant = screenSize.height * 0.2
    private lazy var skipBottomConstant = screenSize.height * 0.1
    
    // MARK: - UI Elements
    private let imageView = ImageView()
    private let titleLabel = TitleLabel()
    private let descriptionLabel = DescriptionLabel()
    private let skipButton = NonBackgroundButton(text: "Skip")
    private let enableButton = BackgroundButton()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    init(
        biometricType: BiometricType
    ) {
        self.biometricType = biometricType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension BiometryViewController {
    func setupHierarchy() {
        view.addSubviews(imageView, titleLabel, descriptionLabel, skipButton, enableButton)
    }
    
    func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: faceTopConstant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -58).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        enableButton.translatesAutoresizingMaskIntoConstraints = false
        enableButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -16).isActive = true
        enableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enableButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        enableButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
        
        switch biometricType {
        case .faceID:
            titleLabel.text = faceTitleText
            descriptionLabel.text = faceDescriptionText
            imageView.image = faceImage
            enableButton.setTitle("Enable Face ID", for: .normal)
        case .touchID:
            titleLabel.text = touchTitleText
            descriptionLabel.text = touchDescriptionText
            imageView.image = touchImage
            enableButton.setTitle("Enable Touch ID", for: .normal)
        default: break
        }
    }
    
    func setupTargets() {
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        enableButton.addTarget(self, action: #selector(enableButtonTapped), for: .touchUpInside)
    }
    
    @objc func skipButtonTapped() {
        presenter.skipButtonTapped()
    }
    
    @objc func enableButtonTapped() {
        presenter.enableButtonTapped()
    }
}

// MARK: - FaceViewProtocol
extension BiometryViewController: BiometryViewProtocol {
    
}

