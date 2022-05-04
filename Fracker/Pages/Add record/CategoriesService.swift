//
//  CategoriesService.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation
import Base
import Network11

protocol CategoriesService {

    var commonStore: CommonStore { get }
    var networkService: NetworkService { get }
    var procedureCallManager: ProcedureCallManager { get }

    func createDefaultCategoriesIfNeeded()
    func syncronize()
    func load(completion: @escaping (Result<[Category], NetworkError>) -> Void)
    func create(withEmoji emoji: String, name: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func delete(with id: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
