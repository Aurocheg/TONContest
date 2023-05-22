//
//  RecentTransactionEntity.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import Foundation

public protocol RecentTransactionEntity {
    var walletName: String { get }
    var transactionDate: String { get }
}

public struct RecentTransaction: RecentTransactionEntity {
    public var walletName: String
    public var transactionDate: String
    
    public static func getTransactions() -> [RecentTransactionEntity] {
        [
            RecentTransaction(walletName: "EQCc…9ZLD", transactionDate: "September 6"),
            RecentTransaction(walletName: "grshn.ton", transactionDate: "EQCc…9ZLD"),
            RecentTransaction(walletName: "durov.ton", transactionDate: "EQCc…9ZLD")
        ]
    }
}
