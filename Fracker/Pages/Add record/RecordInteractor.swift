//
//  RecordInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Network11
import Base

class RecordInteractor {

    private unowned let view: RecordViewInput
    private unowned let commonStore: CommonStore
    private let networkService: NetworkService

    private var amountString: String = ""
    private var categories: [Category] = []
    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: BaseFont.semibold.withSize(64), .foregroundColor: BaseColor.black]
    }
    private var textFormatter: AmountFormatter { AmountFormatter(useCommaSeparator: false, attributes: attributes) }
    private let textValidator = AmountTextValidator()

    init(view: RecordViewInput, commonStore: CommonStore, networkService: NetworkService) {
        self.view = view
        self.commonStore = commonStore
        self.networkService = networkService
    }
}

extension RecordInteractor {

    private func loadRemoteCategories(completion: @escaping ([Category]) -> Void) {
        let networkContext = CategoriesNetworkContext()
        networkService.performRequest(
            using: networkContext
        ) { [weak self] (result: Result<[Category], NetworkError>) in
            guard let interactor = self else { return }

            switch result {
            case .success(let categories):
                completion(categories)
            case .failure(let error):
                interactor.show(networkError: error, view: interactor.view)
            }
        }
    }

    private func loadLocalCategories(completion: ([Category]) -> Void) {
        do {
            try commonStore.localDatabaseManager.all { (localCategories: [LocalCategory]) in
                let categories: [Category] = localCategories.compactMap { localCategory in
                    guard let name = localCategory.name else { return nil }
                    return Category(id: localCategory.id, name: name)
                }

                completion(categories)
            }
        } catch {
            show(networkError: .dataLoad, view: view)
        }
    }

    private func createLocalCategory(with name: String, completion: () -> Void) {
        commonStore.localDatabaseManager.create { (category: LocalCategory) in
            category.id = UUID()
            category.name = name
        }

        completion()
    }

    private func createRemoteCategory(with name: String, completion: @escaping () -> Void) {
        let networkContext = CreateCategoryNetworkContext(name: name)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self, !interactor.handleFailure(response: response, view: interactor.view) else {
                return
            }

            completion()
        }
    }

    private func removeLocalCategory(with id: String, completion: @escaping () -> Void) {
        let predicate = NSPredicate(format: "id = %@", id)

        do {
            try commonStore.localDatabaseManager.object(with: predicate) { [weak self] (category: LocalCategory?) in
                guard let interactor = self, let category = category else { return }
                interactor.commonStore.localDatabaseManager.delete(object: category)
                completion()
            }
        } catch {
            show(localError: .message("Unable to delete category"), view: view)
        }
    }

    private func removeRemoteCategory(with id: String, completion: @escaping () -> Void) {
        let networkContext = RemoveCategoryNetworkContext(id: id)
        networkService.performRequest(using: networkContext) { [weak self] response in
            guard let interactor = self, !interactor.handleFailure(response: response, view: interactor.view) else {
                return
            }

            completion()
        }
    }

    private func addLocalRecord(for category: Category, with amount: Decimal, completion: () -> Void) {
        guard let id = category.id?.uuidString else { return }

        do {
            let predicate = NSPredicate(format: "id = %@", id)
            try commonStore.localDatabaseManager.object(with: predicate) { (localCategory: LocalCategory?) in
                commonStore.localDatabaseManager.create { (record: LocalRecord) in
                    record.id = UUID()
                    record.amount = NSDecimalNumber(decimal: amount)
                    record.category = localCategory
                }
            }

            completion()
        } catch {
            show(networkError: .dataLoad, view: view)
        }
    }

    private func addRemoteRecord(for category: Category, with amount: Decimal, completion: @escaping () -> Void) {

    }
}

extension RecordInteractor: RecordInteractorInput {

    func loadCategories() {
        let completion: (Array<Category>) -> Void = { [weak self] categories in
            guard let interactor = self else { return }
            defer { interactor.view.pass(isLoading: false) }

            interactor.categories = categories
            interactor.view.pass(categories: categories)
        }

        if commonStore.isAuthorized {
            loadRemoteCategories(completion: completion)
        } else {
            loadLocalCategories(completion: completion)
        }
    }

    func createCategory(with name: String) {
        let completion: () -> Void = { [weak self] in
            guard let interactor = self else { return }
            interactor.loadCategories()
        }

        if commonStore.isAuthorized {
            createRemoteCategory(with: name, completion: completion)
        } else {
            createLocalCategory(with: name, completion: completion)
        }
    }

    func removeCategory(at indexPath: IndexPath) {
        guard let id = categories[indexPath.item].id?.uuidString else { return }

        let completion: () -> Void = { [weak self] in
            guard let interactor = self else { return }

            interactor.categories.remove(at: indexPath.item)
            interactor.view.pass(categories: interactor.categories)
            interactor.view.reloadCollectionView()
        }

        if commonStore.isAuthorized {
            removeRemoteCategory(with: id, completion: completion)
        } else {
            removeLocalCategory(with: id, completion: completion)
        }
    }

    func changeRecord(symbol: String) {
        var tempString = amountString == "0" ? "" : amountString

        if let amount = symbol.amount {
            tempString += amount.description
        } else if symbol == "." {
            tempString += symbol
        } else if symbol == "delete" {
            tempString = amountString.dropLast().description
        }

        if textValidator.validateCharacters(in: tempString) {
            amountString = tempString
            let result = textFormatter.apply(to: amountString)
            view.setRecord(result: result)
        }
    }

    func didSelectCategory(at indexPath: IndexPath) {
        guard let amount = amountString.amount, amount > 0 else {
            view.deselectItem(at: indexPath)
            return view.shake()
        }

        let completion: () -> Void = { [weak self] in
            guard let interactor = self else { return }
            interactor.amountString = ""
            interactor.view.deselectItem(at: indexPath)
            interactor.view.resetAmountAnimated()
        }

        if commonStore.isAuthorized {

        } else {
            addLocalRecord(for: categories[indexPath.item], with: amount, completion: completion)
        }
    }
}
