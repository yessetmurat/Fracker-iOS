//
//  String + extensions.swift
//  Fracker
//
//  Created by Yesset Murat on 5/9/22.
//

import Foundation

extension String {

    var localized: String {
        let languageCode = Locale.current.languageCode ?? "en"

        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
