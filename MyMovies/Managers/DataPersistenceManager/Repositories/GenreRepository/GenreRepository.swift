//
//  GenreRepository.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/03/2025.
//

import Foundation
import CoreData

protocol GenreRepositoryProtocol {
    func fetchGenres(provider: String) throws -> [GenreProtocol]
    func saveGenres(_ genres: [GenreProtocol], provider: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GenreRepository: GenreRepositoryProtocol {
    // MARK: - Contexts
    private let mainContext: NSManagedObjectContext
    private let backgroundContextMaker: () -> NSManagedObjectContext

    // MARK: - Init
    init(
        mainContext: NSManagedObjectContext = CoreDataManager.shared.mainContext,
        backgroundContextMaker: @escaping () -> NSManagedObjectContext = { CoreDataManager.shared.newBackgroundContext() }
    ) {
        self.mainContext = mainContext
        self.backgroundContextMaker = backgroundContextMaker
    }

    // MARK: - Fetching
    // Fetching from the main context
    func fetchGenres(provider: String) throws -> [GenreProtocol] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        // Filter by provider to store separate sets (tmdb or kinopoisk)
        request.predicate = NSPredicate(format: "provider == %@", provider)
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

        let result = try mainContext.fetch(request)
        // Convert to domain model
        return result.map { entity in
            Movie.Genre(
                id: Int(entity.id),
                name: entity.name
            )
        }
    }

    // MARK: - Saving
    // Save news genres in a background context: clear old ones beforehand
    func saveGenres(_ genres: [GenreProtocol], provider: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let bgContext = backgroundContextMaker()
        bgContext.perform {
            do {
                // Clear old ones
                try self.clearGenres(provider: provider, context: bgContext)
                // Insert new
                for (index, genre) in genres.enumerated() {
                    self.findOrCreateGenreEntity(
                        for: genre,
                        provider: provider,
                        orderIndex: Int16(index),
                        context: bgContext
                    )
                }
                // Save
                try self.saveContext(bgContext)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private findOrCreateGenreEntity
    private func findOrCreateGenreEntity(
        for genreDomain: GenreProtocol,
        provider: String,
        orderIndex: Int16,
        context: NSManagedObjectContext
    ) {
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

    private func clearGenres(provider: String, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSPredicate(format: "provider == %@", provider)

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }

        try saveContext(context)
    }

    // MARK: - Save
    private func saveContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }

        try context.save()
    }
}
