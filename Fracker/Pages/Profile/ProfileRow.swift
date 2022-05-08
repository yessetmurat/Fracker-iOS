//
//  ProfileRow.swift
//  Fracker
//
//  Created by Yesset Murat on 5/8/22.
//

import Foundation
import BaseKit

struct ProfileRow {

    enum Identifier { case support, logout }

    let id: Identifier
    let title: String
    let image: BaseImage
    let accessoryImage: BaseImage?
}
