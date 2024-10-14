//
//  MovieListRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieListRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToMovieDetails(with movie: MovieProtocol)
}
