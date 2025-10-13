//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let coordinator = Coordinator()
        let tabBar = coordinator.start()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        self.coordinator = coordinator
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
