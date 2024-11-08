//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Alexander Bralnin on 27.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        
        if UserDefaults.standard.isOnboarded {
            let tabBarController = MainTabBarController()
            tabBarController.addTabItems()
            window?.rootViewController = tabBarController
        } else {
            let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            window?.rootViewController = pageViewController
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

