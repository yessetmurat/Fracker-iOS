//
//  RecordsWorker.swift
//  Fracker
//
//  Created by Yesset Murat on 5/5/22.
//

import Foundation
import Network11

class RecordsWorker: RecordsService {

    unowned let commonStore: CommonStore
    let networkService: NetworkService

    private var localDatabaseManager: LocalDatabaseManager { commonStore.localDatabaseManager }

    init(commonStore: CommonStore) {
        self.commonStore = commonStore
        networkService = NetworkWorker(sessionAdapter: commonStore.sessionAdapter)
    }

    private func convert(_ localRecord: LocalRecord) -> RecordData {
        return RecordData(
            id: localRecord.id,
            amount: localRecord.amount.decimalValue,
            category: localRecord.category?.id
        )
    }
}

extension RecordsWorker {

    func syncronize(completion: (() -> Void)?) {
        guard commonStore.authorizationStatus == .authorized,
              let localRecords: [LocalRecord] = try? localDatabaseManager.all() else {
            return
        }

        let networkContext = RecordsBatchCreateNetworkContext(records: localRecords.map(convert))
        networkService.performRequest(using: networkContext) { _ in completion?() }
    }

    func load(completion: @escaping (Result<[Record], NetworkError>) -> Void) {

    }

    func create(with amount: Decimal, category: Category, completion: () -> Void) {
        let record = RecordData(id: UUID(), amount: amount, category: category.id)
        let predicate = NSPredicate(format: "id = %@", category.id.uuidString)

        guard let localCategory: LocalCategory = try? localDatabaseManager.object(with: predicate) else { return }

        localDatabaseManager.create { (object: LocalRecord) in
            object.id = record.id
            object.amount = NSDecimalNumber(decimal: record.amount)
            object.category = localCategory
        }

        if commonStore.authorizationStatus == .authorized {
            let networkContext = RecordCreateNetworkContext(data: record)
            networkService.performRequest(using: networkContext) { _ in }
        }

        completion()
    }
}
