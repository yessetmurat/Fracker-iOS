//
//  CategoriesWorker.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import BaseKit
import NetworkKit

class CategoriesWorker: CategoriesService {

    unowned let commonStore: CommonStore
    let networkService: NetworkService

    private var localDatabaseManager: LocalDatabaseManager { commonStore.localDatabaseManager }

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
        networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
    }

    private func convert(_ localCategory: LocalCategory) -> Category {
        return Category(
            id: localCategory.id,
            emoji: localCategory.emoji,
            name: localCategory.name,
            createdAt: localCategory.createdAt,
            deletedAt: localCategory.deletedAt
        )
    }
}

extension CategoriesWorker {

    func syncronize(completion: (() -> Void)?) {
        guard commonStore.authorizationStatus == .authorized,
              let localCategories: [LocalCategory] = try? localDatabaseManager.all() else {
            return
        }

        let networkContext = CategoriesBatchCreateNetworkContext(categories: localCategories.map(convert))
        networkService.performRequest(using: networkContext) { _ in completion?() }
    }

    func load(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        let predicate = NSPredicate(format: "deletedAt = nil")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(LocalCategory.createdAt), ascending: true)

        guard let localCategories: [LocalCategory] =
                try? localDatabaseManager.all(with: predicate, sortDescriptors: [sortDescriptor]) else {
            return
        }

        let categories = localCategories.map(convert)
        completion(.success(categories))

        if commonStore.authorizationStatus == .authorized {
            let networkContext = CategoriesNetworkContext()
            networkService.performRequest(
                using: networkContext
            ) { [weak self] (result: Result<[Category], NetworkError>) in
                guard let service = self else { return }

                switch result {
                case .success(let categories):
                    categories.forEach { category in
                        service.localDatabaseManager.create { (object: LocalCategory) in
                            object.id = category.id
                            object.emoji = category.emoji
                            object.name = category.name
                            object.createdAt = category.createdAt ?? Date()
                            object.deletedAt = category.deletedAt
                        }
                    }

                    if let localCategories: [LocalCategory] =
                        try? service.localDatabaseManager.all(with: predicate, sortDescriptors: [sortDescriptor]) {
                        let categories = localCategories.map(service.convert)
                        completion(.success(categories))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func create(withEmoji emoji: String, name: String, completion: @escaping () -> Void) {
        let category = Category(id: UUID(), emoji: emoji, name: name, createdAt: Date(), deletedAt: nil)

        localDatabaseManager.create { (object: LocalCategory) in
            object.id = category.id
            object.emoji = category.emoji
            object.name = category.name
            object.createdAt = category.createdAt ?? Date()
        }

        if commonStore.authorizationStatus == .authorized {
            let networkContext = CategoryCreateNetworkContext(data: category)
            networkService.performRequest(using: networkContext) { _ in }
        }

        completion()
    }

    func delete(with id: UUID, completion: @escaping () -> Void) {
        let predicate = NSPredicate(format: "id = %@", id.uuidString)

        try? localDatabaseManager.update(with: predicate) { (object: LocalCategory) in
            object.deletedAt = Date()
        }

        if commonStore.authorizationStatus == .authorized {
            let networkContext = CategoryRemoveNetworkContext(id: id.uuidString)
            networkService.performRequest(using: networkContext) { _ in }
        }

        completion()
    }
}
