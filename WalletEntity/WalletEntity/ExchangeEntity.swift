//
//  ExchangeEntity.swift
//  WalletEntity
//
//  Created by Aurocheg on 25.05.23.
//

import Foundation

public struct ExchangeEntity {
    public let usd: Double
    public let rub: Double
    public let eur: Double
    
    public init(usd: Double, rub: Double, eur: Double) {
        self.usd = usd
        self.rub = rub
        self.eur = eur
    }
}
