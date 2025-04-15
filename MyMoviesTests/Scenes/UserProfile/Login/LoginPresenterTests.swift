//
//  LoginPresenterTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import XCTest
@testable import MyMovies

final class LoginPresenterTests: XCTestCase {
    // System Under Test (SUT)
    private var presenter: LoginPresenter!
    // Mock dependencies
    private var mockView: MockLoginView!
    private var mockInteractor: MockLoginInteractor!
    private var mockRouter: MockLoginRouter!
    
    override func setUp() {
        super.setUp()
        
        mockView = MockLoginView()
        mockInteractor = MockLoginInteractor()
        mockRouter = MockLoginRouter()
        presenter = LoginPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        mockInteractor.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    func testDidTapLoginButton_ShouldShowLoadingAndCallInteractor() {
        // given
        let testEmail = "test@test.com"
        let testPassword = "testPassword"
        
        // when
        presenter.didTapSignInButton(email: testEmail, password: testPassword)
        
        // then
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to show loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, true, "Loading indicator should be visible")
        XCTAssertTrue(mockInteractor.didCallSignIn, "Presenter should call interactor to sign in")
        XCTAssertEqual(mockInteractor.capturedEmail, testEmail)
        XCTAssertEqual(mockInteractor.capturedPassword, testPassword)
    }
    
    func testDidSignInSuccessfully_ShouldHideLoading() {
        // when
        presenter.didSignInSuccessfully()
        
        // then
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to hide loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, false, "Loading indicator should not be visible")
    }
    
    func testDidFailToSignIn_ShouldShowErrorAndHideLoading() {
        // given
        let someError = AppError.unknownError("Sign in failed")
        
        // when
        presenter.didFailToSignIn(with: someError)
        
        // then
        XCTAssertTrue(mockView.didCallShowError, "Presenter should instruct view to show error")
        XCTAssertEqual(mockView.errorMessage, ErrorManager.toUserMessage(from: someError), "Presenter should show correct error message")
        
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to hide loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, false, "Loading indicator should not be visible")
    }
    
    func testDidTapSignUpButton_ShouldCallRouter() {
        // when
        presenter.didTapSignUpButton()
        
        // then
        XCTAssertTrue(mockRouter.didCallNavigateToSignUp, "Presenter should call router to present sign up screen")
    }
    
    func testDidTapBackButton_ShouldCallRouter() {
        // when
        presenter.didTapBackButton()
        
        // then
        XCTAssertTrue(mockRouter.didCallDismissScene, "Presenter should call router to present login screen")
    }
}
