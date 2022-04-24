//
//  RecordInteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol RecordInteractorInput: AnyObject, InteractorInput {

    func loadCategories()
    func createCategory(with name: String)
    func removeCategory(at indexPath: IndexPath)
    func changeRecord(symbol: String)
    func didSelectCategory(at indexPath: IndexPath)
}
