//
//  MovieDetailsRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieDetailsRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToMovieDetails(with movie: MovieProtocol)
    func navigateToMovieList(type: MovieListType)
    func navigateToReviewDetails(with author: String?, and text: String?, title: String)
}
