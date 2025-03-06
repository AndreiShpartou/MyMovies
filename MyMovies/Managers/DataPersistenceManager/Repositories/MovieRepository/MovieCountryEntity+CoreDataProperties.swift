//
//  MovieCountryEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MovieCountryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCountryEntity> {
        return NSFetchRequest<MovieCountryEntity>(entityName: "MovieCountryEntity")
    }

    @NSManaged public var orderIndex: Int16
    @NSManaged public var country: CountryEntity?
    @NSManaged public var movie: MovieEntity?
}

extension MovieCountryEntity: Identifiable {
}
