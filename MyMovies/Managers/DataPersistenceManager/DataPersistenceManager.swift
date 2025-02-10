//
//  DataPersistenceManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/11/2024.
//

import Foundation
import CoreData

final class DataPersistenceManager: DataPersistenceProtocol {
    static let shared = DataPersistenceManager()

    private init() {}

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyMovies")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack failed to load: \(error)")
            }
        }

        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Core Data stack failed to save: \(error)")
            }
        }
    }

    // MARK: - DataPersistenceProtocol Methods
    func saveSearchQuery(_ query: String) {
        let context = persistentContainer.viewContext
//        let searchEntity = RecentlySearchedMovie(context: context)
//        searchEntity.query = query
//        searchEntity.date = Date()

        saveContext()
    }

    func fetchRecentlySearchedMovies() -> [MovieProtocol] {
        return [
            Movie(
            id: 1,
            title: "s",
            alternativeTitle: "s",
            description: "s",
            shortDescription: "s",
            status: "s",
            releaseYear: "s",
            runtime: "s",
            voteAverage: 9.9,
            genres: [],
            countries: [],
            persons: [],
            poster: nil,
            backdrop: nil,
            similarMovies: nil
        )
        ]
    }

    func prepareFetchRecentlySearchedMovies() -> [MovieProtocol] {
        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<RecentlySearchedMovie> = RecentlySearchedMovie.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        fetchRequest.fetchLimit = 10

        do {
//            let results = try context.fetch(fetchRequest)
            // Convert to [MovieProtocol], assuming we have a way to map queries to movies
            // This might require additional implementation based on data model
//            return results.compactMap { result in
//                // Placeholder implementation
//                // Need to implement actual mapping based on requirements
//                return nil
//            }
        } catch {
            print("Failed to fetch recently searched movies: \(error)")
            return []
        }

        return []
    }
}
