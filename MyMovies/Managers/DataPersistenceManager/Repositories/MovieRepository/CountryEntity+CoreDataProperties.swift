//
//  CountryEntity+CoreDataProperties.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 06/03/2025.
//
//

import Foundation
import CoreData

extension CountryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryEntity> {
        return NSFetchRequest<CountryEntity>(entityName: "CountryEntity")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var name: String?
    @NSManaged public var movieCountries: NSSet?
}

// MARK: Generated accessors for movieCountries
extension CountryEntity {

    @objc(addMovieCountriesObject:)
    @NSManaged public func addToMovieCountries(_ value: MovieCountryEntity)

    @objc(removeMovieCountriesObject:)
    @NSManaged public func removeFromMovieCountries(_ value: MovieCountryEntity)

    @objc(addMovieCountries:)
    @NSManaged public func addToMovieCountries(_ values: NSSet)

    @objc(removeMovieCountries:)
    @NSManaged public func removeFromMovieCountries(_ values: NSSet)
}

extension CountryEntity: Identifiable {
}
