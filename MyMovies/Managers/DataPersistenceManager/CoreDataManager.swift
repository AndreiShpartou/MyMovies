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
                fatalError("Core Data stack failed: \(error)")
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
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data context: \(error)")
            }
        }
    }
}
