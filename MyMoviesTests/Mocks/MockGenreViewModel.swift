//
//  MockGenreViewModel.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

struct MockGenreViewModel: GenreViewModelProtocol {
    var id: Int? = 0
    var name: String = "MockGenre"
}
