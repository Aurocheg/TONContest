//
//  SendViewController.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import UIKit
import WalletUtils
import WalletUI

protocol SendViewProtocol: AnyObject {
    func pasteAddress(_ address: String)
    func changeSnackbarVisibility(to alpha: CGFloat)
    func changeIndicatorVisibility(_ isHidden: Bool)
}

final class SendViewController: UIViewController {
    // MARK: - Properties
    public var presenter: SendPresenterProtocol!
    public var configurator = SendConfigurator()
    
    private var deepLinkAddress: String?
        
    private let placeholderText = "Enter Wallet Address or Domain..."
    
    private lazy var continueBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    // MARK: - UI Elements
    private lazy var textView = TextView(placeholder: placeholderText)
    private let descriptionLabel = DescriptionLabel(
        text: "Paste the 24-letter wallet address of the recipient here or TON DNS.",
        textColor: ThemeColors.textSecondary,
        textAlignment: .left
    )
    private let buttonsStackView = StackView(spacing: 20, aligment: .firstBaseline, distribution: .fill, axis: .horizontal)
    private let pasteButton = NonBackgroundButton(
        text: "Paste",
        fontWeight: .medium,
        fontSize: 16,
        icon: UIImage(systemName: "doc.on.clipboard.fill")
    )
    private let scanButton = NonBackgroundButton(
        text: "Scan",
        fontWeight: .medium,
        fontSize: 16,
        icon: UIImage(named: "scan-28")
    )
    private let recentTableView = RecentTableView()
    private let continueButton = BackgroundButton(text: "Continue")
    private let snakbarView = SnackbarView(title: "Invalid Address", subtitle: "Address entered does not belong to TON")
    
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
        
        changeNavBarBackground(to: .white)
        
//        textView.becomeFirstResponder()
        
        presenter.pasteQrDeepLinkIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.text = nil
    }
    
    init(deepLinkAddress: String? = nil) {
        self.deepLinkAddress = deepLinkAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension SendViewController {
    func setupHierarchy() {
        view.addSubviews(textView, descriptionLabel, buttonsStackView, recentTableView, continueButton, snakbarView)
        buttonsStackView.addArrangedSubviews(pasteButton, scanButton)
    }
    
    func setupLayout() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
        buttonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        buttonsStackView.widthAnchor.constraint(equalToConstant: 157).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        [pasteButton, scanButton].forEach { button in
            button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
        
        recentTableView.translatesAutoresizingMaskIntoConstraints = false
        recentTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 22).isActive = true
        recentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recentTableView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueBottomConstraint.isActive = true
        
        snakbarView.translatesAutoresizingMaskIntoConstraints = false
        snakbarView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -12).isActive = true
        snakbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        snakbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        snakbarView.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setupProperties() {
        navigationItem.title = "Send TON"
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        pasteButton.addTarget(self, action: #selector(pasteButtonTapped), for: .touchUpInside)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
        textView.delegate = self
        
        presenter.getRecentTransactions()
        
        recentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentTableCell")
        recentTableView.delegate = self
        recentTableView.dataSource = self
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        presenter.pasteDeepLinkAddress(address: deepLinkAddress)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        changeConstraintOnVisibleKeyboard(
            notification: notification,
            constraint: continueBottomConstraint
        )
    }
    
    @objc func pasteButtonTapped() {
        if let pasteboardString = UIPasteboard.general.string, pasteboardString.count <= 48 {
            textView.text = pasteboardString
        }
    }
    
    @objc func scanButtonTapped() {
        presenter.scanButtonTapped()
    }
    
    @objc func continueButtonTapped() {
        continueButton.addIndicatorView()
        presenter.continueButtonTapped(address: textView.text)
    }
}

// MARK: - SendViewProtocol
extension SendViewController: SendViewProtocol {
    func pasteAddress(_ address: String) {
        textView.text = address
    }
    
    func changeSnackbarVisibility(to alpha: CGFloat) {
        snakbarView.changeVisibility(to: alpha)
    }
    
    func changeIndicatorVisibility(_ isHidden: Bool) {
        isHidden ? continueButton.removeIndicatorView() : continueButton.addCheckmark()
    }
}

// MARK: - UITextViewDelegate
extension SendViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.resize()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 48
    }
}

// MARK: - UITableViewDelegates
extension SendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
}

// MARK: - UITableViewDataSource
extension SendViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "RECENTS"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.recentTransactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableCell", for: indexPath)
        cell.selectionStyle = .none
        
        let currentTransaction = presenter.recentTransactions?[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = currentTransaction?.walletName
        contentConfiguration.secondaryText = currentTransaction?.transactionDate
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}
