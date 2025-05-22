//
//  MovieDetailsInteractorTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 18/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MovieDetailsInteractorTests
final class MovieDetailsInteractorTests: XCTestCase {
    // System Under Test (SUT)
    private var interactor: MovieDetailsInteractor!
    // Mock dependencies
    private var mockNetworkService: MockNetworkService!
    private var mockMovieRepository: MockMovieRepository!
    private var mockPresenter: MockMovieDetailsPresenter!
    private var mockMovie: MockMovie!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        mockMovieRepository = MockMovieRepository()
        mockPresenter = MockMovieDetailsPresenter()
        mockMovie = MockMovie()
        
        interactor = MovieDetailsInteractor(
            movie: mockMovie,
            networkService: mockNetworkService,
            movieRepository: mockMovieRepository
        )
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        mockNetworkService = nil
        mockMovieRepository = nil
        mockPresenter = nil
        mockMovie = nil
        interactor = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests Success
    func testFetchMovieDetails_ShouldReturnMovie() {
        // given
        let expectation = expectation(description: "Should call didCallFetchMovieCallBack during 0.3 seconds")
        mockPresenter.didCallFetchMovieCallBack = { [weak self] movie in
            XCTAssertEqual(movie.id, self?.mockMovie.id, "Presenter should receive movie")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovie()
        
        // then
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchReviews_WithNetworkServiceSuccess_ShouldReturnReviews() {
        // given
        mockNetworkService.stubbedReviews = [MockReview()]
        mockNetworkService.fetchReviewsShouldReturnError = false
        
        let expectation = expectation(description: "Should call didCallFetchReviewsCallBack during 0.3 seconds")
        mockPresenter.didCallFetchReviewsCallBack = { reviews in
            XCTAssertEqual(reviews.count, 1, "Presenter should receive reviews from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchReviews()
        
        // then
        XCTAssertTrue(mockNetworkService.didCallFetchReviews, "Should fetch reviews from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchSimilarMovies_WithDistinctNetworkServiceEndpoint_AndDetails_ShouldReturnMovies() {
        // given
        let listType = MovieListType.similarMovies(id: mockMovie.id)
        mockNetworkService.stubbedMovies = [MockMovie(id: 2)]
        mockNetworkService.fetchMoviesShouldReturnError = false
        mockNetworkService.fetchMoviesDetailsShouldReturnError = false
        
        let expectation = expectation(description: "Should call didCallFetchSimilarMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallFetchSimilarMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchSimilarMovies()
        
        // then
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should call fetch similar movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, listType, "Should pass the same type to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchSimilarMovies_WithNetworkServiceSuccess_AndDetailsById_ShouldReturnMovies() {
        // given
        let mockMovie = MockMovie(id: 1, similarMovies: [MockMovie(id: 2)])
        interactor = MovieDetailsInteractor(
            movie: mockMovie,
            networkService: mockNetworkService,
            movieRepository: mockMovieRepository
        )
        interactor.presenter = mockPresenter

        mockNetworkService.stubbedMovies = mockMovie.similarMovies!
        mockNetworkService.fetchMoviesDetailsByIDShouldReturnError = false
        
        let expectation = expectation(description: "Should call didCallFetchSimilarMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallFetchSimilarMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchSimilarMovies()
        
        // then
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetailsByID, "Should call fetch similar movies details from network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchMovieInList_WithRepositorySuccess_ShouldReturnBool() {
        // given
        mockMovieRepository.stubbedMovies = [mockMovie]
        mockMovieRepository.fetchMovieByIDShouldReturnError = false
        let listType = MovieListType.favouriteMovies
        
        let expectation = expectation(description: "Should call didCallFetchMovieInListCallBack during 0.3 seconds")
        mockPresenter.didCallFetchIsMovieInListCallBack = { (isInList, listType) in
            XCTAssertTrue(isInList, "Presenter should receive isInList from repository")
            XCTAssertEqual(listType, MovieListType.favouriteMovies, "Should pass the same type to repository")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchIsMovieInList(listType: listType)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMovieByID, "Should call fetch movie from repository")
        wait(for: [expectation], timeout: 0.3)
    }
    
    // MARK: - Tests Failures
    func testFetchReviews_WithNetworkServiceFailure_ShouldReturnError() {
        // given
        mockNetworkService.fetchReviewsShouldReturnError = true

        let expectation = expectation(description: "Should call didCallFetchReviewsCallBack during 0.3 seconds")
        mockPresenter.didCallFetchErrorCallBack = { error in
            XCTAssertNotNil(error, "Presenter should receive error from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchReviews()
        
        // then
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchSimilarMovies_WithNetworkServiceFailure_ShouldReturnError() {
        // given
        mockNetworkService.fetchMoviesShouldReturnError = true
        
        let expectation = expectation(description: "Should call didCallFetchErrorCallBack during 0.3 seconds")
        mockPresenter.didCallFetchErrorCallBack = { error in
            XCTAssertNotNil(error, "Presenter should receive error from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchSimilarMovies()
        
        // then
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchMovieInList_WithRepositoryFailure_ShouldReturnError() {
        // given
        mockMovieRepository.fetchMovieByIDShouldReturnError = true
        let listType = MovieListType.favouriteMovies
        
        let expectation = expectation(description: "Should call didCallFetchErrorCallBack during 0.3 seconds")
        mockPresenter.didCallFetchErrorCallBack = { error in
            XCTAssertNotNil(error, "Presenter should receive error from repository")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchIsMovieInList(listType: listType)
        
        // then
        wait(for: [expectation], timeout: 0.3)
    }
}
