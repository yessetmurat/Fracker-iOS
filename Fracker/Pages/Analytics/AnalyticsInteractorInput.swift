//
//  AnalyticsInteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 5/6/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol AnalyticsInteractorInput: AnyObject, InteractorInput {

    func loadAnalytics()
    func didSelectFilter(at index: Int)
}
