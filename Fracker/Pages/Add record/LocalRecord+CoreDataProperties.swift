//
//  LocalRecord+CoreDataProperties.swift
//  Fracker
//
//  Created by Yesset Murat on 5/7/22.
//
//

import Foundation
import CoreData

extension LocalRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalRecord> {
        return NSFetchRequest<LocalRecord>(entityName: "LocalRecord")
    }

    @NSManaged public var id: UUID
    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var createdAt: Date
    @NSManaged public var category: LocalCategory?
}

extension LocalRecord: Identifiable {

}
