//
//  Int64+fromNano.swift
//  WalletUI
//
//  Created by Aurocheg on 23.05.23.
//

import Foundation

public extension Int64 {
    func fromNano() -> Decimal {
        let nanoCoin: Int64 = 1_000_000_000
        return Decimal(self) / Decimal(nanoCoin)
    }
}
