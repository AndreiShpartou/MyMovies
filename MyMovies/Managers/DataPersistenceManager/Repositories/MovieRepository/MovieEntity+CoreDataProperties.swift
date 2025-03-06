//
//  MovieEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var alternativeTitle: String?
    @NSManaged public var backdropUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var movieDescription: String?
    @NSManaged public var movieShortDescription: String?
    @NSManaged public var posterUrl: String?
    @NSManaged public var provider: String?
    @NSManaged public var releaseYear: String?
    @NSManaged public var runtime: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var movieCountries: NSSet?
    @NSManaged public var movieGenres: NSSet?
    @NSManaged public var movieListsMembership: NSSet?
    @NSManaged public var moviePersons: NSSet?
    @NSManaged public var movieSimilars: NSSet?
}

// MARK: Generated accessors for movieCountries
extension MovieEntity {

    @objc(addMovieCountriesObject:)
    @NSManaged public func addToMovieCountries(_ value: MovieCountryEntity)

    @objc(removeMovieCountriesObject:)
    @NSManaged public func removeFromMovieCountries(_ value: MovieCountryEntity)

    @objc(addMovieCountries:)
    @NSManaged public func addToMovieCountries(_ values: NSSet)

    @objc(removeMovieCountries:)
    @NSManaged public func removeFromMovieCountries(_ values: NSSet)
}

// MARK: Generated accessors for movieGenres
extension MovieEntity {

    @objc(addMovieGenresObject:)
    @NSManaged public func addToMovieGenres(_ value: MovieGenreEntity)

    @objc(removeMovieGenresObject:)
    @NSManaged public func removeFromMovieGenres(_ value: MovieGenreEntity)

    @objc(addMovieGenres:)
    @NSManaged public func addToMovieGenres(_ values: NSSet)

    @objc(removeMovieGenres:)
    @NSManaged public func removeFromMovieGenres(_ values: NSSet)
}

// MARK: Generated accessors for movieListsMembership
extension MovieEntity {

    @objc(addMovieListsMembershipObject:)
    @NSManaged public func addToMovieListsMembership(_ value: MovieListMembershipEntity)

    @objc(removeMovieListsMembershipObject:)
    @NSManaged public func removeFromMovieListsMembership(_ value: MovieListMembershipEntity)

    @objc(addMovieListsMembership:)
    @NSManaged public func addToMovieListsMembership(_ values: NSSet)

    @objc(removeMovieListsMembership:)
    @NSManaged public func removeFromMovieListsMembership(_ values: NSSet)
}

// MARK: Generated accessors for moviePersons
extension MovieEntity {

    @objc(addMoviePersonsObject:)
    @NSManaged public func addToMoviePersons(_ value: MoviePersonEntity)

    @objc(removeMoviePersonsObject:)
    @NSManaged public func removeFromMoviePersons(_ value: MoviePersonEntity)

    @objc(addMoviePersons:)
    @NSManaged public func addToMoviePersons(_ values: NSSet)

    @objc(removeMoviePersons:)
    @NSManaged public func removeFromMoviePersons(_ values: NSSet)
}

// MARK: Generated accessors for movieSimilars
extension MovieEntity {

    @objc(addMovieSimilarsObject:)
    @NSManaged public func addToMovieSimilars(_ value: MovieSimilarEntity)

    @objc(removeMovieSimilarsObject:)
    @NSManaged public func removeFromMovieSimilars(_ value: MovieSimilarEntity)

    @objc(addMovieSimilars:)
    @NSManaged public func addToMovieSimilars(_ values: NSSet)

    @objc(removeMovieSimilars:)
    @NSManaged public func removeFromMovieSimilars(_ values: NSSet)
}

extension MovieEntity: Identifiable {
}
