//
//  CDPerson+CoreDataProperties.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData


extension CDPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPerson> {
        return NSFetchRequest<CDPerson>(entityName: "Person")
    }

    @NSManaged public var blocked: Bool
    @NSManaged public var contactId: String?
    @NSManaged public var name: String?
    @NSManaged public var dialogs: NSSet?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var contact: String?

}

// MARK: Generated accessors for dialogs
extension CDPerson {

    @objc(addDialogsObject:)
    @NSManaged public func addToDialogs(_ value: CDDialog)

    @objc(removeDialogsObject:)
    @NSManaged public func removeFromDialogs(_ value: CDDialog)

    @objc(addDialogs:)
    @NSManaged public func addToDialogs(_ values: NSSet)

    @objc(removeDialogs:)
    @NSManaged public func removeFromDialogs(_ values: NSSet)

}

extension CDPerson : Identifiable {

}
