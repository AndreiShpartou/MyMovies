//
//  PersonDetailedViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

struct PersonDetailedViewModel: PersonDetailedViewModelProtocol {
    var id: Int
    var name: String
    var photo: URL?
    var birthDay: String?
    var birthPlace: String?
    var deathDay: String?
    var department: String?
}
