//
//  GenreRepository.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/03/2025.
//

import Foundation
import CoreData

protocol GenreRepositoryProtocol {
    func fetchGenres(provider: String) -> [GenreProtocol]
    func saveGenres(_ genres: [GenreProtocol], provider: String)
    func clearGenres(provider: String)
}

final class GenreRepository: GenreRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.context = context
    }

    func fetchGenres(provider: String) -> [GenreProtocol] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        // Filter by provider to store separate sets (tmdb or kinopoisk)
        request.predicate = NSPredicate(format: "provider == %@", provider)
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

    func saveGenres(_ genres: [GenreProtocol], provider: String) {
        for (index, genre) in genres.enumerated() {
            findOrCreateGenreEntity(for: genre, provider: provider, orderIndex: Int16(index))
        }
        CoreDataManager.shared.saveContext()
    }

    func clearGenres(provider: String) {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSPredicate(format: "provider == %@", provider)
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            CoreDataManager.shared.saveContext()
        } catch {
            print("Error clearing old genres: \(error)")
        }
    }

    // MARK: - Private findOrCreateGenreEntity
    private func findOrCreateGenreEntity(for genreDomain: GenreProtocol, provider: String, orderIndex: Int16) {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", genreDomain.id ?? 0),
            NSPredicate(format: "provider == %@", provider),
            NSPredicate(format: "rawName == %@", genreDomain.rawName ?? "")
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            found.orderIndex = orderIndex
        } else {
            let entity = GenreEntity(context: context)
            entity.id = Int16(genreDomain.id ?? 0)
            entity.name = genreDomain.name
            entity.rawName = genreDomain.rawName
            entity.provider = provider
            entity.orderIndex = orderIndex
        }
    }
}
