//
//  TestViewController.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit
import WalletUI
import Lottie

protocol TestViewProtocol: AnyObject {
    var enteredWords: [String] { get set }
}

final class TestViewController: UIViewController {
    // MARK: - Properties
    public var presenter: TestPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = TestConfigurator()
    
    public var enteredWords = ["", "", ""]
    
    private var activeTextField: UITextField?
    private let wordIndices: [Int]
    private let words: [String]
    private let numberOfSuggestions = 3
        
    // MARK: - UI Elements
    private lazy var teacherView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .testTime)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Test Time!")
    private let descriptionLabel = DescriptionLabel()
    private let stackView = StackView(spacing: 16, aligment: .center, distribution: .equalSpacing, axis: .vertical)
    
    private var textFields: [TextField] = []
    private var wordButtons: [BackgroundButton] = []
    
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
    
    init(wordIndices: [Int], words: [String]) {
        self.wordIndices = wordIndices
        self.words = words
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension TestViewController {
    func setupHierarchy() {
        for i in 0...2 {
            let textField = TextField(phraseNumber: wordIndices[i] + 1)
            textField.tag = i
            textFields.append(textField)
        }
        
        view.addSubviews(teacherView, titleLabel, descriptionLabel, stackView, continueButton)
        textFields.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupLayout() {
        teacherView.translatesAutoresizingMaskIntoConstraints = false
        teacherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        teacherView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        teacherView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        teacherView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: teacherView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 36).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 182).isActive = true
        
        textFields.forEach {
            $0.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
        setupTextFieldSuggestions()
    }
    
    func setupTargets() {
        presenter.setupWordList()
        
        descriptionLabel.text = "Let’s check that you wrote them down correctly. Please enter the words \(wordIndices[0] + 1), \(wordIndices[1] + 1) and \(wordIndices[2] + 1)."
        
        textFields.forEach {
            $0.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            $0.delegate = self
        }
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    func showIncorrectAlert() {
        let alertController: UIAlertController = .makeAlert(with: .incorrectWords, firstCompletion: {
            self.presenter.seeWordsTapped()
        }, secondCompletion: nil)
        present(alertController, animated: true)
    }
    
    func setupTextFieldSuggestions() {
        let inputView = UIView()
        inputView.backgroundColor = UIColor(red: 0.819, green: 0.827, blue: 0.85, alpha: 0.9)
        inputView.frame.size = CGSize(width: screenSize.width, height: 48)
        
        let wordsStackView = StackView(
            spacing: 4.5,
            distribution: .fillEqually
        )
        wordsStackView.frame = CGRect(
            origin: CGPoint(x: 3, y: 3),
            size: CGSize(width: screenSize.width - 6, height: 42)
        )
        
        inputView.addSubview(wordsStackView)
        
        for i in 0...numberOfSuggestions - 1 {
            let button = BackgroundButton(
                titleColor: .black,
                background: UIColor(red: 0.913, green: 0.917, blue: 0.933, alpha: 1)
            )
            button.tag = i
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            button.layer.cornerRadius = 4.5
            button.addTarget(self, action: #selector(wordButtonTapped), for: .touchUpInside)
            wordButtons.append(button)
        }
        
        wordButtons.forEach { wordsStackView.addArrangedSubview($0) }
        textFields.forEach { $0.inputAccessoryView = inputView }
    }
    
    // MARK: - Targets
    @objc func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        enteredWords[sender.tag] = text
        let suitableWords = presenter.searchSuitableWords(text, maxSearchResults: numberOfSuggestions)
        
        if wordButtons.count == suitableWords.count {
            for (i, button) in wordButtons.enumerated() {
                button.setTitle(suitableWords[i], for: .normal)
            }
        }
    }
    
    @objc func wordButtonTapped(_ sender: BackgroundButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        guard let activeTextField = activeTextField else {
            return
        }
        
        activeTextField.text = text
        enteredWords[activeTextField.tag] = text
        
        if activeTextField.tag != textFields.count - 1 {
            textFields[activeTextField.tag + 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    @objc func continueButtonTapped() {
        var isCorrect = true
        for i in 0 ..< enteredWords.count {
            if enteredWords[i].lowercased() != words[wordIndices[i]] {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            presenter.continueButtonTapped()
        } else {
            showIncorrectAlert()
        }
        view.endEditing(true)
    }
}

// MARK: - TestViewProtocol
extension TestViewController: TestViewProtocol {}

// MARK: - UITextFieldDelegate
extension TestViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.tag == textFields.count - 1) {
            textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
}
