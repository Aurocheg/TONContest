//
//  ImportStartViewController.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import UIKit
import WalletUtils
import WalletUI
import Lottie

protocol ImportStartViewProtocol: AnyObject {
    var enteredWords: [String] { get set }
    func endEditing()
    func showAlert()
}

final class ImportStartViewController: UIViewController {
    // MARK: - Properties
    public var presenter: ImportStartPresenterProtocol!
    public var configurator = ImportStartConfigurator()
    public var lottieManager: LottieManagerProtocol!
    
    private let descriptionText = """
        You can restore access to your wallet by entering 24 words you wrote when down you creating the wallet.
    """
    private var lastContentOffset: CGFloat = 0
    private let oneTextFieldHeightInStack: Double = 66
    public var enteredWords: [String] = []
    
    // MARK: - UI Elements
    private lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var wordView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .recoveryPhrase)
        return view
    }()
    private let titleLabel = TitleLabel(text: "24 Secret Words")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
    private lazy var noWordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I don’t have those", for: .normal)
        return button
    }()
    private let stackView = StackView(spacing: 16, aligment: .fill, distribution: .equalSpacing, axis: .vertical)
    private var textFieldsArray: [TextField] = []
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
}

// MARK: - Private methods
private extension ImportStartViewController {
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(wordView, titleLabel, descriptionLabel, noWordsButton, stackView, continueButton)
        
        for i in 0...23 {
            let textField = TextField(phraseNumber: i + 1)
            textField.tag = i
            enteredWords.append("")
            textFieldsArray.append(textField)
            stackView.addArrangedSubview(textField)
        }
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)
        heightConstraint.isActive = true
        
        wordView.translatesAutoresizingMaskIntoConstraints = false
        wordView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26).isActive = true
        wordView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        wordView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        wordView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: wordView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        noWordsButton.translatesAutoresizingMaskIntoConstraints = false
        noWordsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
        noWordsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        noWordsButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -64).isActive = true
        noWordsButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: noWordsButton.bottomAnchor, constant: 36).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -96).isActive = true
        let stackViewHeight = oneTextFieldHeightInStack * Double(textFieldsArray.count)
        stackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        
        textFieldsArray.forEach {
            $0.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -96).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -78).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        textFieldsArray.forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        }
        noWordsButton.addTarget(self, action: #selector(noWordsButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        enteredWords[sender.tag] = text
        print(enteredWords)
    }
    
    @objc func noWordsButtonTapped() {
        presenter.noWordsButtonTapped()
    }
    
    @objc func continueButtonTapped() {
        presenter.continueButtonTapped()
    }
}

// MARK: - ImportStartViewProtocol
extension ImportStartViewController: ImportStartViewProtocol {
    func endEditing() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert: UIAlertController = .makeAlert(with: .incorrectWords, style: .alert, firstCompletion: {
            self.presenter.seeWordsTapped()
        }, secondCompletion: nil)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ImportStartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.tag == textFieldsArray.count - 1) {
            textFieldsArray[textField.tag + 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.keyboardDismissMode = .interactive
        scrollView.setContentOffset(CGPoint(
            x: 0,
            y: textField.frame.origin.y - 64
        ), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(
            x: 0,
            y: textField.frame.origin.y
        ), animated: true)
    }
}
