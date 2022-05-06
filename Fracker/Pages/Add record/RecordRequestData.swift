//
//  RecordRequestData.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation

struct RecordRequestData: Encodable {

    let id: UUID
    let amount: Decimal
    let category: UUID?
}
