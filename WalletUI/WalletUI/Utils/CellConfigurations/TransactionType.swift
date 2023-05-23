//
//  TransactionType.swift
//  WalletUI
//
//  Created by Aurocheg on 23.05.23.
//

import UIKit

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
