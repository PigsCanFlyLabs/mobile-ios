//
//  CDDialog+CoreDataProperties.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData


extension CDDialog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDialog> {
        return NSFetchRequest<CDDialog>(entityName: "Dialog")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var person: CDPerson?
    @NSManaged public var messages: NSSet?
    @NSManaged public var message: String?
}

// MARK: Generated accessors for messages
extension CDDialog {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: CDMessage)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: CDMessage)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension CDDialog : Identifiable {

}
