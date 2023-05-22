//
//  SceneDelegate.swift
//  TONApp
//
//  Created by Aurocheg on 23.03.23.
//

import UIKit
import WalletUI
import SwiftyTON

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let databaseManager = DatabaseManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootVC: UIViewController
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navigationController: UINavigationController
        
        if let isWalletCreated = databaseManager.getAppState(), isWalletCreated,
           let _ = databaseManager.getPassword() {
            rootVC = LockViewController(lockType: .beforeMain)
            navigationController = NavigationController(rootViewController: rootVC)
        } else {
            rootVC = StartViewController()
            navigationController = UINavigationController(rootViewController: rootVC)
        }
                        
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        guard let isWalletCreated = databaseManager.getAppState(), isWalletCreated else {
            return
        }
        
        if url.scheme == "ton" {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            
            if let _ = databaseManager.getPassword() {
                let lockVC = LockViewController(
                    lockType: .beforeMain,
                    deepLinkAddress: url.absoluteString
                )
                let navigationController = NavigationController(rootViewController: lockVC)
                
                window?.overrideUserInterfaceStyle = .light
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            } else {
                return
            }
        }
    }
}
