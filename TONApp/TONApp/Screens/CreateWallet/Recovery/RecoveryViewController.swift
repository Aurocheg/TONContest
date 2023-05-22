//
//  RecoveryViewController.swift
//  TONApp
//
//  Created by Aurocheg on 4.04.23.
//

import UIKit
import WalletUtils
import WalletUI
import Lottie

protocol RecoveryViewProtocol: AnyObject {}

final class RecoveryViewController: UIViewController {
    // MARK: - Properties
    public var lottieManager: LottieManagerProtocol!
    public var presenter: RecoveryPresenterProtocol!
    public var configurator = RecoveryConfigurator()

    private let words: [String]
    private var wordIndices: [Int] = []
    
    private var timer: Timer?
    private var timeLeft = 60
    private var donePressCount = 0
    
    private let descriptionText = """
        Write down these 24 words in this exact order and keep them in a secure place. Do not share this list with anyone. If you lose it, you will irrevocably lose access to your TON account.
    """
    private var cellCount = 0
    private var lastContentOffset: CGFloat = 0
    
    // MARK: - UI Elements
    private lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var recoveryView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        lottieManager.applyAnimation(for: view, lottieType: .recoveryPhrase)
        return view
    }()
    private let titleLabel = TitleLabel(text: "Your Recovery Phrase")
    private lazy var descriptionLabel = DescriptionLabel(text: descriptionText)
    private let phrasesCollectionView = PhrasesCollectionView()
    private let doneButton = BackgroundButton(text: "Done")
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configurator.configure(with: self)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
        
        configureWordIndices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureNavBarTitle()
        
        DispatchQueue.main.async {
            self.navigationItem.titleView?.alpha = 0
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.timeLeft -= 1
            
            if self.timeLeft <= 0 {
                self.timeLeft = 0
                timer.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timeLeft = 60
        timer?.invalidate()
        timer = nil
        navigationController?.navigationBar.topItem?.title = nil
    }
    
    init(_ words: [String]) {
        self.words = words
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension RecoveryViewController {
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(recoveryView, titleLabel, descriptionLabel, phrasesCollectionView, doneButton)
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

        recoveryView.translatesAutoresizingMaskIntoConstraints = false
        recoveryView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26).isActive = true
        recoveryView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recoveryView.widthAnchor.constraint(equalToConstant: 124).isActive = true
        recoveryView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: recoveryView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        
        phrasesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        phrasesCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40).isActive = true
        phrasesCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -90).isActive = true
        phrasesCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        phrasesCollectionView.heightAnchor.constraint(equalToConstant: 374).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: phrasesCollectionView.bottomAnchor, constant: 52).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -78).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundContent
    }
    
    func setupTargets() {
        scrollView.delegate = self
        phrasesCollectionView.delegate = self
        phrasesCollectionView.dataSource = self
        phrasesCollectionView.register(PhraseCollectionCell.self, forCellWithReuseIdentifier: PhraseCollectionCell.reuseIdentifier)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    func configureWordIndices() {
        while wordIndices.count < 3 {
            let index = Int(arc4random_uniform(UInt32(words.count)))
            if !wordIndices.contains(index) {
                wordIndices.append(index)
            }
        }
        wordIndices.sort()
    }
    
    @objc func doneButtonTapped() {
        donePressCount += 1
        
        guard timeLeft > 0 else {
            presenter.doneButtonTapped(wordIndices: wordIndices, words: words)
            return
        }

        if donePressCount == 1 {
            let alert: UIAlertController = .makeAlert(with: .tooFastRecovery)
            present(alert, animated: true)
        }
        
        if donePressCount > 2 {
            let alert: UIAlertController = .makeAlert(with: .tooFastRecoveryDouble, style: .alert, secondCompletion: {
                self.presenter.doneButtonTapped(wordIndices: self.wordIndices, words: self.words)
            })
            present(alert, animated: true)
        }
    }
    
    func configureNavBarTitle() {
        let titleView = TitleLabel(text: titleLabel.text, fontSize: 17)
        navigationItem.titleView = titleView
    }
}

// MARK: - RecoveryViewProtocol
extension RecoveryViewController: RecoveryViewProtocol {}

// MARK: - UIScrollViewDelegate
extension RecoveryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset = scrollView.contentOffset.y
        let titlePosition = titleLabel.convert(CGPoint.zero, to: titleLabel.superview).y
        
        if scrollOffset >= titlePosition {
            navigationItem.titleView?.transitionElement(with: navigationItem.titleView, duration: 0.3, alpha: 1)
        } else {
            navigationItem.titleView?.transitionElement(with: navigationItem.titleView, duration: 0.3, alpha: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RecoveryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhraseCollectionCell.reuseIdentifier, for: indexPath) as? PhraseCollectionCell else {
            return UICollectionViewCell()
        }
        let isSecondColumn = indexPath.item >= 12
        let isDoubleDigit = indexPath.item >= 9 ? true : false
        
        let data = (number: UInt(indexPath.item + 1), word: words[indexPath.item])

        cell.alignCell(isSecondColumn: isSecondColumn, isDoubleDigit: isDoubleDigit)
        cell.configureCell(data)
        
        return cell
    }
}

extension RecoveryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSecondColumn = indexPath.item >= 12
        let cellWidth: CGFloat
        let cellHeight: CGFloat = 22
        
        if !isSecondColumn {
            cellWidth = collectionView.bounds.width * 0.619
        } else {
            cellWidth = collectionView.bounds.width * 0.38
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
