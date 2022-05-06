//
//  Constants.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Foundation

class Constants {

    class var host: String { "yessetmurat.com" }

    class var serverUrl: String { "https://" + host }

    class var emailRegex: String { "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" }

    class var googleClientId: String { "463288692915-9lojjug3r6toced57r3bpmdc6lu1d6bj.apps.googleusercontent.com" }

    class var defaultCategories: [Category] {
        return [
            Category(id: UUID(), emoji: "🍗", name: "Food"),
            Category(id: UUID(), emoji: "🏠", name: "Communal payments"),
            Category(id: UUID(), emoji: "🚗", name: "Transport"),
            Category(id: UUID(), emoji: "💊", name: "Health")
        ]
    }
}
