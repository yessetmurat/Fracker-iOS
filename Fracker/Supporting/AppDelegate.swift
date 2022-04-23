//
//  AppDelegate.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import UIKit
import CoreData
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

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Fracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

