//
//  SignUpPresenterTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 05/04/2025.
//

import XCTest
@testable import MyMovies

final class SignUpPresenterTests: XCTestCase {
    // System Under Test (SUT)
    var presenter: SignUpPresenterProtocol!
    // Mock dependencies
    var mockView: MockSignUpView!
    var mockInteractor: MockSignUpInteractor!
    var mockRouter: MockSignUpRouter!
    
    override func setUp() {
        super.setUp()
        
        mockView = MockSignUpView()
        mockInteractor = MockSignUpInteractor()
        mockRouter = MockSignUpRouter()
        presenter = SignUpPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
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
    func testDidTapSignUpButton_ShouldShowLoadingAndCallInteractor() {
        // given
        let testEmail = "test@test.com"
        let testPassword = "testPassword"
        let testFullName = "testFullName"
        
        // when
        presenter.didTapSignUpButton(email: testEmail, password: testPassword, fullName: testFullName)

        // then
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to show loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, true, "Loading indicator should be visible")
        XCTAssertTrue(mockInteractor.didCallSignUp, "Presenter should call interactor to sign up")
        XCTAssertEqual(mockInteractor.capturedEmail, testEmail)
        XCTAssertEqual(mockInteractor.capturedPassword, testPassword)
        XCTAssertEqual(mockInteractor.capturedFullName, testFullName)
    }
    
    func testDidSignUpSuccessfully_ShouldHideLoading() {
        // when
        presenter.didSignUpSuccessfully()
        
        // then
        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to hide loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, false, "Loading indicator should not be visible")
    }
    
    func testDidFailToSignUp_ShouldShowErrorAndHideLoading() {
        // given
        let someError = AppError.unknownError("Sign up failed")
        
        // when
        presenter.didFailToSignUp(with: someError)
        
        // then
        XCTAssertTrue(mockView.didCallShowError, "Presenter should instruct view to show error")
        XCTAssertEqual(mockView.errorMessage, ErrorManager.toUserMessage(from: someError), "Presenter should show correct error message")

        XCTAssertTrue(mockView.didCallSetLoadingIndicator, "Presenter should instruct view to hide loading indicator")
        XCTAssertEqual(mockView.isLoadingIndicatorVisible, false, "Loading indicator should not be visible")
        
    }
}
