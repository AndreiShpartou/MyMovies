//
//  SceneBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 28/07/2024.
//

import UIKit

protocol SceneBuilderProtocol: AnyObject {
    static func buildHomeScene() -> UIViewController
    static func buildMovieListScene(listType: MovieListType) -> UIViewController
    static func buildSearchScene() -> UIViewController
    static func buildProfileScene() -> UIViewController
}

final class SceneBuilder: SceneBuilderProtocol {
    static func buildHomeScene() -> UIViewController {
        let view = MainView()
        let viewController = MainViewController(mainView: view)
        let router = MainRouter(viewController: viewController)
        let interactor = MainInteractor()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }

    static func buildSearchScene() -> UIViewController {
        let view = SearchView()
        let viewController = SearchViewController(searchView: view)
        let router = SearchRouter(viewController: viewController)
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(view: viewController, interactor: interactor, router: router)

        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true

        return navigationController
    }

    static func buildProfileScene() -> UIViewController {
        let view = ProfileView()
        let viewController = ProfileViewController(profileView: view)
        let router = ProfileRouter(viewController: viewController)
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: viewController, interactor: interactor, router: router)

        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true

        return navigationController
    }

    static func buildMovieListScene(listType: MovieListType) -> UIViewController {
        let view = MovieListView()
        let viewController = MovieListViewController(movieListView: view, listType: listType)
        let router = MovieListRouter(viewController: viewController)
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        viewController.presenter = presenter
        interactor.presenter = presenter
        viewController.title = listType.title

        return viewController
    }
}
