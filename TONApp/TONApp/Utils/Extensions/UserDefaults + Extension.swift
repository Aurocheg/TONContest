//
//  UserDefaults + Extension.swift
//  TONApp
//
//  Created by Aurocheg on 10.04.23.
//

import Foundation

public extension UserDefaults {
    enum Constants {
        static let words = "words"
        static let password = "password"
        static let isWalletCreated = "isWalletCreated"
        static let tempDeepLink = "tempDeepLink"
        static let isFaceIdEstablished = "isFaceIdEstablished"
        static let isV3R2Enabled = "isV3R2Enabled"
        static let isV3R1Enabled = "isV3R1Enabled"
        static let isNotificationsEnabled = "isNotificationsEnabled"
        static let currentContract = "currentContract"
        static let currentCurrency = "currentCurrency"
    }
}
