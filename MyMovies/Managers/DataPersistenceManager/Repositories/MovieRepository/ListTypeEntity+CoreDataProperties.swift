//
//  ListTypeEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension ListTypeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListTypeEntity> {
        return NSFetchRequest<ListTypeEntity>(entityName: "ListTypeEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var movieLists: NSSet?
}

// MARK: Generated accessors for movieLists
extension ListTypeEntity {

    @objc(addMovieListsObject:)
    @NSManaged public func addToMovieLists(_ value: MovieListMembershipEntity)

    @objc(removeMovieListsObject:)
    @NSManaged public func removeFromMovieLists(_ value: MovieListMembershipEntity)

    @objc(addMovieLists:)
    @NSManaged public func addToMovieLists(_ values: NSSet)

    @objc(removeMovieLists:)
    @NSManaged public func removeFromMovieLists(_ values: NSSet)
}

extension ListTypeEntity: Identifiable {
}
