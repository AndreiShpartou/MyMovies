//
//  MainRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func navigateToMovieDetails(with movie: Movie)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToMovieDetails(with movie: Movie) {
        // let movieDetailsVC = SceneBuilder.buildMovieDetailsScene()
        // viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
