//
//  MovieDetailsRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsRouter: MovieDetailsRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

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

    func navigateToReviewDetails(with author: String?, and text: String?, title: String) {
        let reviewVC = SceneBuilder.buildGeneralTextInfoScene(labelText: author, textViewText: text, title: title)
        reviewVC.modalPresentationStyle = .pageSheet
        viewController?.present(reviewVC, animated: true)
    }
}
