//
//  RecordViewInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Base

protocol RecordViewInput: BaseViewInput, ShakableView {

    func pass(isLoading: Bool)
    func pass(categories: [Category])
    func reloadCollectionView()
    func scrollToItem(at indexPath: IndexPath)
    func setRecord(result: NSAttributedString)
    func deselectItem(at indexPath: IndexPath)
    func moveAmountToCategory(at indexPath: IndexPath)
}
