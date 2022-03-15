//
//  CDDialog+CoreDataClass.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData

@objc(CDDialog)
public class CDDialog: NSManagedObject {

}

extension CDDialog : Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "lastUpdated", ascending: true)]
    }
    
    static func load(
        with context: NSManagedObjectContext,
        person: CDPerson
    ) -> CDDialog? {
        let request = NSFetchRequest<Self>(entityName: entityName)
        let filter = NSPredicate(format: "person == %@", person)
        request.predicate = filter
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
        person: CDPerson
    ) -> CDDialog {
        let record: CDDialog = CDDialog.load(with: context, person: person) ??  context.insertObject()
        record.lastUpdated = Date()
        record.person = person
        return record
    }
}
