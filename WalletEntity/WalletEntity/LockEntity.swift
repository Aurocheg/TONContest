//
//  LockEntity.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit

public enum LockCellConfiguration {
    case number
    case numberWithText
    case faceId
    case backspace
    
    static let color: UIColor = .white
    
    public var image: UIImage? {
        switch self {
        case .faceId:
            return UIImage(systemName: "faceid")?
                .withTintColor(Self.color, renderingMode: .alwaysOriginal)
        case .backspace:
            return UIImage(systemName: "delete.backward.fill")?
                .withTintColor(Self.color, renderingMode: .alwaysOriginal)
        default:
            return nil
        }
    }
}

public protocol LockEntity {
    var number: Int? { get }
    var text: String? { get }
    var configuration: LockCellConfiguration { get }
}

public struct Lock: LockEntity {
    public var number: Int?
    public var text: String?
    public var configuration: LockCellConfiguration
    
    public init(number: Int? = nil, text: String? = nil, configuration: LockCellConfiguration) {
        self.number = number
        self.text = text
        self.configuration = configuration
    }
    
    public static func getItems() -> [[LockEntity]] {
        [
            [
                Lock(number: 1, configuration: .number),
                Lock(number: 2, text: "ABC", configuration: .numberWithText),
                Lock(number: 3, text: "DEF", configuration: .numberWithText)
            ],
            [
                Lock(number: 4, text: "GHI", configuration: .numberWithText),
                Lock(number: 5, text: "JKL", configuration: .numberWithText),
                Lock(number: 6, text: "MNO", configuration: .numberWithText)
            ],
            [
                Lock(number: 7, text: "PQRS", configuration: .numberWithText),
                Lock(number: 8, text: "TUV", configuration: .numberWithText),
                Lock(number: 9, text: "WXYZ", configuration: .numberWithText),
            ],
            [
                Lock(configuration: .faceId),
                Lock(number: 0, text: "+", configuration: .numberWithText),
                Lock(configuration: .backspace)
            ]
        ]
    }
}
