//
//  TonKeyStoreManager.swift
//  TONApp
//
//  Created by Aurocheg on 17.05.23.
//

import Foundation
import SwiftyTON

protocol KeystoreManagerProtocol {
    func loadKey() async throws -> Key?
    func loadWallet2() async throws -> Wallet2?
    func loadWallet3() async throws -> Wallet3?
    func loadWallet4() async throws -> Wallet4?
    func save(key: Key) async throws
    func save(wallet2: Wallet2) async throws
    func save(wallet3: Wallet3) async throws
    func save(wallet4: Wallet4) async throws
}

@MainActor
final class KeystoreManager: ObservableObject {
    static var shared: KeystoreManager = .init()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private static func keyURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("Key.data")
    }

    private static func walletURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("Wallet.data")
    }
}

extension KeystoreManager: KeystoreManagerProtocol {
    func loadKey() async throws -> Key? {
        let task = Task<Key?, Error> {
            let fileURL = try Self.keyURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let tonKey = try decoder.decode(Key.self, from: data)
            return tonKey
        }
        return try await task.value
    }

    func loadWallet2() async throws -> Wallet2? {
        let task = Task<Wallet2?, Error> {
            let fileURL = try Self.walletURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let wallet = try decoder.decode(Wallet2.self, from: data)
            return wallet
        }
        return try await task.value
    }
    
    func loadWallet3() async throws -> Wallet3? {
        let task = Task<Wallet3?, Error> {
            let fileURL = try Self.walletURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let wallet = try decoder.decode(Wallet3.self, from: data)
            return wallet
        }
        return try await task.value
    }
    
    func loadWallet4() async throws -> Wallet4? {
        let task = Task<Wallet4?, Error> {
            let fileURL = try Self.walletURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let wallet = try decoder.decode(Wallet4.self, from: data)
            return wallet
        }
        return try await task.value
    }

    func save(key: Key) async throws {
        let task = Task {
            let data = try encoder.encode(key)
            let outfile = try Self.keyURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func save(wallet2: Wallet2) async throws {
        let task = Task {
            let data = try encoder.encode(wallet2)
            let outfile = try Self.walletURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func save(wallet3: Wallet3) async throws {
        let task = Task {
            let data = try encoder.encode(wallet3)
            let outfile = try Self.walletURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func save(wallet4: Wallet4) async throws {
        let task = Task {
            let data = try encoder.encode(wallet4)
            let outfile = try Self.walletURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
