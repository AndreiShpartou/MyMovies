//
//  SignUpInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class SignUpInteractor: SignUpInteractorProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    // MARK: - Init
    init(presenter: SignUpInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }

    // MARK: - Public
    func signUp(email: String, password: String) {
        presenter?.didSignUpSuccessfully()
    }
}
