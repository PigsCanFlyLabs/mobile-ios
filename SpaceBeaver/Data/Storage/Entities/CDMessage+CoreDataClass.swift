//
//  CDMessage+CoreDataClass.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//
//

import Foundation
import CoreData

public enum CDMessageType: Int16, RawRepresentable {
    case incoming = 0
    case outgoing = 1
}


@objc(CDMessage)
public class CDMessage: NSManagedObject {
    var kind: CDMessageType {
        return CDMessageType(rawValue: type) ?? .outgoing
    }
}

extension CDMessage : Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "received", ascending: true)]
    }

    static func insert(
        into context: NSManagedObjectContext,
        dialog: CDDialog,
        text: String,
        type: CDMessageType
    ) -> CDMessage {
        let record: CDMessage = context.insertObject()
        record.received = Date()
        record.type = type.rawValue
        record.text = text
        record.dialog = dialog
        return record
    }
}
