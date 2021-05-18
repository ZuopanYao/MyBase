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
        return true
    }
}

