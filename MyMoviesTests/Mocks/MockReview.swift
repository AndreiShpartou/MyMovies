//
//  MockReview.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockReview
struct MockReview: MovieReviewProtocol {
    var author: String = "MockAuthor"
    var review: String = "MockReview"
}
