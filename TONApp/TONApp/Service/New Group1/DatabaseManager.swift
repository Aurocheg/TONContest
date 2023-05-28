//
//  DatabaseManager.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation
import WalletEntity

protocol DatabaseManagerProtocol: AnyObject {
    func saveWords(_ words: [String])
    func saveCurrentCurrency(currency: String)
    func saveFaceIdState(_ isOn: Bool)
    func saveCurrentContract(contract: String)
    func saveIsNotificationsEnabled(_ isEnabled: Bool)
    func savePassword(password: [String])
    func saveAppState(isWalletCreated: Bool)
    func saveTempDeepLink(_ string: String)
    func saveRecentTransaction(transaction: (String, String))
    
    func getWords() -> [String]?
    func getCurrentCurrency() -> String?
    func getFaceIdState() -> Bool?
    func getCurrentContract() -> String?
    func getIsNotificationsEnabled() -> Bool?
    func getPassword() -> [String]?
    func getAppState() -> Bool?
    func getTempDeepLink() -> String?
    func getRecentTransactions() -> [(String, String)]?
    
    func deleteTempDeepLink()
}

final class DatabaseManager {
    var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: - DatabaseManagerProtocol
extension DatabaseManager: DatabaseManagerProtocol {
    func saveWords(_ words: [String]) {
        userDefaults.setValue(words, forKey: UserDefaults.Constants.words)
    }
    
    func getWords() -> [String]? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.words) as? [String] {
            return object
        }
        return nil
    }
    
    func saveFaceIdState(_ isOn: Bool) {
        userDefaults.setValue(isOn, forKey: UserDefaults.Constants.isFaceIdEstablished)
    }
    
    func saveCurrentContract(contract: String) {
        userDefaults.setValue(contract, forKey: UserDefaults.Constants.currentContract)
    }
    
    func saveIsV3R1Enabled(_ isEnabled: Bool) {
        userDefaults.setValue(isEnabled, forKey: UserDefaults.Constants.isV3R1Enabled)
    }
    
    func saveIsV3R2Enabled(_ isEnabled: Bool) {
        userDefaults.setValue(isEnabled, forKey: UserDefaults.Constants.isV3R2Enabled)
    }
    
    func saveCurrentCurrency(currency: String) {
        userDefaults.setValue(currency, forKey: UserDefaults.Constants.currentCurrency)
    }
    
    func saveIsNotificationsEnabled(_ isEnabled: Bool) {
        userDefaults.setValue(isEnabled, forKey: UserDefaults.Constants.isNotificationsEnabled)
    }
    
    func savePassword(password: [String]) {
        userDefaults.setValue(password, forKey: UserDefaults.Constants.password)
    }
    
    func saveAppState(isWalletCreated: Bool) {
        userDefaults.setValue(isWalletCreated, forKey: UserDefaults.Constants.isWalletCreated)
    }
    
    func saveTempDeepLink(_ string: String) {
        userDefaults.setValue(string, forKey: UserDefaults.Constants.tempDeepLink)
    }
    
    func saveRecentTransaction(transaction: (String, String)) {
        guard var transactions = getRecentTransactions() else {
            var transactionsArray: [(String, String)] = []
            transactionsArray.append(transaction)
            userDefaults.setValue(transactionsArray, forKey: UserDefaults.Constants.recentTransactions)
            return
        }
        transactions.append(transaction)
        userDefaults.setValue(transactions, forKey: UserDefaults.Constants.recentTransactions)
    }
    
    func getIsNotificationsEnabled() -> Bool? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.isNotificationsEnabled) as? Bool {
            return object
        }
        return nil
    }
    
    func getCurrentContract() -> String? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.currentContract) as? String {
            return object
        }
        return nil
    }
    
    func getCurrentCurrency() -> String? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.currentCurrency) as? String {
            return object
        }
        return nil
    }
    
    func getFaceIdState() -> Bool? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.isFaceIdEstablished) as? Bool {
            return object
        }
        return nil
    }
    
    func getPassword() -> [String]? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.password) as? [String] {
            return object
        }
        return nil
    }
    
    func getAppState() -> Bool? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.isWalletCreated) as? Bool {
            return object
        }
        return nil
    }
    
    func getTempDeepLink() -> String? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.tempDeepLink) as? String {
            return object
        }
        return nil
    }
    
    func getRecentTransactions() -> [(String, String)]? {
        if let object = userDefaults.object(forKey: UserDefaults.Constants.recentTransactions) as? [(String, String)] {
            return object
        }
        return nil
    }
    
    func deleteTempDeepLink() {
        userDefaults.removeObject(forKey: UserDefaults.Constants.tempDeepLink)
    }
}
