//
//  LoginInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import Foundation

final class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    private let authService: AuthServiceProtocol

    init(
        authService: AuthServiceProtocol = FirebaseAuthService(),
        presenter: LoginInteractorOutputProtocol? = nil
    ) {
        self.authService = authService
        self.presenter = presenter
    }

    // MARK: - Public
    func signIn(withEmail: String, password: String) {
        authService.signIn(withEmail: withEmail, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.presenter?.didSignInSuccessfully()
            case .failure(let error):
                self.presenter?.didFailToSignIn(with: error)
            }
        }
    }
}
