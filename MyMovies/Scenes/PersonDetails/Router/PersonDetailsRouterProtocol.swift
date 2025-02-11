//
//  PersonDetailsRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit

protocol PersonDetailsRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToMovieDetails(with movie: MovieProtocol)
    func navigateToMovieList(type: MovieListType)
}
