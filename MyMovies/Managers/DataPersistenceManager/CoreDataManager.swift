//
//  CoreDataManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/03/2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    // The container that holds the data model
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyMovies")
        container.loadPersistentStores { _, error in
            if let error = error {
                #if DEBUG
                fatalError("Core Data stack failed: \(error)")
                #endif
            }
        }

        return container
    }()

    // The main context for reading on main thread
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Get the background context for writing
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }

    // Helper function to save data
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
