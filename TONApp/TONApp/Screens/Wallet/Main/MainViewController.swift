//
//  MainViewController.swift
//  TONApp
//
//  Created by Aurocheg on 11.04.23.
//

import UIKit
import WalletUtils
import WalletUI
import WalletEntity
import Lottie

enum MainViewState {
    case loading
    case created
    case transactions
}

protocol MainViewProtocol: AnyObject {
    func configureViews(with state: MainViewState)
    func configureTitleNavBar(with sum: Double?)
    func updateBalance(with amount: Double?)
    func updateAddress(with address: String?)
    func animateCreatedElementsAlpha(to: CGFloat)
    func reloadTransactions()
}

final class MainViewController: UIViewController {
    // MARK: - Properties
    public var presenter: MainPresenterProtocol!
    public var lottieManager: LottieManagerProtocol!
    public var configurator = MainConfigurator()
    
    private var isTransactionsEnabled = false
    private var isContentViewPinnedToTop = false
            
    // MARK: Constraints
    private lazy var coinStackLoadingTopConstraint = balanceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52)
    private var coinStackCreatedTopConstraint: NSLayoutConstraint {
        return balanceStackView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 2)
    }
    private lazy var contentDefaultTopConstraint = contentView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 16)
    private lazy var contentPinnedTopConstraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    
    // MARK: - UI Elements
    private let balanceStackView = StackView(
        aligment: .center,
        distribution: .equalSpacing
    )
    private let addressLabel: DescriptionLabel = {
        let label = DescriptionLabel(
            textColor: ThemeColors.textOverlay
        )
        label.alpha = 0
        return label
    }()
    private lazy var diaomondView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .start)
        return view
    }()
    private let balanceLabel: AmountLabel = {
        let label = AmountLabel(textColor: .white)
        label.alpha = 0
        return label
    }()
    private let buttonsStackView = StackView(
        spacing: 12,
        aligment: .fill,
        distribution: .fillEqually,
        axis: .horizontal
    )
    private let receiveButton: BackgroundButton = {
        let icon = UIImage(named: "receive-24")
        let button = BackgroundButton(
            text: "Receive",
            background: ThemeColors.accentMain,
            icon: icon
        )
        return button
    }()
    private let sendButton: BackgroundButton = {
        let icon = UIImage(named: "send-24")
        let button = BackgroundButton(
            text: "Send",
            background: ThemeColors.accentMain,
            icon: icon
        )
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private lazy var loadingView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .loading)
        return view
    }()
    
    private lazy var createdElements = [
        createdView,
        createdTitleLabel,
        createdAddressLabel,
        createdWalletLabel
    ]
    private var createdView: LottieAnimationView?
    private var createdTitleLabel: TitleLabel?
    private var createdAddressLabel: DescriptionLabel?
    private var createdWalletLabel: DescriptionLabel?
    
    private var transactionsTableView: TranscationsTableView?
    private let refreshControl = UIRefreshControl()
        
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
        
        let scanIcon = UIImage(named: "scan-28")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        let settingsIcon = UIImage(named: "settings-28")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let scanBarButtonItem = UIBarButtonItem(image: scanIcon, style: .plain, target: self, action: #selector(scanTapped))
        let settingsBarButtonItem = UIBarButtonItem(image: settingsIcon, style: .plain, target: self, action: #selector(settingsTapped))
        
        navigationItem.leftBarButtonItem = scanBarButtonItem
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
}

// MARK: - Private methods
private extension MainViewController {
    func setupHierarchy() {
        view.addSubviews(addressLabel, balanceStackView, buttonsStackView, contentView)
        balanceStackView.addArrangedSubviews(diaomondView, balanceLabel)
        buttonsStackView.addArrangedSubviews(receiveButton, sendButton)
        contentView.addSubviews(loadingView)
    }
    
    func setupLayout() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        balanceStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 2).isActive = true
        balanceStackView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width - 32).isActive = true
        balanceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        balanceStackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        diaomondView.translatesAutoresizingMaskIntoConstraints = false
        diaomondView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        diaomondView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 74).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 16).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 124).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundBase

        contentView.isUserInteractionEnabled = true
    }
    
    func setupTargets() {
        presenter.loadWallet()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleContractChanged),
            name: Notification.Name("ContractChanged"),
            object: nil
        )

        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        receiveButton.addTarget(self, action: #selector(receiveButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    func makeCreatedElements() {
        createdView = LottieAnimationView()
        guard let createdView = createdView else { return }
        createdView.loopMode = .playOnce
        createdView.alpha = 0
        lottieManager.applyAnimationWithProgress(for: createdView, lottieType: .created, toProgress: 0.7)
        contentView.addSubview(createdView)
        
        createdView.translatesAutoresizingMaskIntoConstraints = false
        createdView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 90).isActive = true
        createdView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        createdView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        createdView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        createdTitleLabel = TitleLabel(text: "Wallet Created")
        guard let createdTitleLabel = createdTitleLabel else { return }
        createdTitleLabel.alpha = 0
        contentView.addSubview(createdTitleLabel)
        
        createdTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        createdTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        createdTitleLabel.topAnchor.constraint(equalTo: createdView.bottomAnchor, constant: 8).isActive = true
        
        createdAddressLabel = DescriptionLabel(
            text: "Your wallet address",
            textColor: ThemeColors.textSecondary
        )
        guard let createdAddressLabel = createdAddressLabel else { return }
        createdAddressLabel.alpha = 0
        contentView.addSubview(createdAddressLabel)
        
        createdAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAddressLabel.topAnchor.constraint(equalTo: createdTitleLabel.bottomAnchor, constant: 28).isActive = true
        createdAddressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        createdWalletLabel = DescriptionLabel(text: presenter.address)
        guard let createdWalletLabel = createdWalletLabel else { return }
        createdWalletLabel.alpha = 0
        createdWalletLabel.font = .monospacedSystemFont(ofSize: 17, weight: .regular)
        contentView.addSubview(createdWalletLabel)
        
        createdWalletLabel.translatesAutoresizingMaskIntoConstraints = false
        createdWalletLabel.topAnchor.constraint(equalTo: createdAddressLabel.bottomAnchor, constant: 6).isActive = true
        createdWalletLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
        createdWalletLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
    }
    
    func makeTableView() {
        transactionsTableView = TranscationsTableView()
        guard let transactionsTableView = transactionsTableView else { return }
        transactionsTableView.alpha = 0
        transactionsTableView.refreshControl = refreshControl
        
        contentView.addSubview(transactionsTableView)
        
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        transactionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        transactionsTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        transactionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        transactionsTableView.register(
            TransactionTableCell.self,
            forCellReuseIdentifier: TransactionTableCell.reuseIdentifier
        )
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
    @objc func handleContractChanged() {
        presenter.loadWallet()
    }
    
    @objc func scanTapped() {
        presenter.scanButtonTapped()
    }
    
    @objc func settingsTapped() {
        presenter.settingButtonTapped()
    }
    
    @objc func refreshData() {
        presenter.refreshWallet()
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func receiveButtonTapped() {
        presenter.receiveButtonTapped()
    }
    
    @objc func sendButtonTapped() {
        presenter.sendButtonTapped()
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard isTransactionsEnabled else {
            return
        }
        guard let view = gesture.view else { return }
        let velocity = gesture.velocity(in: view)
        let isMovingUp = velocity.y <= 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            if isMovingUp {
                self.contentDefaultTopConstraint.isActive = false
                self.contentPinnedTopConstraint.isActive = true
                self.buttonsStackView.alpha = 0
                self.isContentViewPinnedToTop = true
            } else {
                self.contentPinnedTopConstraint.isActive = false
                self.contentDefaultTopConstraint.isActive = true
                self.buttonsStackView.alpha = 1
                self.isContentViewPinnedToTop = false
            }
            self.view.layoutIfNeeded()
        }
        
        if isContentViewPinnedToTop {
            transactionsTableView?.isScrollEnabled = true
        } else {
            transactionsTableView?.isScrollEnabled = false
        }
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func configureViews(with state: MainViewState) {
        switch state {
        case .loading:
            loadingView.transitionElement(with: loadingView, duration: 0.2, alpha: 1)
        case .created:
            loadingView.transitionElement(with: loadingView, duration: 0.2, alpha: 0)
            addressLabel.transitionElement(with: addressLabel, duration: 0.2, alpha: 1)
            balanceLabel.transitionElement(with: balanceLabel, duration: 0.2, alpha: 1)
            makeCreatedElements()
            animateCreatedElementsAlpha(to: 1)
        case .transactions:
            isTransactionsEnabled = true
            loadingView.transitionElement(with: loadingView, duration: 0.2, alpha: 0)
            addressLabel.transitionElement(with: addressLabel, duration: 0.2, alpha: 1)
            balanceLabel.transitionElement(with: balanceLabel, duration: 0.2, alpha: 1)
            if transactionsTableView == nil {
                makeTableView()
            }
            transactionsTableView?.transitionElement(with: transactionsTableView, duration: 0.2, alpha: 1)
        }
    }
    
    func configureTitleNavBar(with sum: Double?) {
        guard let sum = sum else { return }
        let titleView = UIView()

        let image = UIImage(named: "coin-icon")
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = ThemeColors.textOverlay
        titleLabel.text = String(sum)
        titleView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        
        let coinImageView = ImageView(image: image)
        titleView.addSubview(coinImageView)
        
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -2).isActive = true
        coinImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let currencyLabel = UILabel()
        currencyLabel.font = .systemFont(ofSize: 13)
        currencyLabel.textColor = .lightGray
        currencyLabel.text = "=$89.6"
        titleView.addSubview(currencyLabel)
        
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: -5).isActive = true
        currencyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        navigationItem.titleView = titleView
        
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-15, for: .default)
        
        DispatchQueue.main.async {
            self.navigationItem.titleView?.alpha = 0
        }
    }
    
    func updateBalance(with amount: Double?) {
        guard let amount = amount else { return }
        balanceLabel.configureAttributedString(with: .large, amount: amount)
    }
    
    func updateAddress(with address: String?) {
        guard let address = address else {
            return
        }
        addressLabel.text = address.splitString()
    }
    
    func animateCreatedElementsAlpha(to: CGFloat) {
        createdElements.forEach { $0?.transitionElement(with: $0, duration: 0.2, alpha: to) }
    }
    
    func reloadTransactions() {
        self.transactionsTableView?.reloadData()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let translation = panGesture.translation(in: view)
        return abs(translation.y) > abs(translation.x)
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        DateHeaderLabel(with: presenter.transactions[section].date)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        144
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTransaction = presenter.transactions[indexPath.section].transactions[indexPath.row]
        
        if currentTransaction.out.isEmpty {
            presenter.transactionTapped(cellType: .incoming, entity: currentTransaction)
        } else {
            presenter.transactionTapped(cellType: .outgoing, entity: currentTransaction)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.transactions[section].transactions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableCell.reuseIdentifier, for: indexPath) as? TransactionTableCell else {
            return TransactionTableCell()
        }
        let currentTransaction = presenter.transactions[indexPath.section].transactions[indexPath.row]
        
        if currentTransaction.out.isEmpty {
            cell.configureCell(with: .incoming, entity: currentTransaction)
        } else {
            cell.configureCell(with: .outgoing, entity: currentTransaction)
        }
        
        return cell
    }
}
