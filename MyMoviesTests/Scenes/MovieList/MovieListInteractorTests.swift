//
//  MovieListInteractorTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 19/04/2025.
//

import XCTest
@testable import MyMovies

final class MovieListInteractorTests: XCTestCase {
    // System Under Test (SUT)
    private var interactor: MovieListInteractor!
    // Mock dependencies
    private var mockNetworkService: MockNetworkService!
    private var mockGenreRepository: MockGenreRepository!
    private var mockMovieRepository: MockMovieRepository!
    private var mockPresenter: MockMovieListPresenter!
    
    // MARK: - Init
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        mockGenreRepository = MockGenreRepository()
        mockMovieRepository = MockMovieRepository()
        mockPresenter = MockMovieListPresenter()
        
        interactor = MovieListInteractor(
            networkService: mockNetworkService,
            genreRepository: mockGenreRepository,
            movieRepository: mockMovieRepository
        )
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        mockNetworkService = nil
        mockGenreRepository = nil
        mockMovieRepository = nil
        mockPresenter = nil
        interactor = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests Genres Success
    func testFetchGenres_WithCachedGenresSuccess_ShouldReturnCachedGenres() {
        // given
        mockGenreRepository.stubbedGenres = [MockGenre()]
        mockGenreRepository.fetchGenresShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        let expectation = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive cached genres")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres(type: listType)
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should fetch genres from repository")
        XCTAssertFalse(mockNetworkService.didCallFetchGenres, "Should not fetch genres from network")
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchGenres_WithNetworkServiceSuccess_ShouldReturnGenres() {
        // given
        mockGenreRepository.stubbedGenres = []
        mockGenreRepository.fetchGenresShouldReturnError = false
        mockNetworkService.stubbedGenres = [MockGenre()]
        mockNetworkService.fetchGenresShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        let expectation = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive genres from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres(type: listType)
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should fetch genres from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    // MARK: - Genres Error
    func testFetchGenres_WithRepositoryError_ShouldReturnError_AndFetchFromNetwork() {
        // given
        mockGenreRepository.fetchGenresShouldReturnError = true
        mockNetworkService.stubbedGenres = [MockGenre()]
        mockNetworkService.fetchGenresShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        // Should return error from repository
        let expectationForPresentingError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from repository")
            expectationForPresentingError.fulfill()
        }
        // Then should get genres from network
        let expectationForPresentingGenres = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive genres from network")
            expectationForPresentingGenres.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres(type: listType)
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should fetch genres from network")
        
        wait(for: [expectationForPresentingError, expectationForPresentingGenres], timeout: 0.3)
    }
    
    func testFetchGenres_WithNetworkError_ShouldReturnError() {
        // given
        mockGenreRepository.stubbedGenres = []
        mockGenreRepository.fetchGenresShouldReturnError = false
        mockNetworkService.fetchGenresShouldReturnError = true
        let listType = MovieListType.popularMovies
        
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from network")
            expectationForError.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres(type: listType)
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should call fetch genres from network")
        wait(for: [expectationForError], timeout: 0.3)
    }
    
    // MARK: - Movies Success
    func testFetchMovies_WithCachedMoviesSuccess_ShouldReturnCachedMovies() {
        // given
        mockMovieRepository.stubbedMovies = [MockMovie()]
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        let expectation = expectation(description: "Should call didCallDidFetchMovieListCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieListCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive cached movies")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieList(type: listType)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should fetch movies from repository")
        XCTAssertFalse(mockNetworkService.didCallFetchMovies, "Should not fetch movies from network")
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchMovies_WithNetworkSuccess_ShouldReturnMovies() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        let expectation = expectation(description: "Should call didCallDidFetchMovieListCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieListCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieList(type: listType)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchMoviListWithGenreFiltering_WithNetworkSuccess_ShouldReturnMovies() {
        // given
        let listType = MovieListType.popularMovies
        let genre = MockGenre()

        mockMovieRepository.stubbedMovies = []
        mockNetworkService.fetchMoviesShouldReturnError = true
        // Call to set list type for onward filtering
        interactor.fetchMovieList(type: listType)

        mockNetworkService.fetchMoviesShouldReturnError = false
        mockNetworkService.stubbedMovies = [MockMovie()]
        let expectation = expectation(description: "Should call didCallDidFetchMovieListCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieListCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieListWithGenresFiltering(genre: genre)

        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")

        wait(for: [expectation], timeout: 0.3)
    }
    
    // MARK: - Movies Error
    func testFetchMovies_WithRepositoryError_ShouldReturnError_ShouldReturnMoviesFromNetwork() {
        // given
        mockMovieRepository.fetchMoviesByListShouldReturnError = true
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        let listType = MovieListType.popularMovies
        
        // Should return an error from repository
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from repository")
            expectationForError.fulfill()
        }
        
        // Should return movies from network
        let expectationForPresentingMovies = expectation(description: "Should call didCallDidFetchMovieListCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieListCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresentingMovies.fulfill()
        }
        
        // when
        interactor.fetchMovieList(type: listType)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
    
        wait(for: [expectationForError, expectationForPresentingMovies], timeout: 0.3)
    }
    
    func testFetchMovies_WithNetworkServiceError_ShouldReturnError() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        mockNetworkService.fetchMoviesShouldReturnError = true
        let listType = MovieListType.popularMovies
        
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from network")
            expectationForError.fulfill()
        }
        
        // when
        interactor.fetchMovieList(type: listType)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        wait(for: [expectationForError], timeout: 0.3)
    }

}
