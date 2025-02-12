//
//  PersonDetailedViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

protocol PersonDetailedViewModelProtocol {
    var id: Int { get }
    var photo: URL? { get }
    var name: String { get }
    var birthDay: String? { get }
    var birthPlace: String? { get }
    var deathDay: String? { get }
    var department: String? { get }
}
