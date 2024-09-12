//
//  MainRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
    func navigateToMovieDetails(with movie: MovieProtocol)
}
