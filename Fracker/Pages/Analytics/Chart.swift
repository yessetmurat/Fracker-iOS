//
//  Chart.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//

import Foundation

struct Chart {

    struct Item {

        let title: String
        let value: Float
    }

    let minimum: String
    let average: String
    let maximum: String
    let items: [Item]
}
