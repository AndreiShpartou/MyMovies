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
        setLoading(for: .genres, isLoading: true)
        interactor.fetchMovieGenres()

        setLoading(for: .upcomingMovies, isLoading: true)
        interactor.fetchUpcomingMovies()

        setLoading(for: .popularMovies, isLoading: true)
        interactor.fetchPopularMovies()

        setLoading(for: .topRatedMovies, isLoading: true)
        interactor.fetchTopRatedMovies()

        setLoading(for: .theHighestGrossingMovies, isLoading: true)
        interactor.fetchTheHighestGrossingMovies()
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

        setLoading(for: .popularMovies, isLoading: true)
        interactor.fetchPopularMoviesWithGenresFiltering(genre: movieGenre)

        setLoading(for: .topRatedMovies, isLoading: true)
        interactor.fetchTopRatedMoviesWithGenresFiltering(genre: movieGenre)

        setLoading(for: .theHighestGrossingMovies, isLoading: true)
        interactor.fetchTheHighestGrossingMoviesWithGenresFiltering(genre: movieGenre)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }

    func didTapFavouriteButton() {
        router.navigateToWishlist()
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {

    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        guard let upcomingMovieViewModels = mapper.map(data: movies, to: [UpcomingMovieViewModel].self) else {
            return
        }
        // Update the view with the fetched data
        view?.showUpcomingMovies(upcomingMovieViewModels)
        moviesDict[.upcomingMovies] = movies
        setLoading(for: .upcomingMovies, isLoading: false)
    }

    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            return
        }

        view?.showMovieGenres(genreViewModels)
        setLoading(for: .genres, isLoading: false)
    }

    func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        guard let popularMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showPopularMovies(popularMovieViewModels)
        moviesDict[.popularMovies] = movies
        setLoading(for: .popularMovies, isLoading: false)
    }

    func didFetchTopRatedMovies(_ movies: [MovieProtocol]) {
        guard let topRatedMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showTopRatedMovies(topRatedMovieViewModels)
        moviesDict[.topRatedMovies] = movies
        setLoading(for: .topRatedMovies, isLoading: false)
    }

    func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol]) {
        guard let theHighestGrossingMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showTheHighestGrossingMovies(theHighestGrossingMovieViewModels)
        moviesDict[.theHighestGrossingMovies] = movies
        setLoading(for: .theHighestGrossingMovies, isLoading: false)
    }

    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            view?.showError(error: AppError.customError(message: "Failed to load profile", comment: "Error message for failed profile load"))

            return
        }

        view?.showUserProfile(profileViewModel)
        setLoading(for: .userProfile, isLoading: false)
    }

    func didBeginProfileUpdate() {
        setLoading(for: .userProfile, isLoading: true)
    }

    func didLogOut() {
        view?.didLogOut()
        setLoading(for: .userProfile, isLoading: false)
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
        loadingStates.forEach { setLoading(for: $0.key, isLoading: false) }
    }
}

// MARK: - Private
extension MainPresenter {
    private func setLoading(for section: MainAppSection, isLoading: Bool) {
        loadingStates[section] = isLoading
        // Notify the view
        view?.setLoadingIndicator(for: section, isVisible: isLoading)
    }
}
