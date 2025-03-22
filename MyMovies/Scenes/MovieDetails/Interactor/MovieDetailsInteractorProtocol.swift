//
//  MovieDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsInteractorProtocol: AnyObject {
    var presenter: MovieDetailsInteractorOutputProtocol? { get set }

    func fetchMovie()
    func fetchReviews()
    func fetchSimilarMovies()
    func fetchIsMovieInList(listType: MovieListType)
    func toggleFavouriteStatus(isFavourite: Bool)
}

protocol MovieDetailsInteractorOutputProtocol: AnyObject {
    func didFetchMovie(_ movie: MovieProtocol)
    func didFetchReviews(_ reviews: [MovieReviewProtocol])
    func didFetchSimilarMovies(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
    func didFetchIsMovieInList(_ isInList: Bool, listType: MovieListType)
}
