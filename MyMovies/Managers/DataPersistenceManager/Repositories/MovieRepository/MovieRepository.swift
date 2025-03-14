//
//  MovieRepository.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//

import Foundation
import CoreData

protocol MovieRepositoryProtocol {
    // Store
    func storeMovieForList(_ movie: MovieProtocol, provider: String, listType: String, orderIndex: Int)
    func storeMoviesForList(_ movies: [MovieProtocol], provider: String, listType: String)
    // Fetch
    func fetchMovieByID(_ id: Int, provider: String) -> MovieProtocol?
    func fetchMoviesByList(provider: String, listType: String) -> [MovieProtocol]
    func fetchMoviesByGenre(genre: GenreProtocol, provider: String, listType: String) -> [MovieProtocol]
    // Clear
    func clearMoviesForList(provider: String, listName: String)
}

final class MovieRepository: MovieRepositoryProtocol {
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

    // MARK: - Saving
    func storeMovieForList(_ movie: MovieProtocol, provider: String, listType: String, orderIndex: Int) {
        // Create or update a single movie
        let bgContext = backgroundContextMaker()
        bgContext.perform {
            self.storeSingleMovieForListNoSave(
                movie,
                provider: provider,
                listType: listType,
                orderIndex: orderIndex,
                context: bgContext
            )
            // Save background context
            self.saveContext(bgContext)
        }
    }

    // Store multiple movies
    func storeMoviesForList(_ movies: [MovieProtocol], provider: String, listType: String) {
        let bgContext = backgroundContextMaker()
        bgContext.perform {
            for (index, movie) in movies.enumerated() {
                // Create or update each movie
                self.storeSingleMovieForListNoSave(
                    movie,
                    provider: provider,
                    listType: listType,
                    orderIndex: index,
                    context: bgContext
                )
            }
            // Save
            self.saveContext(bgContext)
        }
    }

    // MARK: - Fetching
    // Fetching from the main context
    func fetchMovieByID(_ id: Int, provider: String) -> MovieProtocol? {
        let movieEntity = fetchMovieEntityById(Int64(id), provider: provider)
        guard let movieEntity = movieEntity else { return nil }

        return mapToMovieProtocol(movieEntity)
    }

    func fetchMoviesByList(provider: String, listType: String) -> [MovieProtocol] {
        let movieEntities = fetchMovieEntitiesByList(listType: listType, provider: provider)

        return movieEntities.compactMap { mapToMovieProtocol($0) }
    }

    func fetchMoviesByGenre(genre: GenreProtocol, provider: String, listType: String) -> [MovieProtocol] {
        // Get all movies by list
        let moviesByList = fetchMoviesByList(provider: provider, listType: listType)
        // Get all movies by genre
        let moviesByGenre = moviesByList.filter { movie in
            movie.genres.contains(where: { ($0.id == genre.id) && ($0.name == genre.name) })
        }

        return moviesByGenre
    }

