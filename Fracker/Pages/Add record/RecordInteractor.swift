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
    private let categoriesService: CategoriesService

    private var amountString = ""
    private var categories: [Category] = []

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: BaseFont.semibold.withSize(64), .foregroundColor: BaseColor.black]
    }

    private var textFormatter: AmountFormatter {
        return AmountFormatter(useCommaSeparator: false, attributes: attributes)
    }

    private let textValidator = AmountTextValidator()

    init(view: RecordViewInput, categoriesService: CategoriesService) {
        self.view = view
        self.categoriesService = categoriesService

        categoriesService.createDefaultCategoriesIfNeeded()
    }
}

extension RecordInteractor: RecordInteractorInput {

    func loadCategories() {
        categoriesService.load { [weak self] result in
            guard let interactor = self else { return }

            interactor.view.pass(isLoading: false)

            switch result {
            case .success(let categories):
                interactor.categories = categories
                interactor.view.pass(categories: interactor.categories)
                interactor.view.reloadCollectionView()
                interactor.categoriesService.syncronize()
            case .failure:
                return
            }
        }
    }

    func createCategory(withEmoji emoji: String, name: String) {

    }

    func removeCategory(at indexPath: IndexPath) {
//        guard let id = categories[indexPath.item].id?.uuidString else { return }
//
//        let completion: () -> Void = { [weak self] in
//            guard let interactor = self else { return }
//
//            interactor.categories.remove(at: indexPath.item)
//            interactor.view.pass(categories: interactor.categories)
//            interactor.view.reloadCollectionView()
//        }
//
//        if commonStore.isAuthorized {
//            removeRemoteCategory(with: id, completion: completion)
//        } else {
//            removeLocalCategory(with: id, completion: completion)
//        }
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
            interactor.view.moveAmountToCategory(at: indexPath)
        }

//        if commonStore.isAuthorized {
//            addRemoteRecord(for: categories[indexPath.item], with: amount, completion: completion)
//        } else {
//            addLocalRecord(for: categories[indexPath.item], with: amount, completion: completion)
//        }
    }
}
