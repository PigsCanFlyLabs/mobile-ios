//
//  DialogsStorage.swift
//  DialogsStorage
//
//  Created by Dmytro Kholodov on 19.06.2021.
//

import CoreData

public class DialogsStorage {

    enum Props {
        static let name = "Dialogs"
    }

    private var url: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(Props.name)
    }()

    private var storage: CoreDataStack

    var readContext: NSManagedObjectContext {
        self.storage.container.viewContext
    }

    var writeContext: NSManagedObjectContext

    public init?(cleanInstall: Bool = false) {
        do {
            self.storage = try CoreDataStack(url, database: Props.name, cleanInstall: cleanInstall)
            self.writeContext = self.storage.container.newBackgroundContext()

            let nc = NotificationCenter.default
            let _ = nc.addObserver(forName: .NSManagedObjectContextDidSave, object: writeContext, queue: nil) { [weak self] note in
                self?.readContext.perform {
                    self?.readContext.mergeChanges(fromContextDidSave: note)
                }
            }

            #if targetEnvironment(simulator)
            print("\nCoreData\n")
            print("\n=========\n")
            print(url)
            print("\n=========\n")
            #endif

        } catch {
            return nil
        }
    }
}


extension DialogsStorage {
    public func getObject(from URI: URL) -> NSManagedObject? {
        guard let objectID = self.storage.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: URI)
        else { return nil }

        let objectForID = self.readContext.object(with: objectID)

        guard !objectForID.isFault
        else { return nil }

        return objectForID
    }
}

//MARK: - Dialogs
extension DialogsStorage {
    public func makeDialogsAll() -> NSFetchedResultsController<CDDialog> {
        let request = CDDialog.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: readContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    public func loadDialog(with contactId: String?, name: String, contact: String, auto: Bool = true) -> CDDialog {
        guard let person = CDPerson.load(with: writeContext, contactId: contactId, contact: contact) else {
            let newPerson = CDPerson.insertOrUpdate(into: writeContext, contactId: contactId, contactName: name, contact: contact)
            let newDialog = CDDialog.insertOrUpdate(into: writeContext, person: newPerson)
            _ = writeContext.saveOrRollback()
            return newDialog
        }
        if let dialog = CDDialog.load(with: writeContext, person: person) {
            return dialog
        }

        let dialog = CDDialog.insertOrUpdate(into: writeContext, person: person)
        _ = writeContext.saveOrRollback()
        return dialog
    }

    public func loadDialog(with contact: String) -> CDDialog {
        guard let person = CDPerson.load(with: writeContext, contactId: nil, contact: contact) else {
            let contactOnPhone = CNContactsRepository().findContact(by: contact)
            let contactName = contactOnPhone?.fullName ?? contact
            let newPerson = CDPerson.insertOrUpdate(into: writeContext, contactId: contactOnPhone?.identifier, contactName: contactName, contact: contact)
            let newDialog = CDDialog.insertOrUpdate(into: writeContext, person: newPerson)
            _ = writeContext.saveOrRollback()
            return newDialog
        }
        if let dialog = CDDialog.load(with: writeContext, person: person) {
            return dialog
        }
        let dialog = CDDialog.insertOrUpdate(into: writeContext, person: person)
        _ = writeContext.saveOrRollback()
        return dialog
    }

    public func addNewMessage(text: String, dialog: CDDialog, type: CDMessageType = .outgoing) {
        _ = CDMessage.insert(into: writeContext, dialog: dialog, text: text, type: type)
        dialog.message = text
        _ = writeContext.saveOrRollback()
    }
}

//MARK: - Messages
extension DialogsStorage {
    public func makeMessages(for dialog: CDDialog) -> NSFetchedResultsController<CDMessage> {
        let request = CDMessage.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let filterByUserIdAndCaller = NSPredicate(format: "dialog == %@", dialog)
        request.predicate = filterByUserIdAndCaller
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: readContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
}

//MARK: - Person
extension DialogsStorage {
    public func toggleBlocked(for contactId: String?, contact: String) {
        guard let contact = CDPerson.load(with: writeContext, contactId: contactId, contact: contact) else { return }

        guard let dialog = CDDialog.load(with: writeContext, person: contact) else { return }
        contact.blocked.toggle()
        dialog.person = contact
        _ = writeContext.saveOrRollback()
    }
}