    // MARK: - Clearing
    func clearMoviesForList(provider: String, listName: String) {
        let bgContext = backgroundContextMaker()
        bgContext.perform {
            let request: NSFetchRequest<MovieListMembershipEntity> = MovieListMembershipEntity.fetchRequest()
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "movie.provider == %@", provider),
                NSPredicate(format: "listType.name == %@", listName)
            ])
            do {
                let bridgingRecords = try bgContext.fetch(request)
                bridgingRecords.forEach { bgContext.delete($0) }

                self.saveContext(bgContext)
            } catch {
                print("Error clearing list membership: \(error)")
            }
        }
    }

    // MARK: - Private StoreMovieNoSave
    private func storeSingleMovieForListNoSave(
        _ movie: MovieProtocol,
        provider: String,
        listType: String,
        orderIndex: Int,
        context: NSManagedObjectContext
    ) {
        let movieEntity = findOrCreateMovieEntity(Int64(movie.id), provider: provider, context: context)

        // Fill / update fields
        movieEntity.title = movie.title
        movieEntity.alternativeTitle = movie.alternativeTitle
        movieEntity.movieDescription = movie.description
        movieEntity.movieShortDescription = movie.shortDescription
        movieEntity.runtime = movie.runtime
        movieEntity.voteAverage = movie.voteAverage ?? 0.0
        movieEntity.status = movie.status
        movieEntity.releaseYear = movie.releaseYear
        movieEntity.posterUrl = movie.poster?.url
        movieEntity.backdropUrl = movie.backdrop?.url
        movieEntity.lastUpdated = Date()

        // Fill / update bridging
        fillOrUpdateBridging(
            for: movie,
            movieEntity: movieEntity,
            provider: provider,
            listType: listType,
            orderIndex: Int64(orderIndex),
            context: context
        )
    }

    // MARK: - fetchMovieEntityById
    private func fetchMovieEntityById(_ id: Int64, provider: String) -> MovieEntity? {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", id),
            NSPredicate(format: "provider == %@", provider)
        ])
        request.fetchLimit = 1
        do {
            guard let entity = try mainContext.fetch(request).first else { return nil }

            return entity
        } catch {
            print("Error fetching movie by ID: \(error)")

            return nil
        }
    }

    private func fetchMovieEntitiesByList(listType: String, provider: String) -> [MovieEntity] {
        let request: NSFetchRequest<MovieListMembershipEntity> = MovieListMembershipEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "listType.name == %@", listType),
            NSPredicate(format: "movie.provider == %@", provider)
        ])
        request.fetchLimit = 20
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

        do {
            let bridgingList = try mainContext.fetch(request)
            let possibleMovies = bridgingList.compactMap { $0.movie }

            return possibleMovies
        } catch {
            print("Error fetching bridging by list: \(error)")

            return []
        }
    }

    // MARK: - Bridging clearing
    private func clearMovieGenres(_ movie: MovieEntity, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MovieGenreEntity> = MovieGenreEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movie == %@", movie)
        do { try context.fetch(request).forEach { context.delete($0) } } catch { print(error) }
    }

    private func clearMoviePersons(_ movie: MovieEntity, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MoviePersonEntity> = MoviePersonEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movie == %@", movie)
        do { try context.fetch(request).forEach { context.delete($0) } } catch { print(error) }
    }

    private func clearMovieCountries(_ movie: MovieEntity, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MovieCountryEntity> = MovieCountryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movie == %@", movie)
        do { try context.fetch(request).forEach { context.delete($0) } } catch { print(error) }
    }

    private func clearMovieLists(_ movie: MovieEntity, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MovieListMembershipEntity> = MovieListMembershipEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movie == %@", movie)
        do { try context.fetch(request).forEach { context.delete($0) } } catch { print(error) }
    }

    private func clearMovieSimilars(_ movie: MovieEntity, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MovieSimilarEntity> = MovieSimilarEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movie == %@", movie)
        do { try context.fetch(request).forEach { context.delete($0) } } catch { print(error) }
    }

    // MARK: - Bridging update
    // swiftlint:disable:next function_parameter_count
    private func fillOrUpdateBridging(
        for movie: MovieProtocol,
        movieEntity: MovieEntity,
        provider: String,
        listType: String,
        orderIndex: Int64,
        context: NSManagedObjectContext
    ) {
        // Clear bridging entities
        clearMovieGenres(movieEntity, context: context)
        clearMoviePersons(movieEntity, context: context)
        clearMovieCountries(movieEntity, context: context)
        clearMovieSimilars(movieEntity, context: context)

        // Re-insert bridging
        // Genres
        for (index, genreDomain) in movie.genres.enumerated() {
            // find or create the genre entity
            let genreEntity = findOrCreateGenreEntity(
                for: genreDomain,
                provider: provider,
                context: context
            )
            // bridging
            let bridging = MovieGenreEntity(context: context)
            bridging.movie = movieEntity
            bridging.genre = genreEntity
            bridging.orderIndex = Int16(index)
        }

        // Persons
        for (index, personDomain) in movie.persons.enumerated() {
            // find or create a PersonEntity
            let personEntity = findOrCreatePersonEntity(
                for: personDomain,
                provider: provider,
                context: context
            )
            // bridging
            let bridging = MoviePersonEntity(context: context)
            bridging.movie = movieEntity
            bridging.person = personEntity
            bridging.orderIndex = Int16(index)
        }

        // Countries
        for (index, countryDomain) in movie.countries.enumerated() {
            // find or create a CountryEntity
            let countryEntity = findOrCreateCountryEntity(for: countryDomain, context: context)
            // bridging
            let bridging = MovieCountryEntity(context: context)
            bridging.movie = movieEntity
            bridging.country = countryEntity
            bridging.orderIndex = Int16(index)
        }

        // Similar movies
        if let similarMovies = movie.similarMovies {
            for (index, similarMovie) in similarMovies.enumerated() {
                let bridging = MovieSimilarEntity(context: context)
                bridging.movie = movieEntity
                bridging.id = Int64(similarMovie.id)
                bridging.orderIndex = Int16(index)
            }
        }

        // Lists
        // Just update current list with a new value
        // clearMovieLists(movieEntity)
        let listType = findOrCreateListTypeEntity(listType, context: context)
        // update bridging
        findOrCreateListMembershipEntity(
            for: movieEntity,
            and: listType,
            with: orderIndex,
            context: context
        )
    }

    // MARK: - findOrCreate
    private func findOrCreateMovieEntity(_ id: Int64, provider: String, context: NSManagedObjectContext) -> MovieEntity {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", id),
            NSPredicate(format: "provider == %@", provider)
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            return found
        } else {
            let entity = MovieEntity(context: context)
            entity.id = id
            entity.provider = provider

            return entity
        }
    }

    private func findOrCreateGenreEntity(for genreDomain: GenreProtocol, provider: String, context: NSManagedObjectContext) -> GenreEntity {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", genreDomain.id ?? 0),
            NSPredicate(format: "provider == %@", provider),
            NSPredicate(format: "rawName == %@", genreDomain.rawName ?? "")
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            return found
        } else {
            let entity = GenreEntity(context: context)
            entity.id = Int16(genreDomain.id ?? 0)
            entity.name = genreDomain.name
            entity.rawName = genreDomain.rawName
            entity.provider = provider

            return entity
        }
    }

    private func findOrCreatePersonEntity(for personDomain: PersonProtocol, provider: String, context: NSManagedObjectContext) -> PersonEntity {
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", Int64(personDomain.id)),
            NSPredicate(format: "provider == %@", provider)
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            return found
        } else {
            let entity = PersonEntity(context: context)
            entity.id = Int64(personDomain.id)
            entity.name = personDomain.name
            entity.profession = personDomain.profession
            entity.popularity = personDomain.popularity ?? 0
            entity.photo = personDomain.photo
            entity.provider = provider

            return entity
        }
    }

    private func findOrCreateCountryEntity(for countryDomain: CountryProtocol, context: NSManagedObjectContext) -> CountryEntity {
        // Possibly identify by name if you want to unify countries
        let request: NSFetchRequest<CountryEntity> = CountryEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "name == %@", countryDomain.name),
            NSPredicate(format: "fullName == %@", countryDomain.fullName)
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            return found
        } else {
            let entity = CountryEntity(context: context)
            entity.name = countryDomain.name
            entity.fullName = countryDomain.fullName

            return entity
        }
    }

    private func findOrCreateListTypeEntity(_ listName: String, context: NSManagedObjectContext) -> ListTypeEntity {
        let request: NSFetchRequest<ListTypeEntity> = ListTypeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", listName)
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            return found
        } else {
            let entity = ListTypeEntity(context: context)
            entity.name = listName

            return entity
        }
    }

    private func findOrCreateListMembershipEntity(
        for movie: MovieEntity,
        and listType: ListTypeEntity,
        with orderIndex: Int64,
        context: NSManagedObjectContext
    ) {
        let request: NSFetchRequest<MovieListMembershipEntity> = MovieListMembershipEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "movie == %@", movie),
            NSPredicate(format: "listType == %@", listType)
        ])
        request.fetchLimit = 1

        if let found = try? context.fetch(request).first {
            found.orderIndex = orderIndex
        } else {
            let entity = MovieListMembershipEntity(context: context)
            entity.movie = movie
            entity.listType = listType
            entity.orderIndex = orderIndex
        }
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// MARK: - Mapping
extension MovieRepository {
    private func mapToMovieProtocol(_ entity: MovieEntity) -> MovieProtocol {
        return Movie(
            id: Int(entity.id),
            title: entity.title,
            alternativeTitle: entity.alternativeTitle,
            description: entity.movieDescription,
            shortDescription: entity.movieShortDescription,
            status: entity.status,
            releaseYear: entity.releaseYear,
            runtime: entity.runtime,
            voteAverage: entity.voteAverage,
            genres: mapGenres(entity),
            countries: mapCountries(entity),
            persons: mapPersons(entity),
            poster: mapPoster(entity.posterUrl),
            backdrop: mapPoster(entity.backdropUrl),
            similarMovies: mapSimilars(entity)
        )
    }

