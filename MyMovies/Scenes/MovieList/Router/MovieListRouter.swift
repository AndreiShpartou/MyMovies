//
//  MovieListRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieListRouter: MovieListRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToMovieDetails(with movie: MovieProtocol) {
        let movieDetailsVC = SceneBuilder.buildMovieDetailsScene(for: movie)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
