//
//  CurrencyNames.swift
//  WalletEntity
//
//  Created by Aurocheg on 23.05.23.
//

import Foundation

public enum CurrencyConstants: String {
    case dollar = "USD"
    case euro = "EUR"
    case rub = "RUB"
    
    public var indication: String {
        switch self {
        case .dollar:
            return "$"
        case .euro:
            return "€"
        case .rub:
            return "₽"
        }
    }
}
