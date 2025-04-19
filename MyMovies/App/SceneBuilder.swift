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
    static func buildSignInScene() -> UIViewController
    static func buildSignUpScene() -> UIViewController
}

final class SceneBuilder: SceneBuilderProtocol {
    // MARK: - TabBarMainScenes
    static func buildHomeScene() -> UIViewController {
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let genreRepository: GenreRepositoryProtocol? = ServiceLocator.shared.getService()
        let movieRepository: MovieRepositoryProtocol? = ServiceLocator.shared.getService()
        let authService: AuthServiceProtocol? = ServiceLocator.shared.getService()
        let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol? = ServiceLocator.shared.getService()
        let userProfileObserver: UserProfileObserverProtocol = UserProfileObserver(
            authService: authService!,
            profileDocumentsStoreService: profileDocumentsStoreService!
        )

        let interactor = MainInteractor(
            networkService: networkService!,
            genreRepository: genreRepository!,
            movieRepository: movieRepository!,
            userProfileObserver: userProfileObserver
        )

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
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let genreRepository: GenreRepositoryProtocol? = ServiceLocator.shared.getService()
        let movieRepository: MovieRepositoryProtocol? = ServiceLocator.shared.getService()

        let interactor = SearchInteractor(
            networkService: networkService!,
            genreRepository: genreRepository!,
            movieRepository: movieRepository!
        )

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
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let authService: AuthServiceProtocol? = ServiceLocator.shared.getService()
        let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol? = ServiceLocator.shared.getService()
        let userProfileObserver: UserProfileObserverProtocol = UserProfileObserver(
            authService: authService!,
            profileDocumentsStoreService: profileDocumentsStoreService!
        )
        let plistLoader: PlistConfigurationLoaderProtocol? = ServiceLocator.shared.getService()

        let interactor = ProfileSettingsInteractor(
            networkService: networkService!,
            authService: authService!,
            userProfileObserver: userProfileObserver,
            plistLoader: plistLoader!
        )

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
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let genreRepository: GenreRepositoryProtocol? = ServiceLocator.shared.getService()
        let movieRepository: MovieRepositoryProtocol? = ServiceLocator.shared.getService()

        let interactor = MovieListInteractor(
            networkService: networkService!,
            genreRepository: genreRepository!,
            movieRepository: movieRepository!
        )

        let router = MovieListRouter()
        let view = MovieListView()
        let presenter = MovieListPresenter(view: view, interactor: interactor, router: router)
        let viewController = MovieListViewController(movieListView: view, presenter: presenter, listType: listType)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildMovieDetailsScene(for movie: MovieProtocol) -> UIViewController {
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let movieRepository: MovieRepositoryProtocol? = ServiceLocator.shared.getService()

        let interactor = MovieDetailsInteractor(
            movie: movie,
            networkService: networkService!,
            movieRepository: movieRepository!
        )

        let router = MovieDetailsRouter()
        let view = MovieDetailsView()
        let presenter = MovieDetailsPresenter(view: view, interactor: interactor, router: router)
        let viewController = MovieDetailsViewController(movieDetailsView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }

    static func buildPersonDetailsScene(for personID: Int) -> UIViewController {
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()

        let interactor = PersonDetailsInteractor(
            personID: personID,
            networkService: networkService!
        )

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
        let profileDataStoreService: ProfileDataStoreServiceProtocol? = ServiceLocator.shared.getService()
        let authService: AuthServiceProtocol? = ServiceLocator.shared.getService()
        let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol? = ServiceLocator.shared.getService()

        let interactor = EditProfileInteractor(
            profileDataStoreService: profileDataStoreService!,
            authService: authService!,
            profileDocumentsStoreService: profileDocumentsStoreService!
        )

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
        let networkService: NetworkServiceProtocol? = ServiceLocator.shared.getService()
        let movieRepository: MovieRepositoryProtocol? = ServiceLocator.shared.getService()

        let interactor = WishlistInteractor(
            movieRepository: movieRepository!,
            provider: networkService!.getProvider()
        )

        let router = WishlistRouter()
        let view = WishlistView()
        let presenter = WishlistPresenter(view: view, interactor: interactor, router: router)
        let viewController = WishlistViewController(wishlistView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)

        return navigationController
    }

    static func buildSignInScene() -> UIViewController {
        let authService: AuthServiceProtocol? = ServiceLocator.shared.getService()

        let interactor = LoginInteractor(authService: authService!)

        let router = LoginRouter()
        let view = LoginView()
        let presenter = LoginPresenter(view: view, interactor: interactor, router: router)
        let viewController = LoginViewController(loginView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true

        return navigationController
    }

    static func buildSignUpScene() -> UIViewController {
        let authService: AuthServiceProtocol? = ServiceLocator.shared.getService()
        let profileDocumentsStoreService: ProfileDocumentsStoreServiceProtocol? = ServiceLocator.shared.getService()

        let interactor = SignUpInteractor(
            authService: authService!,
            profileDocumentsStoreService: profileDocumentsStoreService!
        )

        let router = SignUpRouter()
        let view = SignUpView()
        let presenter = SignUpPresenter(view: view, interactor: interactor, router: router)
        let viewController = SignUpViewController(signUpView: view, presenter: presenter)

        router.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }
}
