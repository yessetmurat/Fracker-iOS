//
//  RecordInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import NetworkKit
import BaseKit

class RecordInteractor {

    private unowned let view: RecordViewInput
    private unowned let commonStore: CommonStore
    private let categoriesService: CategoriesService
    private let recordsService: RecordsService

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: BaseFont.semibold.withSize(64), .foregroundColor: BaseColor.black]
    }

    private var textFormatter: AmountFormatter {
        return AmountFormatter(useCommaSeparator: false, attributes: attributes)
    }

    private let textValidator = AmountTextValidator()

    private var amountString = ""
    private var categories: [Category] = []

    init(view: RecordViewInput, commonStore: CommonStore) {
        self.view = view
        self.commonStore = commonStore
        categoriesService = CategoriesWorker(commonStore: commonStore)
        recordsService = RecordsWorker(commonStore: commonStore)

        categoriesService.createDefaultCategoriesIfNeeded()
        categoriesService.syncronize(completion: nil)

        recordsService.syncronize(completion: nil)
    }

    private func deselectWithDelay(at indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in self?.view.deselectItem(at: indexPath) }
    }
}

extension RecordInteractor: RecordInteractorInput {

    func didTapOnLeftButton() {
        guard commonStore.authorizationStatus == .none else { return }
        view.presentAuthorizationPage()
    }

    func loadCategories() {
        categoriesService.load { [weak self] result in
            guard let interactor = self else { return }

            interactor.view.pass(isLoading: false)

            switch result {
            case .success(let categories):
                interactor.categories = categories
                interactor.view.pass(categories: interactor.categories)
                interactor.view.reloadCollectionView()
            case .failure:
                return
            }
        }
    }

    func createCategory(withEmoji emoji: String, name: String) {
        categoriesService.create(withEmoji: emoji, name: name) { [weak self] in self?.loadCategories() }
    }

    func removeCategory(at indexPath: IndexPath) {
        let id = categories[indexPath.item].id

        categoriesService.delete(with: id) { [weak self] in
            guard let interactor = self else { return }

            interactor.categories.remove(at: indexPath.item)
            interactor.view.pass(categories: interactor.categories)
            interactor.view.reloadCollectionView()
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
            deselectWithDelay(at: indexPath)
            return view.shake()
        }

        recordsService.create(with: amount, category: categories[indexPath.item]) { [weak self] in
            guard let interactor = self else { return }

            interactor.amountString = ""
            interactor.view.moveAmountToCategory(at: indexPath)
            interactor.deselectWithDelay(at: indexPath)
        }
    }
}
