//
//  TransactionEntity.swift
//  TONApp
//
//  Created by Aurocheg on 16.04.23.
//

import UIKit
import SwiftyTON

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
