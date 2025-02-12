//
//  PersonDetailed.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

struct PersonDetailed: PersonDetailedProtocol {
    var id: Int
    var name: String
    var photo: String?
    var birthDay: String?
    var birthPlace: String?
    var deathDay: String?
    var department: String?
}
