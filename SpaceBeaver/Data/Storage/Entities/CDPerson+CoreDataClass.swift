//
//  CDPerson+CoreDataClass.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData

@objc(CDPerson)
public class CDPerson: NSManagedObject {

}

extension CDPerson : Managed {
    static func load(
        with context: NSManagedObjectContext,
        contactId: String?,
        contact: String
    ) -> CDPerson? {
        let request = NSFetchRequest<Self>(entityName: entityName)
        if let contactId = contactId {
            let filterByContactId = NSPredicate(format: "contactId == %@ AND contact == %@", contactId, contact)
            request.predicate = filterByContactId
        } else {
            let filterByContactId = NSPredicate(format: "contact == %@", contact)
            request.predicate = filterByContactId
        }
        do {
            let result = try context.fetch(request)

            if let loaded = result.first {
                return loaded
            }
        } catch {
            return nil
        }

        return nil
    }

    static func insertOrUpdate(
        into context: NSManagedObjectContext,
        contactId: String?,
        contactName: String,
        contact: String
    ) -> CDPerson {
        let record: CDPerson = CDPerson.load(with: context, contactId: contactId, contact: contact) ??  context.insertObject()
        record.contactId = contactId
        record.name = contactName
        record.contact = contact
        return record
    }
}
