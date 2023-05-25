//
//  Data + Extension.swift
//  WalletUI
//
//  Created by Aurocheg on 25.05.23.
//

import Foundation

public extension Data {
    func hexString() -> String {
        reduce(into: "") {
            var s = String($1, radix: 16)
            if s.count == 1 {
              s = "0" + s
            }
            $0 += s
        }
    }
}
