//
//  MovieListMembershipEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension MovieListMembershipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieListMembershipEntity> {
        return NSFetchRequest<MovieListMembershipEntity>(entityName: "MovieListMembershipEntity")
    }

    @NSManaged public var orderIndex: Int64
    @NSManaged public var listType: ListTypeEntity?
    @NSManaged public var movie: MovieEntity?
}

extension MovieListMembershipEntity: Identifiable {
}
