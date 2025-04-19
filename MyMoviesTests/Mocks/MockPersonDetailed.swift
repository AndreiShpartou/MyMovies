//
//  MockPersonDetailed.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockPersonDetailed
struct MockPersonDetailed: PersonDetailedProtocol {
    var id: Int = 0
    var name: String = "MockPersonDetailed"
    var photo: String?
    var birthDay: String?
    var birthPlace: String?
    var deathDay: String?
    var department: String?
}
