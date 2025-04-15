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
    private var presenter: LoginPresenterProtocol!
    // Mock dependencies
    private var mockView: MockLoginView!
    private var mockInteractor: MockLoginInteractor!
    private var mockRouter: MockLoginRouter!
    
    override func setUp() {
        super.setUp()
        
//        mockView = MockLoginView()
//        mockInteractor = MockLoginInteractor()
//        mockRouter = MockLoginRouter()
//        presenter = LoginPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
//        mockInteractor.presenter = presenter
    }

    override func tearDown() {
        super.tearDown()
    }
}
