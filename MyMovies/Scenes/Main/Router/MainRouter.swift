//
//  MainRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToMovieDetails(with movie: MovieProtocol) {
        // let movieDetailsVC = SceneBuilder.buildMovieDetailsScene()
        // viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)

//        guard let detailsVC = SceneBuilder.buildMovieDetailsScene(with: movie) else {
//            print("Error: Could not instantiate MovieDetailsViewController.")
//            return
//        }
//        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func navigateToMovieList(type: MovieListType) {
        let movieListVC = SceneBuilder.buildMovieListScene(listType: type)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }
}
