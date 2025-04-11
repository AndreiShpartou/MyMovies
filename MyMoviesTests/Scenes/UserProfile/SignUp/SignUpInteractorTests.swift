//
//  SignUpInteractorTests.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 07/04/2025.
//

import XCTest
@testable import MyMovies

final class SignUpInteractorTests: XCTestCase {
    // System Under Test (SUT)
    var interactor: SignUpInteractor!
    // Mock dependencies
    var mockPresenter: MockSignUpPresenter!
    var mockAuthService: MockAuthService!
    var mockProfileDocumentsStoreService: MockProfileDocumentsStoreService!

    override func setUp() {
        super.setUp()
        
        mockPresenter = MockSignUpPresenter()
        mockAuthService = MockAuthService()
        mockProfileDocumentsStoreService = MockProfileDocumentsStoreService()
        interactor = SignUpInteractor(
            authService: mockAuthService,
            profileDocumentsStoreService: mockProfileDocumentsStoreService,
            presenter: mockPresenter
        )
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockAuthService = nil
        mockProfileDocumentsStoreService = nil

        super.tearDown()
    }

    func testSignUp_Success() {
        // given
        mockAuthService.shouldFailOnCreateUser = false
        mockProfileDocumentsStoreService.shouldFailOnSetData = false
        let expectation = expectation(description: "Should call didCallDidSignUpSuccessfullyCallBack during 0.5 seconds")

        // signUp contain inner async call, therefore we need to wait
        mockPresenter.didCallDidSignUpSuccessfullyCallBack = {
            XCTAssertTrue(true, "Shoud sign up successfully")
            expectation.fulfill()
        }

        // when
        interactor.signUp(email: "test@email.com", password: "testPassword", fullName: "Name Test")

        // then
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSignUp_CreateUserFailure() {
        // given
        mockAuthService.shouldFailOnCreateUser = true
        mockProfileDocumentsStoreService.shouldFailOnSetData = false
        let expectation = expectation(description: "Should call didCallDidFailToSignUpCallBack during 0.5 seconds")

        mockPresenter.didCallDidFailToSignUpCallBack = {
            XCTAssertTrue(true, "Shoud fail to sign up, because create user failed")
            expectation.fulfill()
        }
        
        // when
        interactor.signUp(email: "test@email.com", password: "testPassword", fullName: "Name Test")

        // then
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSignUp_SetDataFailure() {
        // given
        mockAuthService.shouldFailOnCreateUser = false
        mockProfileDocumentsStoreService.shouldFailOnSetData = true
        let expectation = expectation(description: "Should call didCallDidFailToSignUpCallBack during 0.5 seconds")

        mockPresenter.didCallDidFailToSignUpCallBack = {
            XCTAssertTrue(true, "Shoud fail to sign up because set data failed")
            expectation.fulfill()
        }

        // when
        interactor.signUp(email: "test@email.com", password: "testPassword", fullName: "Name Test")

        // then
        wait(for: [expectation], timeout: 0.5)
    }

}
