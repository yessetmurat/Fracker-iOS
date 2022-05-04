//
//  LocalCategory+CoreDataProperties.swift
//  Fracker
//
//  Created by Yesset Murat on 5/4/22.
//
//

import Foundation
import CoreData

extension LocalCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalCategory> {
        return NSFetchRequest<LocalCategory>(entityName: "LocalCategory")
    }

    @NSManaged public var id: UUID
    @NSManaged public var emoji: String
    @NSManaged public var name: String
    @NSManaged public var records: NSSet?
}

extension LocalCategory {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: LocalRecord)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: LocalRecord)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)
}

extension LocalCategory: Identifiable {

}
