//
//  LoginInteractorTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import XCTest
@testable import MyMovies

final class LoginInteractorTests: XCTestCase {
    // System Under Test (SUT)
    var interactor: LoginInteractor!
    // Mock dependencies
    var mockPresenter: MockLoginPresenter!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()

        mockPresenter = MockLoginPresenter()
        mockAuthService = MockAuthService()
        interactor = LoginInteractor(authService: mockAuthService, presenter: mockPresenter)
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockAuthService = nil

        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSignIn() {
        // given
        mockAuthService.shouldFailOnSignIn = false
        let expectation = expectation(description: "Should call didCallDidSignInSuccessfullyCallBack during 0.5 seconds")

        mockPresenter.didCallDidSignInSuccessfullyCallBack = {
            XCTAssertTrue(true, "Shoud sign in successfully")
            expectation.fulfill()
        }

        // when
        interactor.signIn(withEmail: "test@email.com", password: "testPassword")

        // then
        wait(for: [expectation], timeout: 0.5)
    }

    func testSignIn_Failure() {
        // given
        mockAuthService.shouldFailOnSignIn = true
        let expectation = expectation(description: "Should call didCallDidFailToSignInCallBack during 0.5 seconds")

        mockPresenter.didCallDidFailToSignInCallBack = {
            XCTAssertTrue(true, "Shoud fail to sign in")
            expectation.fulfill()
        }

        // when
        interactor.signIn(withEmail: "test@email.com", password: "testPassword")

        // then
        wait(for: [expectation], timeout: 0.5)
    }
}
