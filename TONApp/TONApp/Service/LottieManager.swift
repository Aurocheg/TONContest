//
//  LottieManager.swift
//  TONApp
//
//  Created by Aurocheg on 3.04.23.
//

import Foundation
import Lottie

protocol LottieManagerProtocol {
    func applyAnimation(for view: LottieAnimationView, lottieType: LottieManager.Files)
    func applyAnimationWithProgress(for view: LottieAnimationView, lottieType: LottieManager.Files, toProgress: CGFloat)
}

final class LottieManager {
    public enum Files {
        static let type = "json"
        case congratulations
        case created
        case loading
        case main
        case password
        case recoveryPhrase
        case start
        case success
        case testTime
        case tooBad
        case waitingTon
        
        var path: String? {
            switch self {
            case .congratulations:
                return Bundle.main.path(forResource: "congratulations", ofType: Self.type)
            case .created:
                return Bundle.main.path(forResource: "created", ofType: Self.type)
            case .loading:
                return Bundle.main.path(forResource: "loading", ofType: Self.type)
            case .main:
                return Bundle.main.path(forResource: "main", ofType: Self.type)
            case .password:
                return Bundle.main.path(forResource: "password", ofType: Self.type)
            case .recoveryPhrase:
                return Bundle.main.path(forResource: "recovery_phrase", ofType: Self.type)
            case .start:
                return Bundle.main.path(forResource: "start", ofType: Self.type)
            case .success:
                return Bundle.main.path(forResource: "success", ofType: Self.type)
            case .testTime:
                return Bundle.main.path(forResource: "test_time", ofType: Self.type)
            case .tooBad:
                return Bundle.main.path(forResource: "too_bad", ofType: Self.type)
            case .waitingTon:
                return Bundle.main.path(forResource: "waiting_ton", ofType: Self.type)
            }
        }
    }
}

// MARK: - LottieManagerProtocol
extension LottieManager: LottieManagerProtocol {
    func applyAnimation(for view: LottieAnimationView, lottieType: Files) {
        guard let path = lottieType.path else { return }
        view.animation = LottieAnimation.filepath(path)
        view.play()
    }
    
    func applyAnimationWithProgress(for view: LottieAnimationView, lottieType: Files, toProgress: CGFloat) {
        guard let path = lottieType.path else { return }
        view.animation = LottieAnimation.filepath(path)
        view.play(fromProgress: .zero, toProgress: toProgress, loopMode: .playOnce)
    }
}

