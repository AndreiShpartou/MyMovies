//
//  MainPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol
    var router: MainRouterProtocol

    private let mapper: DomainModelMapperProtocol
    private var moviesDict: [MovieListType: [MovieProtocol]] = [:]
    private var loadingStates: [MainAppSection: Bool] = [
        .userProfile: false,
        .upcomingMovies: false,
        .popularMovies: false,
        .topRatedMovies: false,
        .theHighestGrossingMovies: false
    ]

    // MARK: - Init
    init(
        view: MainViewProtocol? = nil,
        interactor: MainInteractorProtocol,
        router: MainRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        // Set loading indicator for sections
        [.genres, .upcomingMovies, .popularMovies, .topRatedMovies, .theHighestGrossingMovies].forEach {
            setLoading(for: $0, isLoading: true)
        }
        // Fetch genres
        interactor.fetchMovieGenres()
        // Fetch movies by type
        [.upcomingMovies, .popularMovies, .topRatedMovies, .theHighestGrossingMovies].forEach {
            interactor.fetchMovies(with: $0)
        }
        // User profile will be fetched automatically during profile observer setup (in the interactor)
    }

    func didSelectMovie(movieID: Int) {
        let allMoviesArray = moviesDict.flatMap { $0.value }
        guard let movie = allMoviesArray.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            return
        }

        // Set loading indicator for sections
        [.popularMovies, .topRatedMovies, .theHighestGrossingMovies].forEach {
            setLoading(for: $0, isLoading: true)
        }
        // Fetch movies with genre filtering
        [.popularMovies, .topRatedMovies, .theHighestGrossingMovies].forEach {
            interactor.fetchMoviesByGenre(movieGenre, listType: $0)
        }
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }

    func didTapFavouriteButton() {
        router.navigateToWishlist()
    }

    func presentSearchScene() {
        router.navigateToSearchScene()
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map genres", underlying: nil))

            return
        }

        setLoading(for: .genres, isLoading: false)
        view?.showMovieGenres(genreViewModels)
    }

    func didFetchMovies(_ movies: [MovieProtocol], for type: MovieListType) {
        switch type {
        case .upcomingMovies:
            didFetchUpcomingMovies(movies)
        case .popularMovies:
            didFetchPopularMovies(movies)
        case .topRatedMovies:
            didFetchTopRatedMovies(movies)
        case .theHighestGrossingMovies:
            didFetchTheHighestGrossingMovies(movies)
        default:
            break
        }
    }

    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to load profile", underlying: nil))

            return
        }

        setLoading(for: .userProfile, isLoading: false)
        view?.showUserProfile(profileViewModel)
    }

    func didBeginProfileUpdate() {
        setLoading(for: .userProfile, isLoading: true)
    }

    func didLogOut() {
        setLoading(for: .userProfile, isLoading: false)
        view?.didLogOut()
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        loadingStates.forEach { setLoading(for: $0.key, isLoading: false) }
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))
    }
}

// MARK: - Private
extension MainPresenter {
    private func setLoading(for section: MainAppSection, isLoading: Bool) {
        loadingStates[section] = isLoading
        // Notify the view
        view?.setLoadingIndicator(for: section, isVisible: isLoading)
    }

    private func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        guard let upcomingMovieViewModels = mapper.map(data: movies, to: [UpcomingMovieViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map upcoming movies", underlying: nil))

            return
        }
        // Update the view with the fetched data
        setLoading(for: .upcomingMovies, isLoading: false)
        view?.showUpcomingMovies(upcomingMovieViewModels)
        moviesDict[.upcomingMovies] = movies
    }

    private func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        guard let popularMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map popular movies", underlying: nil))

            return
        }

        setLoading(for: .popularMovies, isLoading: false)
        view?.showPopularMovies(popularMovieViewModels)
        moviesDict[.popularMovies] = movies
    }

    private func didFetchTopRatedMovies(_ movies: [MovieProtocol]) {
        guard let topRatedMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map top rated movies", underlying: nil))

            return
        }

        setLoading(for: .topRatedMovies, isLoading: false)
        view?.showTopRatedMovies(topRatedMovieViewModels)
        moviesDict[.topRatedMovies] = movies
    }

    private func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol]) {
        guard let theHighestGrossingMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map the highest grossing movies", underlying: nil))

            return
        }

        setLoading(for: .theHighestGrossingMovies, isLoading: false)
        view?.showTheHighestGrossingMovies(theHighestGrossingMovieViewModels)
        moviesDict[.theHighestGrossingMovies] = movies
    }
}
