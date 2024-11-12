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
    func navigateToMovieDetails(with movieID: Int) {
        //
    }

    func navigateToActorDetails(with actorID: Int) {
        //
    }

    func navigateToMovieList() {
        //
    }
}
