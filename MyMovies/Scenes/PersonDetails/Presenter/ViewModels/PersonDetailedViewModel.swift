//
//  PersonDetailedViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

struct PersonDetailedViewModel: PersonDetailedViewModelProtocol {
    let id: Int
    let name: String
    var photo: URL?
    var birthDay: String?
    var birthPlace: String?
    var deathDay: String?
    var department: String?
}
