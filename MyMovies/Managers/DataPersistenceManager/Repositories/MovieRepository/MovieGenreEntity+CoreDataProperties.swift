//
//  MovieGenreEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MovieGenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenreEntity> {
        return NSFetchRequest<MovieGenreEntity>(entityName: "MovieGenreEntity")
    }

    @NSManaged public var orderIndex: Int16
    @NSManaged public var genre: GenreEntity?
    @NSManaged public var movie: MovieEntity?
}

extension MovieGenreEntity: Identifiable {
}
