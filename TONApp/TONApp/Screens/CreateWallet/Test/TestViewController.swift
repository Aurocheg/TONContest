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
    private let wordIndices: [Int]
    private let words: [String]
        
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
    
    private var textFields = [TextField]()
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
    }
    
    func setupTargets() {
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
    
    // MARK: - Targets
    @objc func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        enteredWords[sender.tag] = text
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.tag == textFields.count - 1) {
            textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
}
