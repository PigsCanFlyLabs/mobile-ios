//
//  CDMessage+CoreDataProperties.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData


extension CDMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMessage> {
        return NSFetchRequest<CDMessage>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var received: Date?
    @NSManaged public var type: Int16
    @NSManaged public var dialog: CDDialog?

}

extension CDMessage : Identifiable {

}
