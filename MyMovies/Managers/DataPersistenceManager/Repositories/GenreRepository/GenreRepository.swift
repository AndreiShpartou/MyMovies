//
//  GenreRepository.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/03/2025.
//

import Foundation
import CoreData

protocol GenreRepositoryProtocol {
    func fetchGenres(provider: Provider) -> [Movie.Genre]
    func saveGenres(_ genres: [Movie.Genre], provider: Provider)
    func clearGenres(provider: Provider)
}

final class GenreRepository: GenreRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.context = context
    }

    func fetchGenres(provider: Provider) -> [Movie.Genre] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        // Filter by provider to store separate sets (tmdb or kinopoisk)
        request.predicate = NSPredicate(format: "provider == %@", provider.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

        do {
            let result = try context.fetch(request)
            // Convert to domain model
            return result.map { entity in
                Movie.Genre(
                    id: Int(entity.id),
                    name: entity.name
                )
            }
        } catch {
            print("Error fetching genres from CoreData: \(error)")
            return []
        }
    }

    func saveGenres(_ genres: [Movie.Genre], provider: Provider) {
        for (index, genre) in genres.enumerated() {
            let entity = GenreEntity(context: context)
            entity.id = Int16(genre.id ?? 0)
            entity.name = genre.name
            entity.provider = provider.rawValue
            entity.orderIndex = Int16(index) // Store the original API order
        }

        CoreDataManager.shared.saveContext()
    }

    func clearGenres(provider: Provider) {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSPredicate(format: "provider == %@", provider.rawValue)
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            CoreDataManager.shared.saveContext()
        } catch {
            print("Error clearing old genres: \(error)")
        }
    }
}
