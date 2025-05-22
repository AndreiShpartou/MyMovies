//
//  MovieDetailsPresenterTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 18/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MovieDetailsPresenterTests
final class MovieDetailsPresenterTests: XCTestCase {
    // System Under Test (SUT)
    private var presenter: MovieDetailsPresenter!
    // Mock dependencies
    private var mockView: MockMovieDetailsView!
    private var mockInteractor: MockMovieDetailsInteractor!
    private var mockRouter: MockMovieDetailsRouter!

    override func setUp() {
        super.setUp()
        
        mockView = MockMovieDetailsView()
        mockInteractor = MockMovieDetailsInteractor()
        mockRouter = MockMovieDetailsRouter()
        presenter = MovieDetailsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
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
    func testViewDidLoad_ShouldFetchAllMovieData() {
        // given
        mockInteractor.movie = MockMovie()
        mockInteractor.reviews = [MockReview()]
        mockInteractor.similarMovies = [MockMovie()]
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(mockInteractor.didCallFetchMovie, "Presenter should call interactor to fetch movie details")
        XCTAssertEqual(mockView.capturedMovie?.id, mockInteractor.movie?.id, "View should get movie details from presenter")
        XCTAssertTrue(mockInteractor.didCallFetchReviews, "Presenter should call interactor to fetch movie reviews")
        XCTAssertEqual(mockView.capturedReviews?.count, mockInteractor.reviews?.count, "View should get movie reviews from presenter")
        XCTAssertTrue(mockInteractor.didCallFetchSimilarMovies, "Presenter should call interactor to fetch similar movies")
        XCTAssertEqual(mockView.capturedSimilarMovies?.count, mockInteractor.similarMovies?.count, "View should get similar movies from presenter")
        XCTAssertTrue(mockInteractor.didCallFetchIsMovieInList, "Presenter should call interactor to check if movie is in wishlist")
    }
    
    func testDidTapSeeAllButton_ShouldNavigateToMovieList() {
        // given
        let listType = MovieListType.upcomingMovies
        // when
        presenter.didTapSeeAllButton(listType: listType)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToMovieList, "Presenter should call router to show movie list")
        XCTAssertEqual(mockRouter.capturedType?.rawValue, listType.rawValue, "Router should get movie list type from presenter")
    }
    
    func testDidTapDidSelectMovie_ShouldNavigateToMovieDetails() {
        // given
        let movie = MockMovie()
        // call didFetch in order to set presenter similarMovies property
        presenter.didFetchSimilarMovies([movie])
        // when
        presenter.didSelectMovie(movieID: movie.id)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToMovieDetails, "Presenter should call router to show movie details")
        XCTAssertEqual(mockRouter.capturedMovie?.id, movie.id, "Router should get movie id from presenter")
    }
    
    func testDidTapDidSelectPerson_ShouldNavigateToPersonDetails() {
        // given
        let person = MockPerson()
        // when
        presenter.didSelectPerson(personID: person.id)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToPersonDetails, "Presenter should call router to show person details")
        XCTAssertEqual(mockRouter.capturedPersonID, person.id, "Router should get person id from presenter")
    }
    
    func testDidTapPresentReview_ShouldNavigateToReviewDetails() {
        // given
        let review = MockReview()
        // when
        presenter.presentReview(with: review.author, and: review.review)
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToReviewDetails, "Presenter should call router to show review details")
        XCTAssertEqual(mockRouter.capturedAuthor, review.author, "Router should get review author from presenter")
        XCTAssertEqual(mockRouter.capturedText, review.review, "Router should get review text from presenter")
    }
    
    func testDidTapFavouriteButton_ShouldToggleFavouriteStatus() {
        // given
        // when
        presenter.didTapFavouriteButton()
        
        // then
        XCTAssertTrue(mockInteractor.didCallToggleFavouriteStatus, "Presenter should call interactor to toggle favourite status")
    }
}
