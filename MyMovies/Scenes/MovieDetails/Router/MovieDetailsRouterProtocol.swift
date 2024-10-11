//
//  MovieDetailsRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieDetailsRouterProtocol: AnyObject {
    func navigateToMovieDetails(with movie: MovieProtocol)
    func navigateToMovieList(type: MovieListType)
    func navigateToReviewDetails(with author: String?, and text: String?, title: String)
}
