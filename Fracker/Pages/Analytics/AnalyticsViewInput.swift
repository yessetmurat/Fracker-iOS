//
//  AnalyticsViewInput.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import BaseKit
import Foundation

protocol AnalyticsViewInput: BaseViewInput {

    func pass(sections: [AnalyticsSection])
    func pass(isLoading: Bool)
    func reloadData()
    func update(section: AnalyticsSection, at index: Int)
}
