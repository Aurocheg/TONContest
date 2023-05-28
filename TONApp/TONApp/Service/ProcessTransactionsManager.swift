//
//  ProcessTransactionsManager.swift
//  TONApp
//
//  Created by Aurocheg on 23.05.23.
//

import WalletEntity
import SwiftyTON

protocol ProcessTransactionsManagerProtocol {
    func distributeTransactionsByDate(_ transactions: [Transaction]) -> [TransactionEntity]
}

final class ProcessTransactionsManager {
    private let dateFormatter = DateFormatter()
    
    init(dateFormat: String = "MMMM d") {
        dateFormatter.dateFormat = dateFormat
    }
}

private extension ProcessTransactionsManager {
    func sortTransactionsByDate(_ transactions: [TransactionEntity]) -> [TransactionEntity] {
        var updatedTransactions = transactions
        updatedTransactions.sort { (transaction1, transaction2) -> Bool in
            if let date1 = dateFormatter.date(from: transaction1.date),
               let date2 = dateFormatter.date(from: transaction2.date) {
                return date1 > date2
            }
            return false
        }
        return updatedTransactions
    }
}

extension ProcessTransactionsManager: ProcessTransactionsManagerProtocol {
    func distributeTransactionsByDate(_ transactions: [Transaction]) -> [TransactionEntity] {
        var transactionEntities: [TransactionEntity] = []
        var dateTransactionsMap: [String: [Transaction]] = [:]
        
        for transaction in transactions {
            let dateString = dateFormatter.string(from: transaction.date)
            var dateTransactions = dateTransactionsMap[dateString] ?? []
            dateTransactions.append(transaction)
            dateTransactionsMap[dateString] = dateTransactions
        }
        
        for (dateString, transactions) in dateTransactionsMap {
            let transactionEntity = TransactionEntity(date: dateString, transactions: transactions)
            transactionEntities.append(transactionEntity)
        }
        
        transactionEntities = sortTransactionsByDate(transactionEntities)
        
        return transactionEntities
    }
}
