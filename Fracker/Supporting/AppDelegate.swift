//
//  AppDelegate.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import UIKit
import Base

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
        
        let router = RecordRouter(commonStore: commonStore)
        let viewController = router.compose()
        let navigationController = BaseNavigationController(rootViewController: viewController)

        window.rootViewController = navigationController

        self.window = window

        return true
    }
}

