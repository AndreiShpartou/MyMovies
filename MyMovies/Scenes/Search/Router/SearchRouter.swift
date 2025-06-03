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
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

    func navigateToPersonDetails(with personID: Int) {
         let personDetailsVC = SceneBuilder.buildPersonDetailsScene(for: personID)
         viewController?.navigationController?.pushViewController(personDetailsVC, animated: true)
    }

    func navigateToMovieList(type: MovieListType) {
        let movieListVC = SceneBuilder.buildMovieListScene(listType: type)
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }
}
