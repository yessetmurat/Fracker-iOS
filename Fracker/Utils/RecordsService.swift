//
//  RecordsService.swift
//  Fracker
//
//  Created by Yesset Murat on 5/5/22.
//

import Foundation
import NetworkKit

protocol RecordsService {

    var commonStore: CommonStore { get }
    var networkService: NetworkService { get }

    func syncronize(completion: (() -> Void)?)

    func load(completion: @escaping (Result<[Record], NetworkError>) -> Void)
    func create(with amount: Decimal, category: Category, completion: () -> Void)
}
