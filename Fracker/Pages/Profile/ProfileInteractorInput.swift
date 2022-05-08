//
//  ProfileInteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProfileInteractorInput: AnyObject {

    func setSections()
    func didSelectRow(at indexPath: IndexPath)
}
