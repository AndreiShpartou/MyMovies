//
//  PersonDetailedProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

protocol PersonDetailedProtocol: Codable {
    var id: Int { get }
    var name: String { get }
    var photo: String? { get }
    var birthDay: String? { get }
    var birthPlace: String? { get }
    var deathDay: String? { get }
    var department: String? { get }
}
