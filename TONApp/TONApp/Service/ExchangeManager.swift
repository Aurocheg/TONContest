//
//  ExchangeManager.swift
//  TONApp
//
//  Created by Aurocheg on 25.05.23.
//

import Foundation
import WalletEntity

protocol ExchangeManagerProtocol {
    func getCurrenciesExchange(completion: @escaping (Result<ExchangeEntity, Error>) -> Void)
}

final class ExchangeManager {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private enum API {
        static let domain = "https://api.coingecko.com"
        static let currencies = "/api/v3/simple/price?ids=the-open-network&vs_currencies=usd,rub,eur"
    }
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }
}

extension ExchangeManager: ExchangeManagerProtocol {
    func getCurrenciesExchange(completion: @escaping (Result<ExchangeEntity, Error>) -> Void) {
        guard let url = URL(string: "\(API.domain)\(API.currencies)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String: Any],
                      let openNetworkDict = jsonDict["the-open-network"] as? [String: Double] else {
                    return
                }
                
                let usd = openNetworkDict["usd"] ?? 0.0
                let rub = openNetworkDict["rub"] ?? 0.0
                let eur = openNetworkDict["eur"] ?? 0.0
                
                let exchangeEntity = ExchangeEntity(usd: usd, rub: rub, eur: eur)
                completion(.success(exchangeEntity))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