    private func mapGenres(_ entity: MovieEntity) -> [Movie.Genre] {
        // bridging: "movieGenres" -> [MovieGenreEntity]
        guard let bridgingSet = entity.movieGenres as? Set<MovieGenreEntity> else {
            return []
        }
        // sort by orderIndex
        let sorted = bridgingSet.sorted(by: { $0.orderIndex < $1.orderIndex })

        // map each bridging to domain
        return sorted.compactMap {
            guard let gengre = $0.genre else { return nil }

            return Movie.Genre(
                id: Int(gengre.id),
                name: gengre.name
            )
        }
    }

    private func mapCountries(_ entity: MovieEntity) -> [Movie.ProductionCountry] {
        guard let bridgingSet = entity.movieCountries as? Set<MovieCountryEntity> else {
            return []
        }
        let sorted = bridgingSet.sorted(by: { $0.orderIndex < $1.orderIndex })

        return sorted.compactMap {
            guard let country = $0.country else { return nil }

            return Movie.ProductionCountry(name: country.name, fullName: country.fullName)
        }
    }

    private func mapPersons(_ entity: MovieEntity) -> [Movie.Person] {
        guard let bridgingSet = entity.moviePersons as? Set<MoviePersonEntity> else {
            return []
        }
        let sorted = bridgingSet.sorted(by: { $0.orderIndex < $1.orderIndex })

        return sorted.compactMap {
            guard let person = $0.person else { return nil }
            return Movie.Person(
                id: Int(person.id),
                photo: person.photo,
                name: person.name,
                profession: person.profession,
                popularity: person.popularity
            )
        }
    }

    private func mapPoster(_ urlString: String?) -> Movie.Cover? {
        guard let urlString = urlString else { return nil }

        return Movie.Cover(url: urlString, previewUrl: nil)
    }

    private func mapSimilars(_ entity: MovieEntity) -> [Movie]? {
        // bridging: "movieSimilars" -> [MovieSimilarEntity]
        guard let bridgingSet = entity.movieSimilars as? Set<MovieSimilarEntity>, !bridgingSet.isEmpty else {
            var similars: [Movie]?
            // Workaround for Kinopoisk to ensure MovieDetails fetchSimilarMovies() logic
            if entity.provider?.description == Provider.kinopoisk.rawValue {
                similars = []
            }

            return similars
        }
        let sorted = bridgingSet.sorted(by: { $0.orderIndex < $1.orderIndex })

        // Similar Movies
        return sorted.map {
            return Movie(id: Int($0.id), title: "")
        }
    }
}
