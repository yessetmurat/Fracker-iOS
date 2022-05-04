//
//  RecordData.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//

import Foundation

struct RecordData: Encodable {

    let id: UUID?
    let amount: Decimal?
    let category: UUID?
}
