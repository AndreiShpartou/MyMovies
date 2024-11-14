//
//  SearchRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class SearchRouter: SearchRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Navigation
    func navigateToMovieDetails(with movie: MovieProtocol) {
        let movieDetailsVC = SceneBuilder.buildMovieDetailsScene(for: movie)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

    func navigateToPersonDetails(with person: PersonProtocol) {
        // let personDetailsVC = SceneBuilder.buildPersonDetailsScene(for: actor)
        // viewController?.navigationController?.isNavigationBarHidden = false
        // viewController?.navigationController?.pushViewController(personDetailsVC, animated: true)
    }

    func navigateToMovieList(type: MovieListType) {
        let movieListVC = SceneBuilder.buildMovieListScene(listType: type)
        viewController?.navigationController?.isNavigationBarHidden = false
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }
}
