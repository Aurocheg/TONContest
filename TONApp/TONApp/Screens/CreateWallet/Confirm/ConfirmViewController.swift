//
//  ConfirmViewController.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import UIKit
import WalletUtils
import WalletUI
import Lottie

protocol ConfirmViewProtocol: AnyObject {
    var numberOfDigits: Int { get }
}

final class ConfirmViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ConfirmPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = ConfirmConfigurator()
    
    public let numberOfDigits: Int
    private let walletType: WalletType
        
    private lazy var stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: 136)
    
    private var isSix: Bool {
        return numberOfDigits == 6
    }
    private lazy var descriptionText = "Enter the \(numberOfDigits) digits in the passcode."
    private var passcodeArray: [String] = []
    
    // MARK: - UI Elements
    private lazy var passcodeView: LottieAnimationView = {
        let view = LottieAnimationView()
        lottieManager.applyAnimationWithProgress(for: view, lottieType: .password, toProgress: 0.5)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Confirm a Passcode")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
    private let stackView = StackView(spacing: 16, aligment: .center, distribution: .equalCentering, axis: .horizontal)
    private var textFields: [PasscodeTextField] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...numberOfDigits - 1 {
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
    
    init(
        numberOfDigits: Int,
        walletType: WalletType = .created
    ) {
        self.numberOfDigits = numberOfDigits
        self.walletType = walletType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ConfirmViewController {
    func setupHierarchy() {
        view.addSubviews(passcodeView, titleLabel, descriptionLabel, stackView)
        
        textFields.forEach {
            stackView.addArrangedSubview($0)
        }
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
        
        if numberOfDigits == 4 {
            stackViewWidthConstraint.isActive = true
        } else {
            stackViewWidthConstraint.constant = 200
            stackViewWidthConstraint.isActive = true
        }
        
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textFields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        }
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
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
            guard let databasePassword = presenter.getPassword() else { return }
            
            if passcodeArray == databasePassword {
                switch walletType {
                case .created:
                    if screenSize.height < 812 {
                        presenter.showBiometry(with: .touchID)
                    } else {
                        presenter.showBiometry(with: .faceID)
                    }
                case .imported:
                    presenter.showImportSuccess()
                case .change:
                    presenter.pop()
                }

            } else {
                print(false)
            }
        }
    }
    
    func onBackspaceAction(
        textFieldForResponder: UITextField,
        currentTextField: UITextField,
        indexToRemove: Int
    ) {
        textFieldForResponder.becomeFirstResponder()
        currentTextField.backgroundColor = .white
        passcodeArray.remove(at: indexToRemove - 1)
        print(passcodeArray)
    }
}

// MARK: - ConfirmViewProtocol
extension ConfirmViewController: ConfirmViewProtocol {}

// MARK: - UITextFieldDelegate
extension ConfirmViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
}
