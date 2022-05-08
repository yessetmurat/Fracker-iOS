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

    class var supportUrl: String { "https://t.me/yessetm" }

    class var defaultCategories: [Category] {
        let date = Date()

        return [
            Category(id: UUID(), emoji: "🍗", name: "Food", createdAt: date, deletedAt: nil),
            Category(id: UUID(), emoji: "🏠", name: "Communal payments", createdAt: date, deletedAt: nil),
            Category(id: UUID(), emoji: "🚗", name: "Transport", createdAt: date, deletedAt: nil),
            Category(id: UUID(), emoji: "💊", name: "Health", createdAt: date, deletedAt: nil)
        ]
    }
}
