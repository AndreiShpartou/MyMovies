//
//  MockLoginInteractor.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import Foundation
@testable import MyMovies

final class MockLoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    var didCallSignIn: Bool = false
    var capturedEmail: String?
    var capturedPassword: String?
    
    func signIn(withEmail: String, password: String) {
        didCallSignIn = true
        capturedEmail = withEmail
        capturedPassword = password
    }
}
