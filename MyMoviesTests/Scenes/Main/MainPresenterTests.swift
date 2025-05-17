//
//  MainPresenterTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MainPresenterTests
final class MainPresenterTests: XCTestCase {
    // System Under Test (SUT)
    private var presenter: MainPresenter!
    // Mock dependencies
    private var mockView: MockMainView!
    private var mockInteractor: MockMainInteractor!
    private var mockRouter: MockMainRouter!

    override func setUp() {
        super.setUp()

        mockView = MockMainView()
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        presenter = MainPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        mockInteractor.presenter = presenter
    }

    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        presenter = nil

        super.tearDown()
    }
    
    // MARK: - Tests
    func testViewDidLoad_ShouldFetchAllSectionsAndSetLoading() {
        // given
        mockInteractor.movieGenres = [MockGenre(), MockGenre()]
        mockInteractor.movies = [MockMovie(), MockMovie(), MockMovie()]
        mockInteractor.userProfile = UserProfile(id: "mock", email: "mock@email.com")
        
        let expectationForGenres = expectation(description: "Should fetch movie genres within 0.3 seconds")
        let expectationForUpcomingMovies = expectation(description: "Should fetch upcoming movies within 0.3 seconds")
        let expectationForPopularMovies = expectation(description: "Should fetch popular movies within 0.3 seconds")
        let expectationForTopRatedMovies = expectation(description: "Should fetch top rated movies within 0.3 seconds")
        let expectationForTheHighestGrossingMovies = expectation(description: "Should fetch highest grossing movies within 0.3 seconds")
        
        mockView.didCallShowMovieGenresCallBack = { [weak self] genres in
            // The initial count has to be decreased by 1 with the default "All" genres value
            XCTAssertEqual(genres.count - 1, self?.mockInteractor.movieGenres?.count, "View should get genres from presenter")
            XCTAssertEqual(self?.mockView.loadingStates[.genres], false, "Loading indicator for genres section shouldn't be visible")
            expectationForGenres.fulfill()
        }
        
        mockView.didCallShowUpcomingMoviesCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get upcoming movies from presenter")
            XCTAssertEqual(self?.mockView.loadingStates[.upcomingMovies], false, "Loading indicator for upcoming movies section shouldn't be visible")
            expectationForUpcomingMovies.fulfill()
        }
        
        mockView.didCallShowPopularMoviesCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get popular movies from presenter")
            XCTAssertEqual(self?.mockView.loadingStates[.popularMovies], false, "Loading indicator for popular movies section shouldn't be visible")
            expectationForPopularMovies.fulfill()
        }
        
        mockView.didCallShowTopRatedMoviesCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get top rated movies from presenter")
            XCTAssertEqual(self?.mockView.loadingStates[.topRatedMovies], false, "Loading indicator for top rated movies section shouldn't be visible")
            expectationForTopRatedMovies.fulfill()
        }
        
        mockView.didCallShowTheHighestGrossingMoviesCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get highest grossing movies from presenter")
            XCTAssertEqual(self?.mockView.loadingStates[.theHighestGrossingMovies], false, "Loading indicator for highest grossing movies section shouldn't be visible")
            expectationForTheHighestGrossingMovies.fulfill()
        }
        
        // when
        presenter.viewDidLoad()
        
        // then
        // All sections should be fetched and all loading indicators should be visible
        // Genres
        XCTAssertTrue(mockInteractor.didCallFetchMovieGenres, "Presenter should call interactor to fetch movie genres")
        XCTAssertEqual(mockView.loadingStates[.genres], true, "Loading indicator for genres section should be visible")
        
        // Upcoming movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.upcomingMovies], true, "Presenter should call interactor to fetch upcoming movies")
        XCTAssertEqual(mockView.loadingStates[.upcomingMovies], true, "Loading indicator for upcoming movies section should be visible")
        // Popular movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.popularMovies], true, "Presenter should call interactor to fetch popular movies")
        XCTAssertEqual(mockView.loadingStates[.popularMovies], true, "Loading indicator for popular movies section should be visible")
        // Top rated movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.topRatedMovies], true, "Presenter should call interactor to fetch top rated movies")
        XCTAssertEqual(mockView.loadingStates[.topRatedMovies], true, "Loading indicator for top rated movies section should be visible")
        // The highest grossing movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.theHighestGrossingMovies], true, "Presenter should call interactor to fetch highest grossing movies")
        XCTAssertEqual(mockView.loadingStates[.theHighestGrossingMovies], true, "Loading indicator for highest grossing movies section should be visible")
        
        wait(for: [expectationForGenres, expectationForUpcomingMovies, expectationForPopularMovies, expectationForTopRatedMovies, expectationForTheHighestGrossingMovies], timeout: 0.3)
    }

    func testDidSelectMovie_ShouldShowMovieDetails_WhenMovieExist() {
        // given
        let movie = MockMovie()
        // call didFetch in order to set presenter moviesDict (to ensure WhenMovieExist)
        presenter.didFetchMovies([movie], for: .upcomingMovies)
        
        // when
        presenter.didSelectMovie(movieID: movie.id)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToMovieDetails, "Presenter should call router to show movie details")
        XCTAssertEqual(mockRouter.capturedMovie?.id, movie.id, "Router should get movie id from presenter")
    }
    
    func testDidSelectMovie_ShouldDoNothing_WhenMovieDoesNotExist() {
        // given
        let movieID = 0

        // when
        presenter.didSelectMovie(movieID: movieID)

        // then
        XCTAssertFalse(mockRouter.didCallNavigateToMovieDetails, "Presenter should not call router to show movie details")
    }
    
    func testDidSelectGenre_ShouldMapAndCallFilteredFetch() {
        // given
        let genre = MockGenreViewModel()
        
        // when
        presenter.didSelectGenre(genre)

        // then
        // Sections should be fetched with genre filtering and all loading indicators should be visible
        // Popular movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.popularMovies], true, "Presenter should call interactor to fetch popular movies")
        XCTAssertEqual(mockView.loadingStates[.popularMovies], true, "Loading indicator for popular movies section should be visible")
        // Top rated movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.topRatedMovies], true, "Presenter should call interactor to fetch top rated movies")
        XCTAssertEqual(mockView.loadingStates[.topRatedMovies], true, "Loading indicator for top rated movies section should be visible")
        // The highest grossing movies
        XCTAssertEqual(mockInteractor.didCallFetchMoviesForType[.theHighestGrossingMovies], true, "Presenter should call interactor to fetch highest grossing movies")
        XCTAssertEqual(mockView.loadingStates[.theHighestGrossingMovies], true, "Loading indicator for highest grossing movies section should be visible")
    }

    func testDidTapSeeAll_ShouldNavigateToMovieList() {
        // given
        let listType: MovieListType = .upcomingMovies

        // when
        presenter.didTapSeeAllButton(listType: listType)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToMovieList, "Presenter should call router to show movie list")
        XCTAssertEqual(mockRouter.capturedMovieListType, listType, "Router should get movie list type from presenter")
    }
    
    func testDidTapFavouriteButton_ShouldNavigateToWishlist() {
        // given
        // when
        presenter.didTapFavouriteButton()
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToWishlist, "Presenter should call router to show wishlist")
    }
}
