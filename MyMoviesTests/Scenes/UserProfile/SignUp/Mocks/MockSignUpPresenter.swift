//
//  MockSignUpPresenter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 07/04/2025.
//
@testable import MyMovies

// MARK: - MockSignUpPresenter
final class MockSignUpPresenter: SignUpInteractorOutputProtocol {
    var didCallDidSignUpSuccessfullyCallBack: (() -> Void)?
    var didCallDidFailToSignUpCallBack: (() -> Void)?
    
    // MARK: - SignUpPresenterProtocol
    func didSignUpSuccessfully() {
        didCallDidSignUpSuccessfullyCallBack?()
    }
    
    func didFailToSignUp(with error: Error) {
        didCallDidFailToSignUpCallBack?()
    }
}
