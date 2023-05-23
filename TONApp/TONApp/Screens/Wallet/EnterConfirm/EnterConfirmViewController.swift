//
//  EnterConfirmViewController.swift
//  TONApp
//
//  Created by Aurocheg on 22.04.23.
//

import UIKit
import WalletUI
import SwiftyTON

protocol EnterConfirmViewProtocol: AnyObject {
    
}

final class EnterConfirmViewController: UIViewController {
    // MARK: - Properties
    public var presenter: EnterConfirmPresenterProtocol!
    public var configurator = EnterConfirmConfigurator()
    
    private lazy var sendBottomConstraint = sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    private let amount: String
    private let address: String
    
    private let placeholderText = "Description of the payment"
    private let visibilityOriginalText = "The comment is visible to everyone. You must include the note when sending to an exchange."
    private var messageTextSize: String?
    
    private let maxCommentAmount = 61
    private var startLeftCharactersShow: Int {
        maxCommentAmount - 24
    }
    
    // MARK: - UI Elements
    private let commentLabel = DescriptionLabel(
        text: "Comment (Optional)".uppercased(),
        textColor: ThemeColors.textSecondary,
        fontSize: 13,
        textAlignment: .left
    )
    private lazy var commentTextView = TextView(
        placeholder: placeholderText,
        background: ThemeColors.backgroundContent
    )
    private lazy var visibilityLabel = DescriptionLabel(
        text: visibilityOriginalText,
        textColor: ThemeColors.textSecondary,
        fontSize: 13,
        textAlignment: .left
    )
    private let sendTableView = SendTableView()
    private let sendButton = BackgroundButton(text: "Confirm and send")
    
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
        
        makeBackBarButton()
        changeNavBarBackground(to: view.backgroundColor)
        
        title = "Send TON"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = nil
    }
    
    init(amount: String, address: String) {
        self.amount = amount
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension EnterConfirmViewController {
    func setupHierarchy() {
        view.addSubviews(commentLabel, commentTextView, visibilityLabel, sendTableView, sendButton)
    }
    
    func setupLayout() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        commentTextView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 4).isActive = true
        
        visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        visibilityLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 6).isActive = true
        visibilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        visibilityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        sendTableView.translatesAutoresizingMaskIntoConstraints = false
        sendTableView.topAnchor.constraint(equalTo: visibilityLabel.bottomAnchor, constant: 6).isActive = true
        sendTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        sendTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        sendTableView.heightAnchor.constraint(equalToConstant: 176).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendBottomConstraint.isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundGrouped
    }
    
    func setupTargets() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        commentTextView.delegate = self
        
        sendTableView.delegate = self
        sendTableView.dataSource = self
        sendTableView.register(SendTableCell.self, forCellReuseIdentifier: SendTableCell.reuseIdentifier)
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    func addStringWithAttributes(text: String?, color: UIColor) {
        guard let text = text else { return }
        
        let attributedString = NSMutableAttributedString(
            string: "\(visibilityOriginalText)\n\(text)"
        )
        let range = NSRange(location: visibilityOriginalText.count + 1, length: text.count)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        visibilityLabel.attributedText = attributedString
    }
    
    func removeStringWithAttributes() {

    }
    
    func addBackgroundToCharacters(text: String?, in range: NSRange) {
        guard let text = text else { return }
        let backgroundColor = UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 0.12)
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.backgroundColor, value: backgroundColor, range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: range)
        commentTextView.attributedText = attributedString
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        changeConstraintOnVisibleKeyboard(
            notification: notification,
            constraint: sendBottomConstraint
        )
    }
    
    @objc func sendButtonTapped() {
        guard commentTextView.text.count <= maxCommentAmount else {
            return
        }
        presenter.sendButtonTapped(address: address, amount: amount, comment: commentTextView.text)
    }
}

// MARK: - EnterConfirmViewProtocol
extension EnterConfirmViewController: EnterConfirmViewProtocol {}

// MARK: - UITextViewDelegate
extension EnterConfirmViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        removePlaceholder(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addPlaceholder(textView, text: placeholderText)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.resize()
                
        let numberOfCharacters = textView.text.count
        let characterResidue = maxCommentAmount - numberOfCharacters
                
        if numberOfCharacters >= startLeftCharactersShow {
            if numberOfCharacters > maxCommentAmount {
                messageTextSize = "Message size has been exceeded by \(abs(characterResidue)) characters."
                let backgroundRange = NSRange(location: maxCommentAmount, length: abs(characterResidue))
                addBackgroundToCharacters(text: textView.text, in: backgroundRange)
                
                addStringWithAttributes(text: messageTextSize, color: ThemeColors.systemRed)
            } else {
                messageTextSize = "\(characterResidue) characters left."
                addStringWithAttributes(text: messageTextSize, color: ThemeColors.systemOrange)
            }
        } else {
            if visibilityLabel.text?.count != visibilityOriginalText.count {
                if characterResidue > 24 {
                    removeStringWithAttributes()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension EnterConfirmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.applyCorners(to: [.topLeft, .topRight], with: view.bounds)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
        
        if isLastCell {
            cell.applyCorners(to: [.bottomLeft, .bottomRight], with: cell.bounds)
        } else {
            cell.removeCorners()
        }
    }
}

// MARK: - UITableViewDataSource
extension EnterConfirmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "label".uppercased()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SendTableCell.reuseIdentifier) as? SendTableCell else {
            return SendTableCell()
        }
        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true
        contentConfiguration.secondaryTextProperties.font = .systemFont(ofSize: 17)
        
        switch indexPath.row {
        case 0:
            contentConfiguration.text = "Recipient"
            contentConfiguration.secondaryText = address.splitString()
        case 1:
            contentConfiguration.text = "Amount"
            let attributedString = getSecondaryTextWithIcon(text: amount)
            contentConfiguration.secondaryAttributedText = attributedString
        case 2:
            contentConfiguration.text = "Fee"
            let attributedString = getSecondaryTextWithIcon(text: presenter.fee ?? "")
            contentConfiguration.secondaryAttributedText = attributedString
        default: break
        }
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    private func getSecondaryTextWithIcon(text: String) -> NSMutableAttributedString {
        let fullString = NSMutableAttributedString()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "coin-icon")
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let attributedString = NSAttributedString(string: text, attributes: [.baselineOffset: 1])
        
        fullString.append(imageString)
        fullString.append(attributedString)
        
        return fullString
    }
}
