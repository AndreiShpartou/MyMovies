//
//  MovieSimilarEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MovieSimilarEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieSimilarEntity> {
        return NSFetchRequest<MovieSimilarEntity>(entityName: "MovieSimilarEntity")
    }

    @NSManaged public var orderIndex: Int16
    @NSManaged public var id: Int64
    @NSManaged public var movie: MovieEntity?
}

extension MovieSimilarEntity: Identifiable {
}
