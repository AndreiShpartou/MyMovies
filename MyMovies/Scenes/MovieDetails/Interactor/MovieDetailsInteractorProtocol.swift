//
//  MovieDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsInteractorProtocol: AnyObject {
    func fetchMovie()
    func fetchReviews()
}

protocol MovieDetailsInteractorOutputProtocol: AnyObject {
    func didFetchMovie(_ movie: MovieProtocol)
    func didFetchReviews(_ reviews: [MovieReviewProtocol])
    func didFailToFetchData(with error: Error)
}
