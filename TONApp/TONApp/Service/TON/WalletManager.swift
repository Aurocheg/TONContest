//
//  TonWalletManager.swift
//  TONApp
//
//  Created by Aurocheg on 17.05.23.
//

import Foundation
import SwiftyTON

enum WalletManagerErrors: Error {
    case unvalidURL
    case invalidAddress
    case invalidWallet
    case keyNotFoundInMemory
    case keyWordsNotFoundInMemory
    case walletNotFoundInMemory
}

protocol WalletManagerProtocol {
    func createKey() async throws -> Key
    func getWords(key: Key) async throws -> [String]
    func importWallet(_ words: [String]) async throws -> Key
    
    func createWallet3(key: Key, revision: Wallet3.Revision) async throws -> Wallet3
    func createWallet4(key: Key, revision: Wallet4.Revision) async throws -> Wallet4
    
    func getAnyWallet(key: Key, revision: Wallet4.Revision) async throws -> AnyWallet
    func getWallet3(key: Key, revision: Wallet3.Revision) async throws -> Wallet3
    func getWallet4(key: Key, revision: Wallet4.Revision) async throws -> Wallet4
        
    func getMessage(
        wallet: Wallet4,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message
    func getMessage(
        wallet: Wallet3,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message
    func getMessage(
        wallet: AnyWallet,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message
}

final class WalletManager {
    // MARK: - Properties
    static let shared: WalletManager = .init()
    
    private let passcode = "parole"
    private var passcodeData: Data {
        Data(passcode.utf8)
    }

    // MARK: - Initializer
    private init() {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            fatalError("There is an error with created URL in WalletManager.swift")
        }
        SwiftyTON.configurate(with: .init(network: .main, logging: .info, keystoreURL: url))
    }
}

// MARK: - WalletManagerProtocol
extension WalletManager: WalletManagerProtocol {
    func createKey() async throws -> Key {
        try await Key.create(password: passcodeData)
    }
    
    func getWords(key: Key) async throws -> [String] {
        try await key.words(password: passcodeData)
    }

    func importWallet(_ words: [String]) async throws -> Key {
        try await Key.import(password: passcodeData, words: words)
    }

    func createWallet3(key: Key, revision: Wallet3.Revision = .r2) async throws -> Wallet3 {
        let initialState = try await Wallet3.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )

        guard let address = await Address.init(initial: initialState) else {
            throw WalletManagerErrors.invalidAddress
        }
    
        var contract = try await Contract(address: address)
        let selectedContractInfo = contract.info

        switch contract.kind {
        case .none:
            fatalError()
        case .uninitialized: // for uninited state we should pass initial data
            contract = Contract(
                address: address,
                info: selectedContractInfo,
                kind: .walletV3R2,
                data: .zero // will be created automatically
            )
        default:
            break
        }

        guard let wallet = Wallet3(contract: contract) else {
            throw WalletManagerErrors.invalidWallet
        }

        return wallet
    }

    func getAnyWallet(key: Key, revision: Wallet4.Revision = .r2) async throws -> AnyWallet {
        let initialState = try await Wallet4.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )

        guard let address = await Address.init(initial: initialState) else {
            throw WalletManagerErrors.invalidAddress
        }

        var contract = try await Contract(address: address)
        let selectedContractInfo = contract.info

        switch contract.kind {
        case .none:
            fatalError()
        case .uninitialized:
            contract = Contract(
                address: address,
                info: selectedContractInfo,
                kind: .walletV3R2,
                data: .init(code: passcodeData)
            )
        default:
            break
        }

        guard let wallet = AnyWallet(contract: contract) else {
            throw WalletManagerErrors.invalidWallet
        }

        return wallet
    }
    
    func getWallet3(key: Key, revision: Wallet3.Revision = .r2) async throws -> Wallet3 {
        let initialState = try await Wallet3.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )

        guard let address = await Address.init(initial: initialState) else {
            throw WalletManagerErrors.invalidAddress
        }

        var contract = try await Contract(address: address)
        let selectedContractInfo = contract.info

        switch contract.kind {
        case .none:
            fatalError()
        case .uninitialized:
            contract = Contract(
                address: address,
                info: selectedContractInfo,
                kind: .walletV3R2,
                data: .init(code: passcodeData)
            )
        default:
            break
        }

        guard let wallet = Wallet3(contract: contract) else {
            throw WalletManagerErrors.invalidWallet
        }

        return wallet
    }
    
    func getWallet4(key: Key, revision: Wallet4.Revision = .r2) async throws -> Wallet4 {
        let initialState = try await Wallet4.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )

        guard let address = await Address.init(initial: initialState) else {
            throw WalletManagerErrors.invalidAddress
        }

        var contract = try await Contract(address: address)
        let selectedContractInfo = contract.info

        switch contract.kind {
        case .none:
            fatalError()
        case .uninitialized:
            contract = Contract(
                address: address,
                info: selectedContractInfo,
                kind: .walletV4R2,
                data: .init(code: passcodeData)
            )
        default:
            break
        }

        guard let wallet = Wallet4(contract: contract) else {
            throw WalletManagerErrors.invalidWallet
        }

        return wallet
    }
    
    func getWalletAddress(key: Key, revision: Wallet4.Revision) async throws -> Address {
        let initialState = try await Wallet4.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )
        
        guard let address = await Address(initial: initialState) else {
            fatalError()
        }
        
        return address
    }

    func createWallet4(key: Key, revision: Wallet4.Revision = .r2) async throws -> Wallet4 {
        let initialState = try await Wallet4.initial(
            revision: revision,
            deserializedPublicKey: try key.deserializedPublicKey()
        )
        guard let address = await Address.init(initial: initialState) else {
            throw WalletManagerErrors.invalidAddress
        }
        var contract = try await Contract(address: address)
        let selectedContractInfo = contract.info
        switch contract.kind {
        case .none:
            fatalError()
        case .uninitialized: // for uninited state we should pass initial data
            contract = Contract(
                address: address,
                info: selectedContractInfo,
                kind: .walletV4R2,
                data: .zero // will be created automatically
            )
        default:
            break
        }
        guard let wallet = Wallet4(contract: contract) else {
            throw WalletManagerErrors.invalidWallet
        }
        return wallet
    }

    func getMessage(
        wallet: Wallet4,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message {
        guard let displayableAddress = await DisplayableAddress(string: address) else {
            throw WalletManagerErrors.invalidAddress
        }
        return try await wallet.subsequentTransferMessage(
            to: displayableAddress.concreteAddress,
            amount: Currency(value: amount)!,
            message: (comment.data(using: .utf8), nil),
            key: key,
            passcode: passcodeData
        )
    }
    
    func getMessage(
        wallet: Wallet3,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message {
        guard let displayableAddress = await DisplayableAddress(string: address) else {
            throw WalletManagerErrors.invalidAddress
        }
        return try await wallet.subsequentTransferMessage(
            to: displayableAddress.concreteAddress,
            amount: Currency(value: amount)!,
            message: (comment.data(using: .utf8), nil),
            key: key,
            passcode: passcodeData
        )
    }

    func getMessage(
        wallet: AnyWallet,
        with key: Key,
        to address: String,
        with amount: String,
        comment: String
    ) async throws -> Message {
        guard let displayableAddress = await DisplayableAddress(string: address) else { throw WalletManagerErrors.invalidAddress
        }
        return try await wallet.subsequentTransferMessage(
            to: displayableAddress.concreteAddress,
            amount: Currency(value: amount)!,
            message: (comment.data(using: .utf8), nil),
            key: key,
            passcode: passcodeData
        )
    }
}
