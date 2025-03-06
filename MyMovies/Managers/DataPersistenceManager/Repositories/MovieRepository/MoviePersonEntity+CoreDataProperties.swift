//
//  MoviePersonEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MoviePersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviePersonEntity> {
        return NSFetchRequest<MoviePersonEntity>(entityName: "MoviePersonEntity")
    }

    @NSManaged public var orderIndex: Int16
    @NSManaged public var movie: MovieEntity?
    @NSManaged public var person: PersonEntity?
}

extension MoviePersonEntity: Identifiable {
}
