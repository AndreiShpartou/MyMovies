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
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    func navigateToMovieDetails(with movie: MovieProtocol) {
        let movieDetailsVC = SceneBuilder.buildMovieDetailsScene(for: movie)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

    func navigateToMovieList(type: MovieListType) {
        let movieListVC = SceneBuilder.buildMovieListScene(listType: type)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }

    func navigateToWishlist() {
        if let tabBarController = viewController?.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }

    func navigateToSearchScene() {
        if let tabBarController = viewController?.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}
