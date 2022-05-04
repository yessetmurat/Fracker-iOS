//
//  CategoriesWorker.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import Base
import Network11

class CategoriesWorker: CategoriesService {

    unowned let commonStore: CommonStore
    let networkService: NetworkService
    let procedureCallManager: ProcedureCallManager

    private var localDatabaseManager: LocalDatabaseManager { commonStore.localDatabaseManager }

    private var networkError: NetworkError?
    private var categories: [Category] = []

    init(commonStore: CommonStore) {
        self.commonStore = commonStore

        networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
        procedureCallManager = ProcedureCallManager()
    }

    private func convert(_ localCategory: LocalCategory) -> Category {
        return Category(id: localCategory.id, emoji: localCategory.emoji, name: localCategory.name)
    }
}

extension CategoriesWorker {

    private var loadLocalCategoriesItem: ProcedureCallItem {
        return ProcedureCallItem { [weak self] completion in
            guard let service = self,
                  let localCategories: [LocalCategory] = try? service.localDatabaseManager.all() else {
                return completion()
            }

            service.categories = localCategories.compactMap(service.convert)
            completion()
        }
    }

    private var loadRemoteCategoriesItem: ProcedureCallItem {
        return ProcedureCallItem { [weak self] completion in
            guard let service = self, service.commonStore.isAuthorized else { return completion() }

            let networkContext = CategoriesNetworkContext()
            service.networkService.performRequest(
                using: networkContext
            ) { [weak service] (result: Result<[Category], NetworkError>) in
                guard let service = service else { return }

                switch result {
                case .success(let categories):
                    categories.forEach { category in
                        service.localDatabaseManager.create { (object: LocalCategory) in
                            object.id = category.id
                            object.emoji = category.emoji
                            object.name = category.name
                        }
                    }

                    if let localCategories: [LocalCategory] = try? service.localDatabaseManager.all() {
                        service.categories = localCategories.map(service.convert)
                    }
                case .failure(let error):
                    service.networkError = error
                }

                completion()
            }
        }
    }

    func createDefaultCategoriesIfNeeded() {
        guard let localCategories: [LocalCategory] = try? localDatabaseManager.all(), localCategories.isEmpty else {
            return
        }

        Constants.defaultCategories.forEach { category in
            localDatabaseManager.create { (object: LocalCategory) in
                object.id = category.id
                object.emoji = category.emoji
                object.name = category.name
            }
        }
    }

    func syncronize() {
        guard let localCategories: [LocalCategory] = try? localDatabaseManager.all() else { return }

        let networkContext = BatchCreateCategoryNetworkContext(categories: localCategories.map(convert))
        networkService.performRequest(using: networkContext) { _ in }
    }

    func load(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        procedureCallManager.items.removeAll()
        procedureCallManager.items = [loadLocalCategoriesItem, loadRemoteCategoriesItem]
        procedureCallManager.perform(inSequence: true) { [weak self] in
            guard let service = self else { return }

            if let networkError = service.networkError {
                completion(.failure(networkError))
            } else {
                completion(.success(service.categories))
            }
        }
    }

    func create(withEmoji emoji: String, name: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {

    }

    func delete(with id: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {

    }
}
