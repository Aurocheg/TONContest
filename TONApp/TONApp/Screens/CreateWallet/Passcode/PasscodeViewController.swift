//
//  PasscodeViewController.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit
import WalletUI
import Lottie

enum WalletType {
    case imported
    case created
    case change
}

protocol PasscodeViewProtocol: AnyObject {}

final class PasscodeViewController: UIViewController {
    // MARK: - Properties
    public var presenter: PasscodePresenterProtocol!
    public var configurator = PasscodeConfigurator()
    public var lottieManager: LottieManagerProtocol!
    
    private let descriptionText = "Enter the 4 digits in the passcode."
    private var passcodeArray: [String] = []
    private var isSix = false
    
    private let walletType: WalletType
    
    private lazy var stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: 136)
        
    // MARK: - UI Elements
    private lazy var passcodeView: LottieAnimationView = {
        let view = LottieAnimationView()
        lottieManager.applyAnimation(for: view, lottieType: .password, toProgress: 0.5)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Set a Passcode")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
    private let stackView = StackView(spacing: 16, aligment: .center, distribution: .equalCentering, axis: .horizontal)
    private var textFields: [PasscodeTextField] = []
    private let optionsButton = NonBackgroundButton(text: "Passcode options", fontWeight: .regular)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...3 {
            let textField = PasscodeTextField()
            textField.tag = i
            textFields.append(textField)
        }
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textFields[0].becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configTextFields()
    }
    
    init(walletType: WalletType = .created) {
        self.walletType = walletType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private methods
private extension PasscodeViewController {
    func setupHierarchy() {
        view.addSubviews(passcodeView, titleLabel, descriptionLabel, stackView, optionsButton)
        textFields.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupLayout() {
        passcodeView.translatesAutoresizingMaskIntoConstraints = false
        passcodeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46).isActive = true
        passcodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passcodeView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        passcodeView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackViewWidthConstraint.isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textFields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        }
        
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        optionsButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        optionsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 73).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        optionsButton.showsMenuAsPrimaryAction = true
        let fourCodeAction = UIAction(title: "4-digit code") { _ in
            self.configTextFields()
            self.removeTwoTextFields()
            self.descriptionLabel.text = "Enter the \(self.textFields.count) digits in the passcode."
        }
        let sixCodeAction = UIAction(title: "6-digit code") { _ in
            self.configTextFields()
            self.makeTwoTextFields()
            self.descriptionLabel.text = "Enter the \(self.textFields.count) digits in the passcode."
        }
        optionsButton.menu = UIMenu(children: [sixCodeAction, fourCodeAction])
        
        for (index, textField) in textFields.enumerated() {
            if index > 0 {
                textField.backspaceCalled = {
                    self.onBackspaceAction(textFieldForResponder: self.textFields[index - 1], currentTextField: textField, indexToRemove: index)
                }
            }
        }

        textFields.forEach {
            $0.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            $0.delegate = self
        }
    }
    
    func configTextFields() {
        textFields[0].becomeFirstResponder()
        textFields.forEach {
            $0.backgroundColor = .white
        }
        passcodeArray = []
    }
    
    func makeTwoTextFields() {
        if textFields.count == 4 {
            isSix = true
            view.setNeedsLayout()
            stackViewWidthConstraint.constant = 200
            view.updateConstraints()
            view.layoutIfNeeded()
            
            for _ in 0...1 {
                let textField = PasscodeTextField()
                textFields.append(textField)
                textField.tag = textFields.count - 1
            }
            
            for (index, textField) in textFields.enumerated() {
                if index > 3 {
                    textField.backspaceCalled = {
                        self.onBackspaceAction(textFieldForResponder: self.textFields[index - 1], currentTextField: textField, indexToRemove: index)
                    }
                }
            }
            
            let lastTwoTextFields = textFields.suffix(2)
            lastTwoTextFields.forEach {
                stackView.addArrangedSubview($0)
                
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
                $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
                $0.delegate = self
                $0.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            }
        }
    }
    
    func removeTwoTextFields() {
        if textFields.count == 6 {
            isSix = false
            
            let lastTwoTextFields = textFields.suffix(2)
            lastTwoTextFields.forEach { stackView.removeArrangedSubview($0) }
            
            view.setNeedsLayout()
            stackViewWidthConstraint.constant = 136
            view.updateConstraints()
            view.layoutIfNeeded()
            
            lastTwoTextFields.forEach {
                textFields.removeLast()
                $0.translatesAutoresizingMaskIntoConstraints = true
                NSLayoutConstraint.deactivate($0.constraints)
                $0.delegate = nil
                $0.removeTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
                $0.backspaceCalled = nil
            }
        }
    }
    
    @objc func textFieldChanged(_ sender: PasscodeTextField) {
        if sender != textFields.last {
            changeResponder(currentTF: sender, nextTF: textFields[sender.tag + 1], text: sender.text)
        } else {
            changeResponder(currentTF: sender, nextTF: nil, text: sender.text)
        }
    
        print(passcodeArray)
    }
    
    func changeResponder(currentTF: PasscodeTextField, nextTF: PasscodeTextField?, text: String?) {
        currentTF.backgroundColor = .black
        
        if let nextTF = nextTF {
            if textFields.contains(nextTF) {
                nextTF.becomeFirstResponder()
            } else {
                currentTF.resignFirstResponder()
            }
        }
                
        if let text = text {
            passcodeArray.append(text)
        }
        
        let countOfDigits = passcodeArray.count
        if (countOfDigits == 4 && !isSix) || (countOfDigits == 6 && isSix) {
            presenter.savePassword(password: passcodeArray)
            presenter.passwordEntered(numberOfDigits: passcodeArray.count, walletType: walletType)
        }
    }
    
    func onBackspaceAction(
        textFieldForResponder: UITextField,
        currentTextField: UITextField,
        indexToRemove: Int
    ) {
        textFieldForResponder.becomeFirstResponder()
        textFieldForResponder.backgroundColor = .white
        passcodeArray.remove(at: indexToRemove - 1)
        print(passcodeArray)
    }
}

// MARK: - PasscodeViewController
extension PasscodeViewController: PasscodeViewProtocol {
    
}

// MARK: - UITextFieldDelegate
extension PasscodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
}
