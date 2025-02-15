//
//  SearchRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToMovieDetails(with movie: MovieProtocol)
    func navigateToPersonDetails(with personID: Int)
    func navigateToMovieList(type: MovieListType)
}
