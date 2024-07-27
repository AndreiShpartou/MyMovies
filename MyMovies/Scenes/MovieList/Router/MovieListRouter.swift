//
//  MovieListRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieListRouterProtocol: AnyObject {
}

class MovieListRouter: MovieListRouterProtocol {
    weak var viewController: UIViewController?
}
