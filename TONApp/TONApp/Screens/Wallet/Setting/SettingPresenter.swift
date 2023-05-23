//
//  SettingPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import Foundation
import WalletEntity

protocol SettingPresenterProtocol: AnyObject {
    var settings: [SettingEntity] { get }
    var isNotificationsEnabled: Bool? { get }
    var currentContract: String? { get }
    var currentCurrency: String? { get }
    var isFaceIdEstablished: Bool? { get }
    
    func configureSettingsIfPossible()
    func getSettings()
    
    func closeButtonTapped()
    func recoveryPhraseTapped()
    func changePasscodeTapped()
    
    func switchChanged(_ type: SettingSwitchType, isOn: Bool)
    func pickerChanged(_ type: SettingPickerType, title: String)
}

final class SettingPresenter {
    weak var view: SettingViewProtocol!
    public var router: SettingRouterProtocol!
    public var databaseManager: DatabaseManagerProtocol!
    public var authManager: AuthManagerProtocol!
    
    public var settings: [SettingEntity] = []
    public var isNotificationsEnabled: Bool?
    public var currentContract: String?
    public var currentCurrency: String?
    public var isFaceIdEstablished: Bool?
    
    private let contractChangedNotification = Notification.Name("ContractChanged")
    
    required init(view: SettingViewProtocol) {
        self.view = view
    }
}

// MARK: - SettingPresenterProtocol
extension SettingPresenter: SettingPresenterProtocol {
    func configureSettingsIfPossible() {
        guard let isNotificationsEnabled = databaseManager.getIsNotificationsEnabled(),
              let currentContract = databaseManager.getCurrentContract(),
              let currentCurrency = databaseManager.getCurrentCurrency(),
              let isFaceIdEstablished = databaseManager.getFaceIdState() else {
            return
        }
        
        self.isNotificationsEnabled = isNotificationsEnabled
        self.currentContract = currentContract
        self.currentCurrency = currentCurrency
        self.isFaceIdEstablished = isFaceIdEstablished        
    }
    
    func getSettings() {
        settings = Setting.getSettings()
    }
    
    func closeButtonTapped() {
        router.dismiss()
    }
    
    func recoveryPhraseTapped() {
        guard let words = databaseManager.getWords() else {
            return
        }
        authManager.canEvaluate { canEvaluate, _, canEvaluateError in
            guard canEvaluate else {
                self.router.showLock(
                    lockType: .beforeShowingRecoveryPhrases(words)
                )
                return
            }
            
            authManager.evaluate { [weak self] success, error in
                guard let strongSelf = self else {
                    self?.router.showLock(lockType: .beforeShowingRecoveryPhrases(words))
                    return
                }
                guard success else {
                    strongSelf.router.showLock(lockType: .beforeShowingRecoveryPhrases(words))
                    return
                }
                
                strongSelf.router.showRecovery(words)
            }
        }
    }
    
    func changePasscodeTapped() {
        authManager.canEvaluate { canEvaluate, _, canEvaluateError in
            guard canEvaluate else {
                self.router.showLock(lockType: .beforeChangingPassword)
                return
            }
            
            authManager.evaluate { [weak self] success, error in
                guard let strongSelf = self else {
                    self?.router.showLock(lockType: .beforeChangingPassword)
                    return
                }
                guard success else {
                    strongSelf.router.showLock(lockType: .beforeChangingPassword)
                    return
                }
                
                strongSelf.router.showPasscode()
            }
        }
    }
    
    func switchChanged(_ type: SettingSwitchType, isOn: Bool) {
        switch type {
        case .faceId:
            databaseManager.saveFaceIdState(isOn)
        case .notification:
            databaseManager.saveIsNotificationsEnabled(isOn)
        }
        configureSettingsIfPossible()
    }
    
    func pickerChanged(_ type: SettingPickerType, title: String) {
        switch type {
        case .contract:
            print(title)
            databaseManager.saveCurrentContract(contract: title)
            NotificationCenter.default.post(name: contractChangedNotification, object: nil)
        case .currency:
            databaseManager.saveCurrentCurrency(currency: title)
        }
        
        configureSettingsIfPossible()
    }
}
