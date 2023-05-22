//
//  TransactionEntity.swift
//  TONApp
//
//  Created by Aurocheg on 16.04.23.
//

import UIKit
import WalletUtils
import SwiftyTON

public enum TransactionType {
    case incoming
    case outgoing
    
    public var descriptionText: String {
        switch self {
        case .incoming:
            return "from"
        case .outgoing:
            return "to"
        }
    }
    
    public var sumLabelColor: UIColor {
        switch self {
        case .incoming:
            return ThemeColors.systemGreen
        case .outgoing:
            return ThemeColors.systemRed
        }
    }
}

public protocol TransactionEntityProtocol {
    var date: String { get set }
    var transactions: [Transaction] { get set }
}

public struct TransactionEntity: TransactionEntityProtocol {
    public var date: String
    public var transactions: [Transaction]
    
    public init(date: String, transactions: [Transaction]) {
        self.date = date
        self.transactions = transactions
    }
}
