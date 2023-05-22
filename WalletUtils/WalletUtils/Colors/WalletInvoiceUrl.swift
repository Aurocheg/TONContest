//
//  WalletInvoiceUrl.swift
//  WalletUtils
//
//  Created by Aurocheg on 21.05.23.
//

import Foundation

private let maxIntegral: Int64 = Int64.max / 1000000000

private func amountValue(_ string: String) -> Int64 {
    let string = string.replacingOccurrences(of: ",", with: ".")
    if let range = string.range(of: ".") {
        let integralPart = String(string[..<range.lowerBound])
        let fractionalPart = String(string[range.upperBound...])
        let string = integralPart + fractionalPart + String(repeating: "0", count: max(0, 9 - fractionalPart.count))
        return Int64(string) ?? 0
    } else if let integral = Int64(string) {
        if integral > maxIntegral {
            return 0
        }
        return integral * 1000000000
    }
    return 0
}

private func urlEncodedStringFromString(_ string: String) -> String {
    var nsString: NSString = string as NSString
    if let value = nsString.replacingPercentEscapes(using: String.Encoding.utf8.rawValue) {
        nsString = value as NSString
    }
    
    let result = CFURLCreateStringByAddingPercentEscapes(nil, nsString as CFString, nil, "?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ " as CFString, CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))!
    return result as String
}


public func walletInvoiceUrl(address: String, amount: String? = nil, comment: String? = nil) -> String {
    var arguments = ""
    if let amount = amount, !amount.isEmpty {
        arguments += arguments.isEmpty ? "?" : "&"
        arguments += "amount=\(amountValue(amount))"
    }
    if let comment = comment, !comment.isEmpty {
        arguments += arguments.isEmpty ? "?" : "&"
        arguments += "text=\(urlEncodedStringFromString(comment))"
    }
    return "ton://transfer/\(address)\(arguments)"
}
