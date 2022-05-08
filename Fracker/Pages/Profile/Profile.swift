//
//  Profile.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import Foundation

struct Profile: Decodable {

    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?

    var name: String { [firstName, lastName].nonNilJoined(separator: " ") }
}
