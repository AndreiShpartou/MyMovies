//
//  MovieListPresenterTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 18/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MovieListPresenterTests
final class MovieListPresenterTests: XCTestCase {
    // System Under Test (SUT)
    private var presenter: MovieListPresenter!
    // Mock dependencies
    private var mockView: MockMovieListView!
    private var mockInteractor: MockMovieListInteractor!
    private var mockRouter: MockMovieListRouter!

    override func setUp() {
        super.setUp()
        
        mockView = MockMovieListView()
        mockInteractor = MockMovieListInteractor()
        mockRouter = MockMovieListRouter()
        presenter = MovieListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
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
    func testViewDidLoad_ShouldFetchGenresFetchMovies() {
        // given
        let listType = MovieListType.upcomingMovies
        mockInteractor.genres = [MockGenre(), MockGenre()]
        mockInteractor.movies = [MockMovie(), MockMovie(), MockMovie()]
        
        let expectationForGenres = expectation(description: "Should call didCallShowMovieGenresCallBack within 0.3 seconds")
        let expectationForUpcomingMovies = expectation(description: "Should call didCallShowMovieListCallBack within 0.3 seconds")
        
        mockView.didCallShowMovieGenresCallBack = { [weak self] genres in
            // The initial count has to be decreased by 1 with the default "All" genres value
            XCTAssertEqual(genres.count - 1, self?.mockInteractor.genres?.count, "View should get genres from presenter")
            expectationForGenres.fulfill()
        }
        
        mockView.didCallShowMovieListCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get movies from presenter")
            XCTAssertEqual(self?.mockView.capturedIndicatorState, false, "Loading indicator for movies section shouldn't be visible")
            expectationForUpcomingMovies.fulfill()
        }
        
        // when
        presenter.viewDidLoad(listType: listType)
        
        // then
        XCTAssertTrue(mockInteractor.didCallFetchMovieGenres, "Presenter should call interactor to fetch movie genres")
        XCTAssertTrue(mockInteractor.didCallFetchMovieList, "Presenter should call interactor to fetch movies")
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should call view to set loading indicator")
        XCTAssertTrue(mockView.capturedIndicatorState!, "Loading indicator should be visible")

        wait(for: [expectationForGenres, expectationForUpcomingMovies], timeout: 0.3)
    }
    
    func testDidSelectGenre_ShouldFetchMovies() {
        // given
        let genre = GenreViewModel(id: 1, name: "mockGenre")
        mockInteractor.movies = [MockMovie(), MockMovie(), MockMovie()]
        let expectationForUpcomingMovies = expectation(description: "Should call didCallShowMovieListCallBack within 0.3 seconds")
        
        mockView.didCallShowMovieListCallBack = { [weak self] movies in
            XCTAssertEqual(movies.count, self?.mockInteractor.movies?.count, "View should get movies from presenter")
            XCTAssertEqual(self?.mockView.capturedIndicatorState, false, "Loading indicator for movies section shouldn't be visible")
            expectationForUpcomingMovies.fulfill()
        }
        
        // when
        presenter.didSelectGenre(genre)
        
        // then
        XCTAssertTrue(mockInteractor.didCallFetchMovieListWithGenresFiltering, "Presenter should call interactor to fetch movies")
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should call view to set loading indicator")
        XCTAssertTrue(mockView.capturedIndicatorState!, "Loading indicator should be visible")

        wait(for: [expectationForUpcomingMovies], timeout: 0.3)
    }
    
    func testDidSelectMovie_ShouldOpenMovieDetails() {
        // given
        let movie = MockMovie()
        // Call didFetch in order to set presenter movies array
        presenter.didFetchMovieList([movie])

        // when
        presenter.didSelectMovie(movieID: movie.id)

        // then
        XCTAssertTrue(mockRouter.didCallNavigateToMovieDetails, "Presenter should call router to open movie details")
        XCTAssertEqual(mockRouter.didCallNavigateToMovieDetailsWith?.id, movie.id, "Router should get movie id from presenter")
    }
}
