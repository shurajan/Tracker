//
//  AppDelegate.swift
//  Tracker
//
//  Created by Alexander Bralnin on 27.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {ß
        window = UIWindow()
        window?.rootViewController = DarkStatusBarViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

