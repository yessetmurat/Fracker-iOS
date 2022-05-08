//
//  AppDelegate.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import UIKit
import BaseKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let commonStore = CommonStore()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let router = InitialRouter(commonStore: commonStore, window: window)
        let viewController = router.compose()

        window.rootViewController = viewController

        self.window = window

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

