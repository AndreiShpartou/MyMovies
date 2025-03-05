//
//  GenreEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/03/2025.
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
    @NSManaged public var provider: String?
    @NSManaged public var orderIndex: Int16
}

extension GenreEntity: Identifiable {
}
