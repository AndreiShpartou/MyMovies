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
            userProfileObserver: mockUserProfileObserver
        )
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        mockNetworkService = nil
        mockGenreRepository = nil
        mockMovieRepository = nil
        mockPresenter = nil

        super.tearDown()
    }
    
    // MARK: - Tests
}
