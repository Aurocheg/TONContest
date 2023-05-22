//
//  String+Extension.swift
//  WalletUtils
//
//  Created by Aurocheg on 20.05.23.
//

import Foundation

public extension String {
    func splitString(by: String = "…", numberOfCharacters: Int = 8) -> String {
        replacingOccurrences(
            of: dropFirst(numberOfCharacters / 2).dropLast(numberOfCharacters / 2),
            with: by
        )
    }
}
