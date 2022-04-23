//
//  RecordInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

class RecordInteractor {

    private unowned let view: RecordViewInput

    init(view: RecordViewInput) {
        self.view = view
    }
}

extension RecordInteractor: RecordInteractorInput {

}
