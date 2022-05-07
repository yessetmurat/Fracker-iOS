//
//  LocalDatabaseManager.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import CoreData

class LocalDatabaseManager {

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Fracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func create<T: NSManagedObject>(completion: (T) -> Void) {
        let object = T(context: context)
        completion(object)
        saveContext()
    }

    func object<T: NSManagedObject>(with predicate: NSPredicate) throws -> T? {
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate

        let result = try context.fetch(request)
        return result.first
    }

    func all<T: NSManagedObject>(with predicate: NSPredicate? = nil) throws -> [T] {
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        let result = try context.fetch(request)
        return result
    }

    func delete<T: NSManagedObject>(object: T) {
        context.delete(object)
        saveContext()
    }
}
