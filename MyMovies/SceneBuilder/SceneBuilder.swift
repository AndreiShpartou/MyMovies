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
    static func buildMovieDetailsScene(for movie: MovieProtocol) -> UIViewController
    static func buildSearchScene() -> UIViewController
    static func buildProfileScene() -> UIViewController
    static func buildGeneralTextInfoScene(labelText: String?, textViewText: String?, title: String?) -> UIViewController
    static func buildEditProfileScene() -> UIViewController
    static func buildPersonDetailsScene(for personID: Int) -> UIViewController
    static func buildOnboardingScene() -> UIViewController
    static func buildWishlistScene() -> UIViewController
}

final class SceneBuilder: SceneBuilderProtocol {
    // MARK: - TabBarMainScenes
    static func buildHomeScene() -> UIViewController {
        let interactor = MainInteractor()
        let router = MainRouter()
        let view = MainView()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)
        let viewController = MainViewController(mainView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }

    static func buildSearchScene() -> UIViewController {
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let view = SearchView()
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)
        let viewController = SearchViewController(searchView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.isNavigationBarHidden = true

        return navigationController
    }

    static func buildProfileScene() -> UIViewController {
        let interactor = ProfileSettingsInteractor()
        let router = ProfileRouter()
        let view = ProfileSettingsView()
        let presenter = ProfileSettingsPresenter(view: view, interactor: interactor, router: router)
        let viewController = ProfileSettingsViewController(profileSettingsView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }

    // MARK: - SecondaryScenes
    static func buildMovieListScene(listType: MovieListType) -> UIViewController {
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        let view = MovieListView()
        let presenter = MovieListPresenter(view: view, interactor: interactor, router: router)
        let viewController = MovieListViewController(movieListView: view, presenter: presenter, listType: listType)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildMovieDetailsScene(for movie: MovieProtocol) -> UIViewController {
        let interactor = MovieDetailsInteractor(movie: movie)
        let router = MovieDetailsRouter()
        let view = MovieDetailsView()
        let presenter = MovieDetailsPresenter(view: view, interactor: interactor, router: router)
        let viewController = MovieDetailsViewController(movieDetailsView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildPersonDetailsScene(for personID: Int) -> UIViewController {
        let interactor = PersonDetailsInteractor(personID: personID)
        let router = PersonDetailsRouter()
        let view = PersonDetailsView()
        let presenter = PersonDetailsPresenter(view: view, interactor: interactor, router: router)
        let viewController = PersonDetailsViewController(personDetailsView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildGeneralTextInfoScene(labelText: String?, textViewText: String?, title: String?) -> UIViewController {
        let viewController = TextInfoGeneralViewController()
        viewController.configure(with: labelText, and: textViewText, title: title)
        return viewController
    }

    static func buildEditProfileScene() -> UIViewController {
        let interactor = EditProfileInteractor()
        let router = EditProfileRouter()
        let view = EditProfileView()
        let presenter = EditProfilePresenter(view: view, interactor: interactor, router: router)
        let viewController = EditProfileViewController(editProfileView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildOnboardingScene() -> UIViewController {
        let interactor = OnboardingInteractor()
        let router = OnboardingRouter()
        let view = OnboardingView()
        let presenter = OnboardingPresenter(view: view, interactor: interactor, router: router)
        let viewController = OnboardingViewController(view: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildWishlistScene() -> UIViewController {
        let interactor = WishlistInteractor()
        let router = WishlistRouter()
        let view = WishlistView()
        let presenter = WishlistPresenter(view: view, interactor: interactor, router: router)
        let viewController = WishlistViewController(wishlistView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }
}
