//
//  CoreDataStack.swift
//  Storage
//
//  Created by Dmytro Kholodov on 19.06.2021.
//

import CoreData

enum DatasetError: Error {
    case loadPersistentStoresFailed(message: String)
}

class CoreDataStack {

    let container: NSPersistentContainer
    let base: URL
    let database: String

    init(_ base: URL, database: String, cleanInstall: Bool = true) throws {
        self.base = base
        self.database = database

        let fm = FileManager.default
        if !fm.fileExists(atPath: base.path) {
            try FileManager.default.createDirectory(atPath: base.path, withIntermediateDirectories: true, attributes: nil)
        }

        // Remove an existing database
        if cleanInstall {
            let dbURLs: [URL] = [
                base.appendingPathComponent("\(database).sqlite"),
                base.appendingPathComponent("\(database).sqlite-shm"),
                base.appendingPathComponent("\(database).sqlite-wal"),
                ]
            for dbURL in dbURLs {
                if fm.fileExists(atPath: dbURL.path) {
                    try fm.removeItem(atPath: dbURL.path)
                }
            }
        }


        let modelName = database
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        self.container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        let `default` = NSPersistentStoreDescription()
        `default`.url = self.base.appendingPathComponent("\(database).sqlite")
        `default`.configuration = nil
        `default`.shouldMigrateStoreAutomatically = true
        `default`.shouldInferMappingModelAutomatically = true

        self.container.persistentStoreDescriptions = [`default`]

        var errors: [String] = []

        self.container.loadPersistentStores { (store, error) in
            if let error = error as NSError? {
                let message = "Unresolved error \(error), \(error.userInfo) in store \(store.configuration ?? "Default")"
                errors.append(message)
            }
        }

        if !errors.isEmpty {
            let details = errors.joined(separator: " AND ")
            throw DatasetError.loadPersistentStoresFailed(message: details)
        }
    }
}


