//
//  EnterViewController.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import UIKit
import WalletUI
import Lottie
import SwiftyTON

protocol EnterViewProtocol: AnyObject {
    func setupSendAll(with amount: Double)
}

final class EnterViewController: UIViewController {
    // MARK: - Properties
    public var presenter: EnterPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = EnterConfigurator()
    
    private let address: String
    
    private lazy var continueBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    // MARK: - UI Elements
    private let contentView = UIView()
    private let toWalletLabel = DescriptionLabel()
    private let editButton = NonBackgroundButton(text: "Edit")
    private let stackView = StackView(
        aligment: .center,
        distribution: .equalSpacing
    )
    private lazy var coinView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .start)
        return view
    }()
    private let amountTextField = AmountTextField()
    private var wrongLabel = DescriptionLabel(
        text: "Insufficient funds",
        textColor: ThemeColors.systemRed
    )
    private let sendAllLabel = DescriptionLabel()
    private let sendAllSwitch = Switch()
    private let continueButton = BackgroundButton(text: "Continue")
    
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
        
        title = "Send TON"
        
        makeBackBarButton()
        changeNavBarBackground(to: .white, shadowImage: UIImage(), shadowColor: ThemeColors.separatorColor)
        
        amountTextField.becomeFirstResponder()
    }
    
    init(address: String) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension EnterViewController {
    func setupHierarchy() {
        view.addSubviews(contentView, continueButton)
        contentView.addSubviews(toWalletLabel, editButton, stackView, wrongLabel, sendAllLabel, sendAllSwitch)
        stackView.addArrangedSubviews(coinView, amountTextField)
    }
    
    func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.44).isActive = true
        
        toWalletLabel.translatesAutoresizingMaskIntoConstraints = false
        toWalletLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        toWalletLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        editButton.centerYAnchor.constraint(equalTo: toWalletLabel.centerYAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width - 32).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        coinView.translatesAutoresizingMaskIntoConstraints = false
        coinView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        coinView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        wrongLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        wrongLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 1).isActive = true
        
        sendAllLabel.translatesAutoresizingMaskIntoConstraints = false
        sendAllLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -19).isActive = true
        sendAllLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        sendAllSwitch.translatesAutoresizingMaskIntoConstraints = false
        sendAllSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        sendAllSwitch.centerYAnchor.constraint(equalTo: sendAllLabel.centerYAnchor).isActive = true
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueBottomConstraint.isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
        
        if address.count > 11 {
            setupWalletAddress(address.splitString())
        } else {
            // TODO: FOR DNS
        }
        
        wrongLabel.alpha = 0
        sendAllLabel.alpha = 0
        sendAllSwitch.alpha = 0
    }
    
    func setupTargets() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        editButton.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )
        
        amountTextField.addTarget(
            self,
            action: #selector(amountTextFieldChanged),
            for: .editingChanged
        )
        
        sendAllSwitch.addTarget(
            self,
            action: #selector(switchChanged),
            for: .valueChanged
        )
        
        continueButton.addTarget(
            self,
            action: #selector(continueButtonTapped),
            for: .touchUpInside
        )
        
        presenter.setupBalance()
    }
    
    func setupWalletAddress(_ text: String) {
        let attrString = NSMutableAttributedString(string: "Sent to: ", attributes: [NSAttributedString.Key.foregroundColor: ThemeColors.textSecondary])
        let decimalString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: ThemeColors.textPrimary])
    
        attrString.append(decimalString)
        
        toWalletLabel.attributedText = attrString
    }
    
    func applyAttributes(for textField: UITextField, value: String) {
        let attributedString = NSMutableAttributedString(string: value)
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 48, weight: .semibold)
        ]

        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30, weight: .semibold)
        ]
        
        if let dotRange = value.range(of: ".") {
            let startIndex = value.startIndex
            let dotIndex = value.distance(from: startIndex, to: dotRange.lowerBound)
            let firstRange = NSRange(location: 0, length: dotIndex)
            let secondRange = NSRange(location: dotIndex + 1, length: value.count - dotIndex - 1)

            attributedString.addAttributes(firstAttributes, range: firstRange)
            attributedString.addAttributes(secondAttributes, range: secondRange)
        }

        textField.attributedText = attributedString
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        changeConstraintOnVisibleKeyboard(
            notification: notification,
            constraint: continueBottomConstraint
        )
    }
    
    @objc func editButtonTapped() {
        presenter.editButtonTapped()
    }
    
    @objc func amountTextFieldChanged(_ sender: UITextField) {
        guard let value = sender.text else { return }
        let doubleValue = Double(value)
        
        if doubleValue == presenter.balance {
            sendAllSwitch.setOn(true, animated: true)
        } else {
            sendAllSwitch.setOn(false, animated: true)
        }
        
        applyAttributes(for: sender, value: value)
        
        if doubleValue ?? 0 > presenter.balance ?? 0 {
            sender.textColor = ThemeColors.systemRed
            wrongLabel.transitionElement(duration: 0.3, alpha: 1)
        } else {
            sender.textColor = ThemeColors.textPrimary
            wrongLabel.transitionElement(duration: 0.3, alpha: 0)
        }
    }
    
    @objc func switchChanged(_ sender: Switch) {
        if sender.isOn {
            let value = String(presenter.balance ?? 0)
            applyAttributes(for: amountTextField, value: value)
            amountTextField.textColor = ThemeColors.textPrimary
        } else {
            amountTextField.text = nil
        }
    }
    
    @objc func continueButtonTapped() {
        guard let text = amountTextField.text else {
            return
        }
        presenter.continueButtonTapped(amount: text, address: address)
    }
}

// MARK: - EnterViewProtocol
extension EnterViewController: EnterViewProtocol {
    func setupSendAll(with amount: Double) {
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: -4, width: 22, height: 22)
        attachment.image = UIImage(named: "coin-icon")
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSMutableAttributedString(string: "Send all ")
        textString.append(attachmentString)
        textString.append(NSAttributedString(string: " \(amount)"))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: textString.length))
        
        sendAllLabel.attributedText = textString
        
        sendAllLabel.transitionElement(duration: 0.2, alpha: 1)
        sendAllSwitch.transitionElement(duration: 0.2, alpha: 1)
    }
}

