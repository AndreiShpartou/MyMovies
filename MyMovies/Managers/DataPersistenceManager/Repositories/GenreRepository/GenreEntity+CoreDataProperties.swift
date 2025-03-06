//
//  GenreEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension GenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
        return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var orderIndex: Int16
    @NSManaged public var provider: String?
    @NSManaged public var movieGenres: NSSet?
}

// MARK: Generated accessors for movieGenres
extension GenreEntity {

    @objc(addMovieGenresObject:)
    @NSManaged public func addToMovieGenres(_ value: MovieGenreEntity)

    @objc(removeMovieGenresObject:)
    @NSManaged public func removeFromMovieGenres(_ value: MovieGenreEntity)

    @objc(addMovieGenres:)
    @NSManaged public func addToMovieGenres(_ values: NSSet)

    @objc(removeMovieGenres:)
    @NSManaged public func removeFromMovieGenres(_ values: NSSet)
}

extension GenreEntity: Identifiable {
}
