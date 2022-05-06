//
//  CategoriesService.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import BaseKit
import NetworkKit

protocol CategoriesService {

    var commonStore: CommonStore { get }
    var networkService: NetworkService { get }

    func createDefaultCategoriesIfNeeded()
    func syncronize(completion: (() -> Void)?)

    func load(completion: @escaping (Result<[Category], NetworkError>) -> Void)
    func create(withEmoji emoji: String, name: String, completion: @escaping () -> Void)
    func delete(with id: UUID, completion: @escaping () -> Void)
}
