//
//  MainInteractorTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MainInteractorTests
final class MainInteractorTests: XCTestCase {
    // System Under Test (SUT)
    private var interactor: MainInteractor!
    // Mock dependencies
    private var mockNetworkService: MockNetworkService!
    private var mockGenreRepository: MockGenreRepository!
    private var mockMovieRepository: MockMovieRepository!
    private var mockPresenter: MockMainPresenter!
    private var mockUserProfileObserver: UserProfileObserverProtocol!

    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        mockGenreRepository = MockGenreRepository()
        mockMovieRepository = MockMovieRepository()
        mockPresenter = MockMainPresenter()
        mockUserProfileObserver = UserProfileObserver(
            authService: MockAuthService(),
            profileDocumentsStoreService: MockProfileDocumentsStoreService()
        )

        interactor = MainInteractor(
            networkService: mockNetworkService,
            genreRepository: mockGenreRepository,
            movieRepository: mockMovieRepository,
            userProfileObserver: mockUserProfileObserver,
            staleSeconds: Date().timeIntervalSince1970
        )
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        mockNetworkService = nil
        mockGenreRepository = nil
        mockMovieRepository = nil
        mockPresenter = nil
        mockUserProfileObserver = nil
        interactor = nil

        super.tearDown()
    }
    
    // MARK: - Tests Genres Success
    func testFetchGenres_WithCachedGenresSuccess_ShouldReturnCachedGenres() {
        // given
        mockGenreRepository.stubbedGenres = [MockMovie.Genre()]
        mockGenreRepository.fetchGenresShouldReturnError = false

        let expectation = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive cached genres")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres()
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should fetch genres from repository")
        XCTAssertFalse(mockNetworkService.didCallFetchGenres, "Should not fetch genres from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchGenres_WithNetworkServiceSuccess_ShouldReturnGenresAndSaveToCache() {
        // given
        mockGenreRepository.stubbedGenres = []
        mockGenreRepository.fetchGenresShouldReturnError = false
        mockNetworkService.stubbedGenres = [MockMovie.Genre()]
        mockNetworkService.fetchGenresShouldReturnError = false
        
        let expectation = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive genres from network")
            expectation.fulfill()
        }

        // when
        interactor.fetchMovieGenres()

        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should fetch genres from network")
        XCTAssertEqual(mockGenreRepository.capturedGenres?.count, 1, "GenreRepository should receive genres to save")
        XCTAssertTrue(mockGenreRepository.didCallSaveGenres, "Should save genres to repository")
        wait(for: [expectation], timeout: 0.3)
    }
    
    // MARK: - Genres Error
    func testFetchGenres_WithRepositoryError_ShouldReturnError_AndFetchFromNetwork() {
        // given
        mockGenreRepository.fetchGenresShouldReturnError = true
        mockNetworkService.stubbedGenres = [MockMovie.Genre()]
        mockNetworkService.fetchGenresShouldReturnError = false
        
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
        interactor.fetchMovieGenres()
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should fetch genres from network")
        XCTAssertEqual(mockGenreRepository.capturedGenres?.count, 1, "GenreRepository should receive genres to save")
        XCTAssertTrue(mockGenreRepository.didCallSaveGenres, "Should save genres to repository")
        wait(for: [expectationForPresentingError, expectationForPresentingGenres], timeout: 0.3)
    }
    
    func testFetchGenres_WithNetworkError_ShouldReturnError() {
        // given
        mockGenreRepository.stubbedGenres = []
        mockGenreRepository.fetchGenresShouldReturnError = false
        mockNetworkService.fetchGenresShouldReturnError = true
        
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from network")
            expectationForError.fulfill()
        }

        // when
        interactor.fetchMovieGenres()

        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should call fetch genres from network")
        wait(for: [expectationForError], timeout: 0.3)
    }
    
    func testFetchGenres_WithNetworkSuccess_AndRepositorySavingError() {
        mockGenreRepository.stubbedGenres = []
        mockGenreRepository.fetchGenresShouldReturnError = false
        mockGenreRepository.saveGenresShouldReturnError = true
        mockNetworkService.stubbedGenres = [MockMovie.Genre()]
        mockNetworkService.fetchGenresShouldReturnError = false
        
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from repository")
            expectationForError.fulfill()
        }
        
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMovieGenresCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMovieGenresCallBack = { genres in
            XCTAssertEqual(genres.count, 1, "Presenter should receive genres from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMovieGenres()
        
        // then
        XCTAssertTrue(mockGenreRepository.didCallFetchGenres, "Should call fetch genres from repository")
        XCTAssertTrue(mockNetworkService.didCallFetchGenres, "Should fetch genres from network")
        XCTAssertEqual(mockGenreRepository.capturedGenres?.count, 1, "GenreRepository should receive genres to save")
        XCTAssertTrue(mockGenreRepository.didCallSaveGenres, "Should save genres to repository")
        wait(for: [expectationForError, expectationForPresenting], timeout: 0.3)
    }
    
    // MARK: - Movies Success
    func testFetchMovies_WithCachedMoviesSuccess_ShouldReturnCachedMovies() {
        // given
        mockMovieRepository.stubbedMovies = [MockMovie()]
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        let type = MovieListType.popularMovies
        
        // Should return cached movies
        let expectation = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive cached movies")
            expectation.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to repository")
        XCTAssertFalse(mockNetworkService.didCallFetchMovies, "Should not fetch movies from network")
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testFetchMovies_WithNetworkSuccess_ShouldReturnMoviesAndSaveToCache() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        let type = MovieListType.upcomingMovies
        
        // Should return movies from network
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        XCTAssertTrue(mockMovieRepository.didCallStoreMoviesForList, "Should call save movies to repository")
        XCTAssertEqual(mockMovieRepository.capturedMovies?.count, 1, "Should capture the same movies")
        wait(for: [expectationForPresenting], timeout: 0.3)
    }
    
    func testFetchMovies_WithNetworkSuccess_AndStaleData_ShouldReturnMoviesAndSaveToCache() {
        // given
        // Reinit interactor to set stale seconds
        interactor = MainInteractor(
            networkService: mockNetworkService,
            genreRepository: mockGenreRepository,
            movieRepository: mockMovieRepository,
            userProfileObserver: mockUserProfileObserver,
            staleSeconds: 0
        )
        interactor.presenter = mockPresenter
        
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        mockMovieRepository.clearMoviesForListShouldReturnError = false
        let type = MovieListType.theHighestGrossingMovies
        
        // Should return movies from network
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertFalse(mockMovieRepository.didCallFetchMoviesByList, "Shouldn't call fetch movies from repository")
        XCTAssertTrue(mockMovieRepository.didCallClearMoviesForList, "Should call clear movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to mockMovieRepository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should call fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        XCTAssertTrue(mockMovieRepository.didCallStoreMoviesForList, "Should call save movies to repository")
        XCTAssertEqual(mockMovieRepository.capturedMovies?.count, 1, "Should capture the same movies")
        wait(for: [expectationForPresenting], timeout: 0.3)
    }
    
    func testFetchMoviesByGenre_WithNetworkSuccess_ShouldReturnMovies() {
        // given
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesByGenreShouldReturnError = false
        let type = MovieListType.upcomingMovies
        let genre = MockMovie.Genre()
        
        // Should return movies from network
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMoviesByGenre(genre, listType: type)

        // then
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesByGenre, "Should fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        XCTAssertEqual(mockNetworkService.capturedGenre?.id, genre.id, "Should pass the same genre to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        wait(for: [expectationForPresenting], timeout: 0.3)
    }
    
    // MARK: - Movies Error
    func testFetchMovies_WithRepositoryError_ShouldReturnError_ShouldReturnMoviesFromNetworkAndSaveToCache() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = true
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        let type = MovieListType.upcomingMovies
        
        // Should return an error from repository
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from repository")
            expectationForError.fulfill()
        }
        
        // Should return movies from network
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        XCTAssertTrue(mockMovieRepository.didCallStoreMoviesForList, "Should call save movies to repository")
        XCTAssertEqual(mockMovieRepository.capturedMovies?.count, 1, "Should capture the same movies")
        wait(for: [expectationForPresenting, expectationForError], timeout: 0.3)
    }
    
    func testFetchMovies_WithNetworkService_ShouldReturnError() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        mockNetworkService.stubbedMovies = []
        mockNetworkService.fetchMoviesShouldReturnError = true
        let type = MovieListType.topRatedMovies
        
        // Should return an error from network
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from network")
            expectationForError.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should call fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        wait(for: [expectationForError], timeout: 0.3)
    }
    
    func testFetchMovies_WithSaveToRepositoryError_ShouldReturnError_ShouldReturnMoviesFromNetwork() {
        // given
        mockMovieRepository.stubbedMovies = []
        mockMovieRepository.fetchMoviesByListShouldReturnError = false
        mockMovieRepository.storeMoviesForListShouldReturnError = true
        mockNetworkService.stubbedMovies = [MockMovie()]
        mockNetworkService.fetchMoviesShouldReturnError = false
        let type = MovieListType.upcomingMovies
        
        // Should return an error from repository while saving
        let expectationForError = expectation(description: "Should call didCallDidFailToFetchDataCallBack during 0.3 seconds")
        mockPresenter.didCallDidFailToFetchDataCallBack = { error in
            XCTAssertTrue(true, "Presenter should receive error from repository while saving")
            expectationForError.fulfill()
        }
        
        // Should return movies from network
        let expectationForPresenting = expectation(description: "Should call didCallDidFetchMoviesCallBack during 0.3 seconds")
        mockPresenter.didCallDidFetchMoviesCallBack = { movies in
            XCTAssertEqual(movies.count, 1, "Presenter should receive movies from network")
            expectationForPresenting.fulfill()
        }
        
        // when
        interactor.fetchMovies(with: type)
        
        // then
        XCTAssertTrue(mockMovieRepository.didCallFetchMoviesByList, "Should call fetch movies from repository")
        XCTAssertEqual(mockMovieRepository.capturedListType, type.rawValue, "Should pass the same type to repository")
        XCTAssertTrue(mockNetworkService.didCallFetchMovies, "Should fetch movies from network")
        XCTAssertEqual(mockNetworkService.capturedMovieListType, type, "Should pass the same type to network")
        XCTAssertTrue(mockNetworkService.didCallFetchMoviesDetails, "Should call fetch movies details from network")
        XCTAssertTrue(mockMovieRepository.didCallStoreMoviesForList, "Should call save movies to repository")
        wait(for: [expectationForPresenting, expectationForError], timeout: 0.3)
    }
}
