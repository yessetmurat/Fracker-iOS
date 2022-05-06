//
//  AnalyticsInteractor.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

class AnalyticsInteractor {

    private unowned let view: AnalyticsViewInput

    init(view: AnalyticsViewInput) {
        self.view = view
    }
}

extension AnalyticsInteractor: AnalyticsInteractorInput {

}
