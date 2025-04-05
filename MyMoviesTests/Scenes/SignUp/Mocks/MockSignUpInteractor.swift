//
//  MockSignUpInteractor.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 05/04/2025.
//

import XCTest
@testable import MyMovies

// MARK: - MockInteractor
final class MockSignUpInteractor: SignUpInteractorProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    var didCallSignUp: Bool = false
    var capturedEmail: String?
    var capturedPassword: String?
    var capturedFullName: String?
    
    func signUp(email: String, password: String, fullName: String) {
        didCallSignUp = true
        capturedEmail = email
        capturedPassword = password
        capturedFullName = fullName
    }
}
