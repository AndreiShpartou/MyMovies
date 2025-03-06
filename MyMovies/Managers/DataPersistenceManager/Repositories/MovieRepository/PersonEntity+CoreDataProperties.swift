//
//  PersonEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var popularity: Float
    @NSManaged public var profession: String?
    @NSManaged public var moviePersons: NSSet?
}

// MARK: Generated accessors for moviePersons
extension PersonEntity {

    @objc(addMoviePersonsObject:)
    @NSManaged public func addToMoviePersons(_ value: MoviePersonEntity)

    @objc(removeMoviePersonsObject:)
    @NSManaged public func removeFromMoviePersons(_ value: MoviePersonEntity)

    @objc(addMoviePersons:)
    @NSManaged public func addToMoviePersons(_ values: NSSet)

    @objc(removeMoviePersons:)
    @NSManaged public func removeFromMoviePersons(_ values: NSSet)
}

extension PersonEntity: Identifiable {
}
