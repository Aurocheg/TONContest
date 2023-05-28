//
//  LockViewController.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit
import WalletUI

enum LockType {
    case beforeSending(String, String, String)
    case beforeMain
    case beforeChangingPassword
    case beforeShowingRecoveryPhrases([String])
}

protocol LockViewProtocol: AnyObject {
    func removeCirclesFilling()
}

final class LockViewController: UIViewController {
    // MARK: - Properties
    public var presenter: LockPresenterProtocol!
    public var configurator = LockConfigurator()
    
    private var passcodeArray: [String] = []
    private var currentCircleIndex = 0
    
    private let lockType: LockType
    private let deepLinkAddress: String?
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - UI Elements
    private let coinImageView = ImageView(image: UIImage(named: "coin-48"))
    private let descriptionLabel = DescriptionLabel(
        text: "Enter your TON Wallet Passcode",
        textColor: ThemeColors.textOverlay,
        fontSize: 20
    )
    private let stackView = StackView(spacing: 16, aligment: .center, distribution: .equalCentering)
    private var circlesArray = [LockCircleView]()
    private let lockCollectionView = LockCollectionView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyAppearingAnimation(elements: [
            coinImageView, descriptionLabel, stackView, lockCollectionView
        ])
    }
    
    init(lockType: LockType, deepLinkAddress: String? = nil) {
        self.lockType = lockType
        self.deepLinkAddress = deepLinkAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension LockViewController {
    func setupHierarchy() {
        view.addSubviews(coinImageView, descriptionLabel, stackView, lockCollectionView)
        
        let circlesCount: Int
        
        if let userPassword = presenter.getUserPassword() {
            circlesCount = userPassword.count
        } else {
            circlesCount = 4
        }
        
        for _ in 0...circlesCount - 1 {
            let lockCircleView = LockCircleView()
            circlesArray.append(lockCircleView)
        }
        
        circlesArray.forEach { circle in
            stackView.addArrangedSubview(circle)
        }        
    }
    
    func setupLayout() {
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coinImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: coinImageView.bottomAnchor, constant: 30).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
        
        var stackWidthConstant: CGFloat
        
        switch circlesArray.count {
        case 4:
            stackWidthConstant = 136.0
        case 6:
            stackWidthConstant = 200.0
        default:
            stackWidthConstant = 0.0
        }
        
        stackView.widthAnchor.constraint(equalToConstant: stackWidthConstant).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        circlesArray.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        }
        
        lockCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lockCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60).isActive = true
        lockCollectionView.widthAnchor.constraint(equalToConstant: 282).isActive = true
        lockCollectionView.heightAnchor.constraint(equalToConstant: 366).isActive = true
        lockCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundBase
        stackView.backgroundColor = .clear
        
        coinImageView.alpha = 0
        descriptionLabel.alpha = 0
        stackView.alpha = 0
        lockCollectionView.alpha = 0
    }
    
    func setupTargets() {
        feedbackGenerator.prepare()
        
        presenter.setupLockItems()
        
        lockCollectionView.register(LockCollectionCell.self, forCellWithReuseIdentifier: LockCollectionCell.reuseIdentifier)
        lockCollectionView.delegate = self
        lockCollectionView.dataSource = self
    }
}

// MARK: - LockViewProtocol
extension LockViewController: LockViewProtocol {
    func removeCirclesFilling() {
        circlesArray.forEach {
            $0.removeFilling()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LockViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentItem = presenter.lockItems?[indexPath.section][indexPath.row] else {
            return
        }
        guard let userPassword = presenter.getUserPassword() else {
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1) {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            } completion: { isCompleted in
                if isCompleted {
                    UIView.animate(withDuration: 0.1) {
                        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
                    }
                }
            }
        }
    
        feedbackGenerator.impactOccurred()
                        
        if passcodeArray.count < userPassword.count {
            switch currentItem.configuration {
            case .number, .numberWithText:
                currentCircleIndex += 1
                passcodeArray.append(String(currentItem.number ?? 0))
                circlesArray[currentCircleIndex - 1].applyFilling()
                
                if passcodeArray.count == userPassword.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.circlesArray.forEach {
                            $0.scaleSelf()
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.presenter.finishTyping(
                            lockType: self.lockType,
                            passcodeArray: self.passcodeArray,
                            deepLinkAddress: self.deepLinkAddress
                        )
                    }
                }
            case .faceId:
                presenter.faceIdTapped(
                    lockType: lockType,
                    deepLinkAddress: deepLinkAddress
                )
            case .backspace:
                currentCircleIndex -= 1
                if !passcodeArray.isEmpty {
                    passcodeArray.removeLast()
                    circlesArray[currentCircleIndex].removeFilling()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LockViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.lockItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.lockItems?[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockCollectionCell.reuseIdentifier, for: indexPath) as? LockCollectionCell,
              let currentLockItem = presenter.lockItems?[indexPath.section][indexPath.row] else {
            return LockCollectionCell()
        }
        
        cell.configure(with: currentLockItem.configuration, entity: currentLockItem)
                
        return cell
    }
}

extension LockViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
    }
}
