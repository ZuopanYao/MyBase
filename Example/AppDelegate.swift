//
//  AppDelegate.swift
//  Example
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import MyBase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Logger.isDebug = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        puts(window!.safeAreaInsets)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            UINavigationController(rootViewController: ViewController()),
            UINavigationController(rootViewController: ViewController()),
            UINavigationController(rootViewController: ViewController())
        ]
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        puts(UIScreen.main.bounds)
        return true
    }
}

